package org.csu.config; // 请确保包名正确

import com.fasterxml.jackson.databind.ObjectMapper;
import org.csu.domain.Message;
import org.csu.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class MsgWebSocketHandler extends TextWebSocketHandler {

    private static final Logger logger = LoggerFactory.getLogger(MsgWebSocketHandler.class);

    // 看板数据存储 - roomId -> BoardData
    private static final Map<String, Map<String, Object>> BOARD_ROOMS = new ConcurrentHashMap<>();
    // 房间用户 - roomId -> Set<userId>
    private static final Map<String, Set<String>> ROOM_USERS = new ConcurrentHashMap<>();

    @Autowired
    private MessageService messageService;

    @Autowired
    private ObjectMapper objectMapper;

    // 用于存储所有已连接用户的 session，Key是用户ID，Value是对应的WebSocketSession
    private static final Map<String, WebSocketSession> SESSIONS = new ConcurrentHashMap<>();

    /**
     * 当一个新的 WebSocket 连接成功建立后，此方法被调用。
     * @param session 代表当前连接的会话
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String userId = null;
        try {
            URI uri = session.getUri();
            // 1. 从连接的URL中解析出用户ID (uid)
            if (uri == null || uri.getQuery() == null || !uri.getQuery().contains("uid=")) {
                logger.error("连接请求缺少'uid'参数，连接被拒绝。");
                session.close(CloseStatus.BAD_DATA.withReason("User ID is required"));
                return;
            }

            userId = uri.getQuery().split("uid=")[1];
            if (userId.isEmpty()) {
                logger.error("'uid'参数值为空，连接被拒绝。");
                session.close(CloseStatus.BAD_DATA.withReason("User ID cannot be empty"));
                return;
            }

            // 2. 处理重复连接：如果该用户已有连接，先优雅地关闭旧的
            if (SESSIONS.containsKey(userId)) {
                WebSocketSession oldSession = SESSIONS.get(userId);
                if (oldSession != null && oldSession.isOpen()) {
                    logger.warn("用户 {} 已存在一个旧的连接 (Session ID: {}), 正在关闭旧连接...", userId, oldSession.getId());
                    oldSession.close(CloseStatus.POLICY_VIOLATION.withReason("New connection established"));
                }
            }

            // 3. 将新的连接会话存入在线列表
            SESSIONS.put(userId, session);
            logger.info("用户 {} 成功建立新连接！Session ID: {}. 当前在线人数: {}", userId, session.getId(), SESSIONS.size());

            // ===== 【看板相关代码开始】 =====
            // 解析roomId（可选，默认为"default"）
            String roomId = "default"; // 默认房间
            if (uri.getQuery().contains("roomId=")) {
                String[] params = uri.getQuery().split("&");
                for (String param : params) {
                    if (param.startsWith("roomId=")) {
                        roomId = param.split("=")[1];
                        break;
                    }
                }
            }

            // 将用户添加到房间
            ROOM_USERS.computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet()).add(userId);

            // 在session中存储roomId
            session.getAttributes().put("roomId", roomId);
            session.getAttributes().put("userId", userId);

            logger.info("用户 {} 加入房间 {}，房间当前用户：{}", userId, roomId, ROOM_USERS.get(roomId));

            // 广播用户加入事件
            Map<String, Object> userJoinMessage = new HashMap<>();
            userJoinMessage.put("type", "user_join");
            userJoinMessage.put("userId", userId);
            userJoinMessage.put("onlineUsers", ROOM_USERS.get(roomId));
            broadcastToRoom(roomId, userId, userJoinMessage);

            // 发送当前看板数据给新用户
            if (BOARD_ROOMS.containsKey(roomId)) {
                Map<String, Object> syncMessage = new HashMap<>();
                syncMessage.put("type", "board_sync");
                syncMessage.put("data", BOARD_ROOMS.get(roomId));
                session.sendMessage(new TextMessage(objectMapper.writeValueAsString(syncMessage)));
            }
            // ===== 【看板相关代码结束】 =====

            // 4. 为该用户推送初始化的消息列表（原有逻辑保持不变）
            try {
                // 调用我们修复好的 Service 方法，获取每个对话的最新一条消息
                List<Message> initialMessages = messageService.getInitialMessages(userId);
                if (initialMessages != null && !initialMessages.isEmpty()) {
                    logger.info("为用户 {} 推送 {} 条初始会话消息。", userId, initialMessages.size());
                    // 将整个列表一次性作为JSON数组字符串发给前端
                    session.sendMessage(new TextMessage(objectMapper.writeValueAsString(initialMessages)));
                    logger.info("用户 {} 的初始消息推送完成。", userId);
                }
            } catch (Exception e) {
                logger.error("在推送初始消息时发生异常，用户ID: {}, 异常: {}", userId, e.getMessage(), e);
            }

        } catch (Exception e) {
            logger.error("在建立连接的初始阶段发生严重异常", e);
            if (session.isOpen()) {
                session.close(CloseStatus.SERVER_ERROR.withReason("Connection setup failed"));
            }
        }
    }

    /**
     * 当从客户端收到一个文本消息时，此方法被调用。
     * @param session 当前会话
     * @param textMessage 收到的文本消息
     */
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
        String userId = (String) session.getAttributes().get("userId");
        String roomId = (String) session.getAttributes().get("roomId");

        // 如果没有看板信息，使用原有方式查找用户ID
        if (userId == null) {
            userId = findUserIdBySession(session);
        }

        if (userId == null) {
            logger.warn("收到来自一个未知或已过时 Session 的消息，忽略。Session ID: {}", session.getId());
            return;
        }

        try {
            // 1. 解析前端发来的JSON字符串
            Map<String, Object> messageData = objectMapper.readValue(textMessage.getPayload(), HashMap.class);
            String type = (String) messageData.get("type");

            // 处理看板操作
            if ("board_operation".equals(type) && roomId != null) {
                handleBoardOperation(roomId, userId, messageData);
                return;
            }

            // 原有的聊天消息处理逻辑
            String receiverId = (String) messageData.get("to");
            String content = (String) messageData.get("content");

            if (receiverId == null || content == null) {
                logger.warn("收到的消息格式不正确，缺少 'to' 或 'content' 字段。");
                return;
            }

            // 2. 将消息保存到数据库
            Message savedMessage = messageService.saveMessage(userId, receiverId, content);
            logger.info("消息已存入数据库: From {} To {}", userId, receiverId);

            // 3. 尝试将消息实时推送给在线的接收者
            WebSocketSession receiverSession = SESSIONS.get(receiverId);
            if (receiverSession != null && receiverSession.isOpen()) {
                // 推送完整的、已保存的 Message 对象，确保前端收到带ID和时间戳的消息
                receiverSession.sendMessage(new TextMessage(objectMapper.writeValueAsString(savedMessage)));
                logger.info("消息已实时推送给在线用户 {}", receiverId);
            } else {
                logger.info("用户 {} 不在线，消息已存入数据库。", receiverId);
            }
        } catch (IOException e) {
            logger.error("处理文本消息时发生错误", e);
        }
    }

    /**
     * 处理看板操作
     */
    private void handleBoardOperation(String roomId, String userId, Map<String, Object> messageData) throws Exception {
        String operation = (String) messageData.get("operation");
        Map<String, Object> data = (Map<String, Object>) messageData.get("data");

        if (operation == null || data == null) {
            logger.warn("看板操作消息格式不正确");
            return;
        }

        // 更新房间的看板数据
        BOARD_ROOMS.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>());
        Map<String, Object> boardData = BOARD_ROOMS.get(roomId);

        // 根据操作类型更新数据
        switch (operation) {
            case "sync_board":
                if (data.containsKey("columns")) {
                    boardData.put("columns", data.get("columns"));
                }
                break;
            case "add_card":
            case "edit_card":
            case "delete_card":
            case "move_card":
                // 简单方式：直接存储整个columns数据
                if (data.containsKey("columns")) {
                    boardData.put("columns", data.get("columns"));
                }
                break;
        }

        // 广播给房间内其他用户
        Map<String, Object> broadcastMessage = new HashMap<>();
        broadcastMessage.put("type", "board_operation");
        broadcastMessage.put("operation", operation);
        broadcastMessage.put("data", data);
        broadcastMessage.put("fromUser", userId);

        broadcastToRoom(roomId, userId, broadcastMessage);

        logger.info("房间 {} 中用户 {} 执行了看板操作: {}", roomId, userId, operation);
    }

    /**
     * 向房间内其他用户广播消息
     */
    private void broadcastToRoom(String roomId, String excludeUserId, Map<String, Object> message) throws Exception {
        Set<String> roomUsers = ROOM_USERS.get(roomId);
        if (roomUsers == null) return;

        String messageJson = objectMapper.writeValueAsString(message);
        TextMessage textMessage = new TextMessage(messageJson);

        for (String targetUserId : roomUsers) {
            if (!targetUserId.equals(excludeUserId)) {
                WebSocketSession targetSession = SESSIONS.get(targetUserId);
                if (targetSession != null && targetSession.isOpen()) {
                    try {
                        targetSession.sendMessage(textMessage);
                    } catch (Exception e) {
                        logger.error("向用户 {} 发送消息失败", targetUserId, e);
                    }
                }
            }
        }
    }

    /**
     * 当一个 WebSocket 连接关闭后，此方法被调用。
     * @param session 关闭的会话
     * @param status 关闭的状态和原因
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String userId = (String) session.getAttributes().get("userId");
        String roomId = (String) session.getAttributes().get("roomId");

        // 如果没有从attributes获取到，使用原有方式
        if (userId == null) {
            userId = findUserIdBySession(session);
        }

        if (userId != null) {
            // 【重要】只有当关闭的 session 是当前存储的 session 时，才执行移除操作
            // 这可以防止旧连接的关闭事件错误地移除了新的、健康的连接
            WebSocketSession currentSession = SESSIONS.get(userId);
            if(currentSession != null && session.getId().equals(currentSession.getId())) {
                SESSIONS.remove(userId);

                // 从房间中移除用户
                if (roomId != null) {
                    Set<String> roomUsers = ROOM_USERS.get(roomId);
                    if (roomUsers != null) {
                        roomUsers.remove(userId);

                        // 广播用户离开事件
                        try {
                            Map<String, Object> userLeaveMessage = new HashMap<>();
                            userLeaveMessage.put("type", "user_leave");
                            userLeaveMessage.put("userId", userId);
                            userLeaveMessage.put("onlineUsers", roomUsers);
                            broadcastToRoom(roomId, userId, userLeaveMessage);
                        } catch (Exception e) {
                            logger.error("广播用户离开事件失败", e);
                        }

                        // 如果房间空了，清理房间数据
                        if (roomUsers.isEmpty()) {
                            ROOM_USERS.remove(roomId);
                            BOARD_ROOMS.remove(roomId);
                            logger.info("房间 {} 已清空", roomId);
                        }
                    }
                }

                logger.info("用户 {} 的连接已确认关闭。状态: {}. 当前在线人数: {}", userId, status, SESSIONS.size());
            } else {
                logger.info("一个旧的、已被覆盖的 Session ({}) 已关闭。", session.getId());
            }
        }
    }

    /**
     * 在处理消息时发生传输错误时，此方法被调用。
     */
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        logger.error("WebSocket 传输错误！Session ID: " + session.getId(), exception);
    }

    /**
     * 辅助方法：通过 WebSocketSession 对象反向查找用户ID
     */
    private String findUserIdBySession(WebSocketSession session) {
        return SESSIONS.entrySet()
                .stream()
                .filter(entry -> entry.getValue().getId().equals(session.getId()))
                .map(Map.Entry::getKey)
                .findFirst()
                .orElse(null);
    }
}
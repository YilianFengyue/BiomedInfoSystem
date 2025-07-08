package org.csu.config;

import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import lombok.RequiredArgsConstructor;
import org.csu.dao.MessageDao;
import org.csu.domain.Message;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@RequiredArgsConstructor
public class MsgWebSocketHandler extends TextWebSocketHandler {

    private static final Map<String, WebSocketSession> sessionMap = new ConcurrentHashMap<>();

    private final MessageDao messageMapper;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String uid = getUid(session);
        sessionMap.put(uid, session);

        // 用户上线时推送未读消息
        pushUnreadMessages(uid);
    }

    private void pushUnreadMessages(String userId) throws IOException {
        List<Message> unreadMessages = messageMapper.selectList(
                new QueryWrapper<Message>()
                        .eq("receiver_id", userId)
                        .eq("read_status", 0)
                        .orderByAsc("send_time")
        );

        WebSocketSession session = sessionMap.get(userId);
        if (session != null && session.isOpen()) {
            for (Message msg : unreadMessages) {
                JSONObject jsonMsg = new JSONObject();
                jsonMsg.put("id", msg.getId());
                jsonMsg.put("from", msg.getSenderId());
                jsonMsg.put("status", msg.getReadStatus());
                jsonMsg.put("content", msg.getContent());
                session.sendMessage(new TextMessage(jsonMsg.toJSONString()));
                // 不直接标记已读，等客户端确认
            }
        }
    }


    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        JSONObject json = JSON.parseObject(payload);

        String from = json.getString("from");
        String to = json.getString("to");
        String content = json.getString("content");

        // 1. 保存到数据库，readStatus默认为0（未读）
        Message msg = new Message();
        msg.setSenderId(from);
        msg.setReceiverId(to);
        msg.setContent(content);
        msg.setSendTime(LocalDateTime.now());
        msg.setReadStatus(0);
        messageMapper.insert(msg);

        // 2. 构造完整消息 JSON，包含消息 id 和内容
        JSONObject jsonMsg = new JSONObject();
        jsonMsg.put("id", msg.getId());
        jsonMsg.put("from", from);
        jsonMsg.put("status", msg.getReadStatus());
        jsonMsg.put("content", msg.getContent());

        // 3. 发送给在线目标用户，不做已读标记
        WebSocketSession toSession = sessionMap.get(to);
        if (toSession != null && toSession.isOpen()) {
            toSession.sendMessage(new TextMessage(jsonMsg.toJSONString()));
        }
    }


    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessionMap.values().removeIf(s -> s.getId().equals(session.getId()));
    }

    private String getUid(WebSocketSession session) {
        String query = session.getUri().getQuery(); // uid=user1
        return query.split("=")[1];
    }
}



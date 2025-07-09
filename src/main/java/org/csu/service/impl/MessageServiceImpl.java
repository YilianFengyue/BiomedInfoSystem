package org.csu.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.dao.MessageDao;
import org.csu.domain.Message;
import org.csu.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MessageServiceImpl implements MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageServiceImpl.class);

    @Autowired
    private MessageDao messageRepository;

    @Override
    public List<Message> getInitialMessages(String userId) {
        logger.info("[Service] 正在为用户 {} 获取初始消息列表...", userId);

        // 1. 找出所有与该用户相关的消息
        List<Message> allRelatedMessages = messageRepository.selectList(
                new QueryWrapper<Message>()
                        .eq("sender_id", userId)
                        .or()
                        .eq("receiver_id", userId)
                        .orderByDesc("send_time")
        );

        // 2. 在 Java 内存中进行分组和筛选，找出每个对话的最新一条消息
        return allRelatedMessages.stream()
                .collect(Collectors.groupingBy(
                        message -> {
                            // 按“对方”的ID进行分组
                            return message.getSenderId().equals(userId) ? message.getReceiverId() : message.getSenderId();
                        },
                        // downstream collector: 取每个分组的第一条（也就是最新的一条）
                        Collectors.collectingAndThen(
                                Collectors.toList(),
                                list -> list.get(0)
                        )
                ))
                .values() // 获取所有对话的最新消息
                .stream()
                .collect(Collectors.toList());
    }

    @Override
    public Message saveMessage(String senderId, String receiverId, String content) {
        Message message = new Message();
        message.setSenderId(senderId);
        message.setReceiverId(receiverId);
        message.setContent(content);
        message.setSendTime(LocalDateTime.now());
        message.setReadStatus(0); // 新消息默认为未读
        messageRepository.insert(message);
        return message;
    }

    @Override
    @Transactional
    public void markMessageAsRead(Long messageId) {
        UpdateWrapper<Message> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("read_status", 1)
                .eq("id", messageId)
                .eq("read_status", 0);
        messageRepository.update(null, updateWrapper);
    }

    @Override
    public IPage<Message> getHistoryMessages(String userId1, String userId2, int pageNum, int pageSize) {
        Page<Message> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Message> queryWrapper = new QueryWrapper<>();
        queryWrapper.and(wrapper -> wrapper.eq("sender_id", userId1).eq("receiver_id", userId2))
                .or(wrapper -> wrapper.eq("sender_id", userId2).eq("receiver_id", userId1));
        queryWrapper.orderByDesc("send_time");
        return messageRepository.selectPage(page, queryWrapper);
    }

    @Override
    public void deleteMessage(Long messageId) {
        messageRepository.deleteById(messageId);
    }

    @Override
    public List<Message> getAllHistoryMessages(String userId1, String userId2) {
        logger.info("[Service] 正在为用户 {} 和 {} 获取全部历史消息...", userId1, userId2);
        QueryWrapper<Message> queryWrapper = new QueryWrapper<>();

        // 查询条件：(A发给B) 或 (B发给A)
        queryWrapper.and(wrapper -> wrapper.eq("sender_id", userId1).eq("receiver_id", userId2))
                .or(wrapper -> wrapper.eq("sender_id", userId2).eq("receiver_id", userId1));

        // 【重要】按发送时间正序排列，确保聊天记录从上到下是正确的顺序
        queryWrapper.orderByAsc("send_time");

        return messageRepository.selectList(queryWrapper);
    }
}
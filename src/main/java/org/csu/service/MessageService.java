package org.csu.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.csu.domain.Message;
import java.util.List;

public interface MessageService {

    /**
     * 【已修复】获取用户登录时，初始化的消息列表。
     * 这会获取每个对话的最新一条消息。
     */
    List<Message> getInitialMessages(String userId);

    /**
     * 保存一条新消息
     */
    Message saveMessage(String senderId, String receiverId, String content);

    /**
     * 将单条消息标记为已读
     */
    void markMessageAsRead(Long messageId);

    /**
     * 分页获取两个用户间的历史消息
     */
    IPage<Message> getHistoryMessages(String userId1, String userId2, int pageNum, int pageSize);

    /**
     * 删除一条消息
     */
    void deleteMessage(Long messageId);

    List<Message> getAllHistoryMessages(String userId1, String userId2);
}

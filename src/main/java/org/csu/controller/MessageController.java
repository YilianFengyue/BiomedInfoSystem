package org.csu.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.RequiredArgsConstructor;
import org.csu.domain.Message;
import org.csu.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/messages") // 建议统一路径前缀为 /api/messages 或 /messages
@RequiredArgsConstructor
public class MessageController {

    private static final Logger logger = LoggerFactory.getLogger(MessageController.class);

    // 使用 final 和 @RequiredArgsConstructor (Lombok) 是一种更推荐的注入方式
    // 如果不使用Lombok，可以使用 @Autowired
    @Autowired
    private final MessageService messageService;

    /**
     * 分页获取当前用户的历史消息
     * @param userId 当前用户的ID
     ** @param contactId 对方联系人的ID
     * @param pageNum 当前页码，默认为1
     * @param pageSize 每页数量，默认为10
     * @return 分页的消息数据
     */
    @GetMapping("/history")
    public Result getHistory(
            @RequestParam String userId,
            @RequestParam String contactId,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize
    ) {
        try {
            IPage<Message> page = messageService.getHistoryMessages(userId, contactId, pageNum, pageSize);
            return Result.success(page);
        } catch (Exception e) {
            // 在实际项目中，最好有一个全局异常处理器来处理这些错误
            return Result.error("获取历史消息失败: " + e.getMessage());
        }
    }


    /**
     * 将单条消息标记为已读
     * @param messageId 要标记的消息ID
     * @return 操作结果
     */
    @PostMapping("/read")
    public Result markAsRead(@RequestParam Long messageId) {
        // ====================【添加详细日志】====================
        logger.info("!!!!!!!!!!!!!! [Controller] /api/messages/read 接口被调用 !!!!!!!!!!!!!!");
        logger.info("!!!!!!!!!!!!!! [Controller] 准备将 messageId: {} 标记为已读... !!!!!!!!!!!!!!", messageId);
        // ========================================================
        try {
            messageService.markMessageAsRead(messageId);
            logger.info("!!!!!!!!!!!!!! [Controller] Service层执行完毕，返回成功结果。 !!!!!!!!!!!!!!");
            return Result.success("标记已读成功");
        } catch (Exception e) {
            logger.error("!!!!!!!!!!!!!! [Controller] 调用Service层时发生异常! !!!!!!!!!!!!!!", e);
            return Result.error("标记已读失败: " + e.getMessage());
        }
    }


    /**
     * 删除单条消息（逻辑删除或物理删除，取决于业务）
     * @param messageId 要删除的消息ID
     * @return 操作结果
     */
    @DeleteMapping("/delete")
    public Result deleteMessage(@RequestParam Long messageId) {
        try {
            messageService.deleteMessage(messageId);
            return Result.success("删除成功");
        } catch (Exception e) {
            return Result.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 获取两个用户之间的所有历史消息
     * @param userId 当前用户的ID
     * @param contactId 对方联系人的ID
     * @return 完整的消息列表
     */
    @GetMapping("/history/all")
    public Result getAllHistory(
            @RequestParam String userId,
            @RequestParam String contactId
    ) {
        try {
            List<Message> allMessages = messageService.getAllHistoryMessages(userId, contactId);
            return Result.success(allMessages);
        } catch (Exception e) {
            return Result.error("获取全部历史消息失败: " + e.getMessage());
        }
    }
}



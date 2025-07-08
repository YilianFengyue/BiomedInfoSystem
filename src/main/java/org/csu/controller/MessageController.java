package org.csu.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.csu.dao.MessageDao;
import org.csu.domain.Message;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/messages")
@RequiredArgsConstructor
public class MessageController {
    private final MessageDao messageDao;

    @PostMapping("/read")
    public Result markAsRead(@RequestParam Long messageId) {
        Message msg = new Message();
        msg.setId(messageId);
        msg.setReadStatus(1);
        messageDao.updateById(msg);
        return Result.success(msg);
    }

    @GetMapping("/history")
    public IPage<Message> getHistory(@RequestParam String userId,
                                     @RequestParam int page,
                                     @RequestParam int size) {
        Page<Message> pageRequest = new Page<>(page, size);
        return messageDao.selectPage(pageRequest,
                new QueryWrapper<Message>().eq("receiver_id", userId).orderByDesc("send_time"));
    }

    @DeleteMapping("/delete")
    public Result deleteMessage(@RequestParam Long messageId) {
        boolean removed = messageDao.deleteById(messageId) > 0;
        if (removed) {
            return Result.success("消息删除成功");
        } else {
            return Result.error("消息不存在或删除失败");
        }
    }
}



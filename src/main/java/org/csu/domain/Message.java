package org.csu.domain;


import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Data
@TableName("message")
public class Message {

    private Long id;

    private String senderId;
    private String receiverId;
    private String content;
    private LocalDateTime sendTime;

    private Integer readStatus;  // 0 = 未读, 1 = 已读
}



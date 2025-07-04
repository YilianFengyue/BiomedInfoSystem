package org.csu.controller;

import io.livekit.server.AccessToken;
import io.livekit.server.RoomJoin;
import io.livekit.server.RoomName;
import io.livekit.server.CanPublish;
import io.livekit.server.CanPublishData;
import io.livekit.server.CanSubscribe;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/live")
public class LiveStreamController {

    // 从 application.yaml 文件中注入LiveKit的配置信息
    @Value("${livekit.api-key}")
    private String livekitApiKey;

    @Value("${livekit.api-secret}")
    private String livekitApiSecret;

    /**
     * 为前端生成LiveKit的访问令牌(Token) - 适配 livekit-server:0.10.0
     * @param payload 前端传来的JSON，应包含 roomName 和 identity
     * @return 包含JWT Token的响应
     */
    @PostMapping("/token")
    public Map<String, String> getLiveKitToken(@RequestBody Map<String, String> payload) {
        String roomName = payload.get("roomName");
        String identity = payload.get("identity"); // 用户的唯一标识, 如 "teacher-101"
        String name = payload.get("name");         // 用户的显示名称

        // 1. 创建 AccessToken 实例
        AccessToken token = new AccessToken(livekitApiKey, livekitApiSecret);

        // 2. 设置Token的基础信息
        token.setName(name);
        token.setIdentity(identity);
        token.setTtl(3600L); // 设置有效期，单位为秒 (例如1小时)

        // 3. 根据身份约定，设置不同的权限
        // 约定：以 "teacher-" 开头的为教师
        if (identity != null && identity.startsWith("teacher")) {
            // 教师权限：可以发布音视频和数据
            token.addGrants(
                    new RoomJoin(true),           // 允许加入房间
                    new RoomName(roomName),       // 指定房间名称
                    new CanPublish(true),         // 允许发布音视频
                    new CanPublishData(true),     // 允许发布数据
                    new CanSubscribe(true)        // 允许订阅其他参与者
            );
        } else {
            // 学生权限：只能订阅和发布数据，不能发布音视频
            token.addGrants(
                    new RoomJoin(true),           // 允许加入房间
                    new RoomName(roomName),       // 指定房间名称
                    new CanPublish(false),        // 不允许发布音视频
                    new CanPublishData(true),     // 允许发布数据(例如聊天)
                    new CanSubscribe(true)        // 允许订阅其他参与者
            );
        }

        // 4. 返回JWT格式的Token
        return Map.of("accessToken", token.toJwt());
    }
}
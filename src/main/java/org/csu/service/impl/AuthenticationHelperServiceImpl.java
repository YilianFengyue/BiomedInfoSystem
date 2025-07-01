package org.csu.service.impl;

import lombok.RequiredArgsConstructor;
import org.csu.domain.Users;
import org.csu.service.AuthenticationHelperService;
import org.csu.util.JWTUtil;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class AuthenticationHelperServiceImpl implements AuthenticationHelperService {
    private final StringRedisTemplate stringRedisTemplate;

    private static final String JWT_PREFIX = "Bearer ";

    public Map<String, String> handleLoginSuccess(Users user) {
        // 1. 生成 JWT
        Map<String, Object> claims = new HashMap<>();
        claims.put("id", user.getId());
        claims.put("username", user.getUsername());
        String rawJwt = JWTUtil.genToken(claims);

        // 2. 【在这里存入Redis】将 JWT 存入 Redis "白名单"
        if (rawJwt.startsWith(JWT_PREFIX)) {
            rawJwt = rawJwt.substring(JWT_PREFIX.length());
        }
        stringRedisTemplate.opsForValue().set(rawJwt, rawJwt, 12, TimeUnit.HOURS);

        // 3. 生成 CSRF Token
        String csrfToken = UUID.randomUUID().toString().replace("-", "");
        String csrfRedisKey = "csrf:" + user.getId();

        // 4. 【在这里存入Redis】将 CSRF Token 存入 Redis，并与用户ID关联
        stringRedisTemplate.opsForValue().set(csrfRedisKey, csrfToken, 12, TimeUnit.HOURS);

        // 5. 准备好要返回给前端的数据
        Map<String, String> responseData = new HashMap<>();
        responseData.put("token", rawJwt);
        responseData.put("csrf_token", csrfToken);

        return responseData;
    }
}

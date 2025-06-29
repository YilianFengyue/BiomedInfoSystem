package org.csu.config.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.csu.util.JWTUtil;
import org.csu.util.ThreadLocalUtil;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.security.MessageDigest;
import java.util.Collections;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain)
            throws ServletException, IOException {

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            filterChain.doFilter(request, response);
            return;
        }

        final String authToken = request.getHeader("Authorization");

        if (authToken == null || authToken.isEmpty()) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            ValueOperations<String, String> ops = stringRedisTemplate.opsForValue();

            if (Boolean.FALSE.equals(stringRedisTemplate.hasKey(authToken))) {
                throw new Exception("认证失败: Token无效或已下线");
            }

            Map<String, Object> claims = JWTUtil.parseToken(authToken);
            validateCsrfToken(request, claims, ops);

            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    claims.get("username"), null, Collections.emptyList());
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);

            ThreadLocalUtil.set(claims);
            filterChain.doFilter(request, response);

        } catch (Exception e) {
            log.error("认证或授权失败: {}", e.getMessage());
            SecurityContextHolder.clearContext();
            int statusCode = (e instanceof CsrfException) ? 403 : 401;
            response.setStatus(statusCode);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(objectMapper.writeValueAsString(Map.of("message", e.getMessage())));
        } finally {
            ThreadLocalUtil.remove();
        }
    }

    private void validateCsrfToken(HttpServletRequest request, Map<String, Object> claims, ValueOperations<String, String> ops) throws CsrfException {
        String method = request.getMethod();
        if (!"GET".equalsIgnoreCase(method) && !"HEAD".equalsIgnoreCase(method)) {
            String csrfTokenFromHeader = request.getHeader("X-CSRF-TOKEN");
            if (csrfTokenFromHeader == null) {
                throw new CsrfException("缺少CSRF Token");
            }
            Object userId = claims.get("id");
            if (userId == null) {
                throw new IllegalStateException("JWT中缺少用户信息");
            }
            String csrfRedisKey = "csrf:" + userId;
            String csrfTokenFromRedis = ops.get(csrfRedisKey);
            if (csrfTokenFromRedis == null) {
                throw new CsrfException("CSRF Token已失效");
            }
            if (!MessageDigest.isEqual(csrfTokenFromHeader.getBytes(), csrfTokenFromRedis.getBytes())) {
                throw new CsrfException("CSRF Token校验失败");
            }
        }
    }

    private static class CsrfException extends RuntimeException {
        public CsrfException(String message) {
            super(message);
        }
    }
}
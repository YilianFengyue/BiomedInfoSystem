package org.csu.interceptors;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.csu.util.JWTUtil;
import org.csu.util.ThreadLocalUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Map;

@Component
public class Loginterceptor implements HandlerInterceptor {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

//    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
//        String token=request.getHeader("Authorization");
//        try {
//            //从redis中获取token
//            ValueOperations<String, String> stringStringValueOperations = stringRedisTemplate.opsForValue();
//            String s = stringStringValueOperations.get(token);
//            String s = stringStringValueOperations.get(token);
//            if(s==null){
//                throw new RuntimeException();
//            }
//            Map<String,Object> claims= JWTUtil.parseToken(token);
//
//            ThreadLocalUtil.set(claims);
//            return true;
//        } catch (Exception e) {
//            response.setStatus(401);
//            return false;
//        }
//    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 预检请求（OPTIONS）直接放行，这是CORS（跨域资源共享）的一部分
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String jwtToken = request.getHeader("Authorization");

        // 验证JWT Token
        try {
            // 验证JWT Token是否存在且有效
            if (jwtToken == null) {
                throw new RuntimeException("无认证信息");
            }

            // [保留您原有的Redis逻辑] - 检查JWT是否在Redis中（例如用于黑名单检查）
            ValueOperations<String, String> stringStringValueOperations = stringRedisTemplate.opsForValue();
            String storedToken = stringStringValueOperations.get(jwtToken);
            if (storedToken == null) {
                throw new RuntimeException("认证信息无效或已过期");
            }

            // 解析JWT，获取用户信息
            Map<String, Object> claims = JWTUtil.parseToken(jwtToken);


            // ================= 新增CSRF Token验证逻辑开始 =================

            // 1. 判断请求方法，通常GET, HEAD, OPTIONS等安全方法不需要CSRF保护
            String method = request.getMethod();
            if (!"GET".equalsIgnoreCase(method) && !"HEAD".equalsIgnoreCase(method)) {

                // 2. 从请求头中获取前端传来的CSRF Token
                String csrfTokenFromHeader = request.getHeader("X-CSRF-TOKEN");
                if (csrfTokenFromHeader == null) {
                    // 如果是需要保护的请求，但没有提供CSRF Token，则拒绝
                    throw new RuntimeException("缺少CSRF Token");
                }

                // 3. 从JWT的claims中获取用户ID
                Object userId = claims.get("id");
                if (userId == null) {
                    throw new RuntimeException("JWT中缺少用户信息");
                }

                // 4. 根据用户ID，从Redis中获取服务端存储的CSRF Token
                String csrfRedisKey = "csrf:" + userId;
                String csrfTokenFromRedis = stringStringValueOperations.get(csrfRedisKey);

                // 5. 比对两个Token是否一致
                if (!csrfTokenFromHeader.equals(csrfTokenFromRedis)) {
                    // 如果不一致，说明是伪造的请求，拒绝访问
                    throw new RuntimeException("CSRF Token校验失败");
                }
            }
            // ================= 新增CSRF Token验证逻辑结束 =================


            // 如果所有验证都通过，将用户信息存入ThreadLocal，方便后续Controller使用
            ThreadLocalUtil.set(claims);
            return true; // 放行请求

        } catch (Exception e) {
            // 统一处理所有验证失败的情况
            // 对于认证失败，返回401；对于CSRF失败，返回403更合适，但这里统一为401也行
            response.setStatus(401); // Unauthorized
            // 您也可以根据异常类型来设置不同的状态码
            // if (e.getMessage().contains("CSRF")) {
            //     response.setStatus(403); // Forbidden
            // }
            return false; // 拒绝请求
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
         ThreadLocalUtil.remove();
    }
}

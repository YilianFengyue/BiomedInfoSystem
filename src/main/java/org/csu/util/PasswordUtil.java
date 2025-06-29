package org.csu.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 基于 Spring Security 的密码处理工具类
 */
public class PasswordUtil {

    // 创建一个静态的、线程安全的 PasswordEncoder 实例
    // BCryptPasswordEncoder 是 Spring Security 提供的 BCrypt 算法实现
    private static final PasswordEncoder ENCODER = new BCryptPasswordEncoder();

    /**
     * 对明文密码进行哈希加密
     * @param plainTextPassword 明文密码
     * @return 哈希后的密码字符串
     */
    public static String hashPassword(String plainTextPassword) {
        return ENCODER.encode(plainTextPassword);
    }

    /**
     * 校验明文密码是否与哈希后的密码匹配
     * @param plainTextPassword 用户输入的明文密码
     * @param hashedPassword 数据库中存储的哈希密码
     * @return 如果匹配则返回 true, 否则返回 false
     */
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        return ENCODER.matches(plainTextPassword, hashedPassword);
    }
}
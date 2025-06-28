package org.csu.util;

import org.mindrot.jbcrypt.BCrypt;


public final class PasswordUtil {

    // 定义BCrypt的工作因子，推荐值为10-12。数值越大，哈希计算越慢，但越安全。
    private static final int WORK_FACTOR = 12;

    /**
     * 私有构造函数，防止实例化。
     */
    private PasswordUtil() {}

    /**
     * 对明文密码进行BCrypt哈希。
     *
     * @param plainPassword 需要哈希的明文密码。
     * @return 经过BCrypt哈希和加盐处理的密码字符串。
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        // BCrypt.gensalt()方法会自动生成一个随机盐
        String salt = BCrypt.gensalt(WORK_FACTOR);
        return BCrypt.hashpw(plainPassword, salt);
    }

    /**
     * 验证明文密码是否与一个已哈希的密码匹配。
     *
     * @param plainPassword  用户输入的明文密码。
     * @param hashedPassword 数据库中存储的BCrypt哈希密码。
     * @return 如果密码匹配，则返回true；否则返回false。
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || plainPassword.isEmpty() || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            // BCrypt.checkpw会自动从hashedPassword中提取盐，并进行比较
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // 如果hashedPassword格式不正确，checkpw会抛出异常
            // 在这种情况下，我们认为密码不匹配
            System.err.println("提供的哈希密码格式无效: " + e.getMessage());
            return false;
        }
    }

    /*
     * 示例用法
     */
//    public static void main(String[] args) {
//        String originalPassword = "mySecurePassword123";
//
//        // 1. 哈希密码（模拟用户注册）
//        String hashedPassword = hashPassword(originalPassword);
//        System.out.println("原始密码: " + originalPassword);
//        System.out.println("BCrypt 哈希后的密码 (存储在数据库): " + hashedPassword);
//        System.out.println("哈希值的长度: " + hashedPassword.length());
//
//        System.out.println("\n--- 验证密码 ---");
//
//        // 2. 验证正确的密码（模拟用户登录）
//        boolean isPasswordCorrect = checkPassword(originalPassword, hashedPassword);
//        System.out.println("使用正确密码进行验证: " + isPasswordCorrect); // 应该输出 true
//
//        // 3. 验证错误的密码
//        boolean isPasswordIncorrect = checkPassword("wrongPassword", hashedPassword);
//        System.out.println("使用错误密码进行验证: " + isPasswordIncorrect); // 应该输出 false
//
//        // 4. 演示即使是相同密码，每次生成的哈希也不同
//        String anotherHashedPassword = hashPassword(originalPassword);
//        System.out.println("\n再次哈希相同密码: " + anotherHashedPassword);
//        System.out.println("两次哈希是否相同: " + hashedPassword.equals(anotherHashedPassword)); // 应该输出 false
//        System.out.println("但验证时仍然有效: " + checkPassword(originalPassword, anotherHashedPassword)); // 应该输出 true
//    }
}
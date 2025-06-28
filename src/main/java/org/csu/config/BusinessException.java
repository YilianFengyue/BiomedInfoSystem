package org.csu.config;

import org.csu.controller.Code;

/**
 * 业务异常类
 * 用于封装业务处理过程中出现的异常，例如：用户名不存在、密码错误、数据校验失败等。
 * 继承自 RuntimeException，这是一个非受检异常，在代码中抛出时无需强制try-catch。
 */
public class BusinessException extends RuntimeException {

    /**
     * 异常状态码，与 'Code' 类中的常量对应
     */
    private Integer code;

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    /**
     * 构造函数
     * @param code 状态码
     * @param message 异常信息
     */
    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
    }

    /**
     * 构造函数
     * @param code 状态码
     * @param message 异常信息
     * @param cause 原始异常
     */
    public BusinessException(Integer code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }
}


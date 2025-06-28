package org.csu.config;

import org.csu.controller.Code;

/**
 * 系统异常类
 * 用于封装系统运行过程中出现的异常，例如：数据库访问超时、服务器内部错误、外部资源不可用等。
 * 继承自 RuntimeException。
 */
public class SystemException extends RuntimeException {

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
    public SystemException(Integer code, String message) {
        super(message);
        this.code = code;
    }

    /**
     * 构造函数，用于包装原始异常
     * @param code 状态码
     * @param message 异常信息
     * @param cause 原始异常，方便追踪问题根源
     */
    public SystemException(Integer code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }
}

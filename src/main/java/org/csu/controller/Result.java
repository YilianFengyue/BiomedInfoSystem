package org.csu.controller;

import lombok.Data;

@Data
public class Result<T> {
    //描述统一格式中的数据
    private T data;
    //描述统一格式中的编码，用于区分操作，可以简化配置0或1表示成功失败
    private Integer code;
    //描述统一格式中的消息，可选属性
    private String msg;

    public Result() {
    }
    //构造方法是方便对象的创建
    public Result(Integer code, T data) {
        this.data = data;
        this.code = code;
    }
    //构造方法是方便对象的创建
    public Result(Integer code, T data, String msg) {
        this.data = data;
        this.code = code;
        this.msg = msg;
    }
    
    /**
     * 成功响应
     */
    public static <T> Result<T> success(T data) {
        return new Result<>(Code.SUCCESS, data, "操作成功");
    }
    
    /**
     * 成功响应（无数据）
     */
    public static <T> Result<T> success() {
        return new Result<>(Code.SUCCESS, null, "操作成功");
    }
    
    /**
     * 失败响应
     */
    public static <T> Result<T> error(String message) {
        return new Result<>(Code.SYSTEM_ERR, null, message);
    }
    
    /**
     * 失败响应（指定错误码）
     */
    public static <T> Result<T> error(Integer code, String message) {
        return new Result<>(code, null, message);
    }

    /**
     * 【新增】成功响应（带自定义消息）
     * @param data 返回的数据
     * @param msg  自定义的成功消息
     */
    public static <T> Result<T> success(T data, String msg) {
        return new Result<>(Code.SUCCESS, data, msg);
    }

}

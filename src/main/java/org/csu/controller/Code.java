package org.csu.controller;

public class Code {
    // 操作成功
    public static final Integer SUCCESS = 20000;

    // 保存（新增）操作
    public static final Integer SAVE_OK = 20011;
    public static final Integer SAVE_ERR = 20010;

    // 删除操作
    public static final Integer DELETE_OK = 20021;
    public static final Integer DELETE_ERR = 20020;

    // 更新操作
    public static final Integer UPDATE_OK = 20031;
    public static final Integer UPDATE_ERR = 20030;

    // 查询操作
    public static final Integer GET_OK = 20041;
    public static final Integer GET_ERR = 20040;

    // 登录/认证
    public static final Integer LOGIN_OK = 20051;
    public static final Integer LOGIN_ERR = 20050;

    // 参数校验
    public static final Integer VALIDATE_OK = 20061;
    public static final Integer VALIDATE_ERR = 20060;

    // 权限相关
    public static final Integer UNAUTHORIZED = 40100;
    public static final Integer FORBIDDEN = 40300;

    // 未知错误
    public static final Integer SYSTEM_ERR = 50000;

    // 业务自定义（预留拓展）
    public static final Integer CUSTOM1_OK = 20111;
    public static final Integer CUSTOM1_ERR = 20110;
}

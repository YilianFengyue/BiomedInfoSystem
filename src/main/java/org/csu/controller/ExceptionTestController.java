package org.csu.controller;


import org.csu.config.BusinessException;
import org.csu.config.SystemException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test/exception")
public class ExceptionTestController {

    /**
     * 测试案例一：模拟业务异常 (BusinessException)
     * 场景：用户请求一个需要特定权限的资源，但权限不足。
     * 目标：这个异常应该被 `handleBusinessException` 方法捕获。
     */
    @GetMapping("/business")
    public Result testBusinessException() {
        // 模拟业务逻辑判断
        boolean hasPermission = false;
        if (!hasPermission) {
            // 直接抛出业务异常，附带明确的业务错误码和提示信息
            throw new BusinessException(Code.FORBIDDEN, "抱歉，您的权限不足，无法访问该资源。");
        }
        return new Result(Code.SUCCESS, null, "操作成功");
    }

    /**
     * 测试案例二：模拟系统异常 (SystemException)
     * 场景：在处理过程中，依赖的内部服务（如计算模块）出现问题。
     * 目标：这个异常应该被 `handleSystemException` 方法捕获。
     */
    @GetMapping("/system")
    public Result testSystemException() {

        try {
            int result = 10 / 0;
        } catch (Exception e) {

            throw new SystemException(Code.GET_ERR, "核心计算服务出现故障！", e);
        }
        return new Result(Code.SUCCESS, null, "操作成功");
    }


    @GetMapping("/unknown")
    public Result testUnknownException() {
        // 模拟一个未被预料到的运行时异常
        String data = null;
        if (data.equals("ok")) { // 这行会直接抛出 NullPointerException
            System.out.println("永远不会执行到这里");
        }
        return new Result(Code.SUCCESS, null, "操作成功");
    }
}

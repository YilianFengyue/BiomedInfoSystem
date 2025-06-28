package org.csu.config;



import org.csu.controller.Code;
import org.csu.controller.Result;
import org.csu.config.BusinessException;
import org.csu.config.SystemException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理器
 * 使用 @RestControllerAdvice 注解，使其成为一个全局的、作用于所有@RestController的增强类。
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);


    @ExceptionHandler(BusinessException.class)
    public Result handleBusinessException(BusinessException ex) {
        log.warn("业务异常: code={}, message={}", ex.getCode(), ex.getMessage());
        // 直接使用 ex.getMessage() 返回你定义的消息
        return new Result(ex.getCode(), null, ex.getMessage());
    }


    @ExceptionHandler(SystemException.class)
    public Result handleSystemException(SystemException ex) {
        log.error("系统异常: code={}, message={}", ex.getCode(), ex.getMessage(), ex.getCause());
        // TODO: 在这里可以添加发送邮件、短信等通知给运维或开发人员的逻辑

        // 直接使用 ex.getMessage() 返回你定义的消息
        return new Result(ex.getCode(), null, ex.getMessage());
    }


    @ExceptionHandler(Exception.class)
    public Result handleException(Exception ex) {
        log.error("未捕获的异常: ", ex);
        // TODO: 在这里同样可以添加通知逻辑

        // 对于完全未知的异常，返回一个统一的、模糊的错误提示
        return new Result(Code.SYSTEM_ERR, null, "系统开小差了，请稍后再试！");
    }
}

package org.csu.config;

import org.csu.controller.Code;
import org.csu.controller.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

/**
 * 全局异常处理器
 * 使用 @RestControllerAdvice 注解，使其成为一个全局的、作用于所有@RestController的增强类。
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BusinessException.class)
    public Result handleBusinessException(BusinessException ex) {
        log.warn("业务异常: {}", ex.getMessage());
        return new Result(ex.getCode(), null, ex.getMessage());
    }

    @ExceptionHandler(SystemException.class)
    public Result handleSystemException(SystemException ex) {
        log.error("系统异常: ", ex);
        return new Result(ex.getCode(), null, ex.getMessage());
    }

    /**
     * 处理JSR-303参数校验异常
     * @param e 校验失败的异常
     * @return 统一的错误响应
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result handleValidationExceptions(MethodArgumentNotValidException e) {
        String errorMessage = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getDefaultMessage())
                .collect(Collectors.joining("; "));
        
        log.warn("参数校验失败: {}", errorMessage);
        return new Result(Code.VALIDATE_ERR, null, errorMessage);
    }

    @ExceptionHandler(Exception.class)
    public Result handleException(Exception ex) {
        log.error("未捕获的异常: ", ex);
        return new Result(Code.SYSTEM_ERR, null, "系统开小差了，请稍后再试！");
    }
}

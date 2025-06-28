package org.csu.controller;

import org.csu.config.SystemException;
import org.csu.dao.HerbDao;
import org.csu.domain.Herb;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestHerbController {
    @Autowired
    private HerbDao herbDao;

    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        try{
            int i = 1/0;
        }catch (Exception e){
            throw new SystemException(Code.VALIDATE_ERR,"服务器访问超时，请重试!",e);
        }
        Herb herb=herbDao.selectById(id);
        Integer code = herb != null ? Code.GET_OK : Code.GET_ERR;
        String msg = herb != null ? "成功" : "数据查询失败，请重试！";
        return new Result(code,herb,msg);
    }
}

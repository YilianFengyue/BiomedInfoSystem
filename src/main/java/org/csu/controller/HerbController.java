package org.csu.controller;

import org.csu.domain.Herb;
import org.csu.service.IHerbService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/herb")
public class HerbController {

    @Autowired
    private IHerbService herbService;

    /**
     * 新增药材信息
     * @param herb
     * @return
     */
    @PostMapping
    public Result createHerb(@RequestBody Herb herb) {
        boolean flag = herbService.createHerb(herb);
        return new Result(flag ? Code.SAVE_OK : Code.SAVE_ERR, flag ? "新增成功" : "新增失败，请重试");
    }

    /**
     * 根据ID删除药材
     * @param id
     * @return
     */
    @DeleteMapping("/{id}")
    public Result deleteHerb(@PathVariable Long id) {
        boolean flag = herbService.deleteHerbById(id);

        return new Result(flag ? Code.DELETE_OK : Code.DELETE_ERR, flag ? "删除成功" : "删除失败，请重试");
    }

    /**
     * 更新药材信息
     * @param herb
     * @return
     */
    @PutMapping
    public Result updateHerb(@RequestBody Herb herb) {
        boolean flag = herbService.updateHerb(herb);
        return new Result(flag ? Code.UPDATE_OK : Code.UPDATE_ERR, flag ? "更新成功" : "更新失败，请重试");
    }

    /**
     * 根据ID查询药材
     * @param id
     * @return
     */
    @GetMapping("/{id}")
    public Result getHerbById(@PathVariable Long id) {
        Herb herb = herbService.getHerbById(id);
        Integer code = herb != null ? Code.GET_OK : Code.GET_ERR;
        String msg = herb != null ? "查询成功" : "数据查询失败，请重试！";
        return new Result(code, herb, msg);
    }

    /**
     * 查询所有药材信息
     * @return
     */
    @GetMapping
    public Result getAllHerbs() {
        List<Herb> herbList = herbService.getAllHerbs();
        Integer code = herbList != null ? Code.GET_OK : Code.GET_ERR;
        String msg = herbList != null ? "查询成功" : "数据查询失败，请重试！";
        return new Result(code, herbList, msg);
    }
}

package org.csu.controller;

import org.csu.domain.UserEvaluation;
import org.csu.dto.UserEvaluationDTO;
import org.csu.service.IUserEvaluationService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/evaluations")
public class UserEvaluationController {

    @Autowired
    private IUserEvaluationService userEvaluationService;

    private UserEvaluation convertToEntity(UserEvaluationDTO dto) {
        UserEvaluation entity = new UserEvaluation();
        BeanUtils.copyProperties(dto, entity);
        return entity;
    }

    private UserEvaluationDTO convertToDto(UserEvaluation entity) {
        UserEvaluationDTO dto = new UserEvaluationDTO();
        BeanUtils.copyProperties(entity, dto);
        return dto;
    }

    @PostMapping
    public Result create(@RequestBody UserEvaluationDTO userEvaluationDTO) {
        UserEvaluation userEvaluation = convertToEntity(userEvaluationDTO);
        boolean success = userEvaluationService.save(userEvaluation);
        return new Result(success ? Code.SAVE_OK : Code.SAVE_ERR, null, success ? "评价创建成功" : "评价创建失败");
    }

    @GetMapping
    public Result getAll() {
        List<UserEvaluation> evaluations = userEvaluationService.list();
        List<UserEvaluationDTO> dtos = evaluations.stream().map(this::convertToDto).collect(Collectors.toList());
        return new Result(Code.GET_OK, dtos, "查询成功");
    }

    @GetMapping("/{id}")
    public Result getById(@PathVariable Long id) {
        UserEvaluation evaluation = userEvaluationService.getById(id);
        if (evaluation == null) {
            return new Result(Code.GET_ERR, null, "评价不存在");
        }
        return new Result(Code.GET_OK, convertToDto(evaluation), "查询成功");
    }

    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody UserEvaluationDTO userEvaluationDTO) {
        userEvaluationDTO.setId(id);
        UserEvaluation userEvaluation = convertToEntity(userEvaluationDTO);
        boolean success = userEvaluationService.updateById(userEvaluation);
        return new Result(success ? Code.UPDATE_OK : Code.UPDATE_ERR, null, success ? "评价更新成功" : "评价更新失败");
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        boolean success = userEvaluationService.removeById(id);
        return new Result(success ? Code.DELETE_OK : Code.DELETE_ERR, null, success ? "评价删除成功" : "评价删除失败");
    }
}
package org.csu.controller;

import org.csu.controller.Result;
import org.csu.service.TcmService;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/graph")
public class GraphController {

    private final TcmService tcmService;


    public GraphController(TcmService tcmService) {
        this.tcmService = tcmService;
    }

    @GetMapping("/formula/{name}")
    public Result<Map<String, Object>> getGraphForFormula(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForFormula(name);
        return Result.success(graphData);
    }

    @GetMapping("/disease/{name}")
    public Result<Map<String, Object>> getGraphForDisease(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForDisease(name);
        return Result.success(graphData);
    }

    @GetMapping("/herb/{name}")
    public Result<Map<String, Object>> getGraphForHerb(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForHerb(name);
        return Result.success(graphData);
    }

    @GetMapping("/symptom/{name}")
    public Result<Map<String, Object>> getGraphForSymptom(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForSymptom(name);
        return Result.success(graphData);
    }

    @GetMapping("/syndrome/{name}")
    public Result<Map<String, Object>> getGraphForSyndrome(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForSyndrome(name);
        return Result.success(graphData);
    }

    @GetMapping("/meridian/{name}")
    public Result<Map<String, Object>> getGraphForMeridian(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForMeridian(name);
        return Result.success(graphData);
    }

    @GetMapping("/acupoint/{name}")
    public Result<Map<String, Object>> getGraphForAcupoint(@PathVariable String name) {
        Map<String, Object> graphData = tcmService.getGraphDataForAcupoint(name);
        return Result.success(graphData);
    }
}
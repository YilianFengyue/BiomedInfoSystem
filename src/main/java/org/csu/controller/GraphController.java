package org.csu.controller;

import org.csu.service.TcmService;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<Map<String, Object>> getGraphForFormula(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForFormula(name));
    }

    @GetMapping("/disease/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForDisease(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForDisease(name));
    }

    @GetMapping("/herb/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForHerb(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForHerb(name));
    }

    @GetMapping("/symptom/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForSymptom(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForSymptom(name));
    }

    @GetMapping("/syndrome/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForSyndrome(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForSyndrome(name));
    }

    @GetMapping("/meridian/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForMeridian(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForMeridian(name));
    }

    @GetMapping("/acupoint/{name}")
    public ResponseEntity<Map<String, Object>> getGraphForAcupoint(@PathVariable String name) {
        return ResponseEntity.ok(tcmService.getGraphDataForAcupoint(name));
    }
}
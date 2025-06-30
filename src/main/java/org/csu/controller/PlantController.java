package org.csu.controller;

import org.csu.service.IBaiduAiService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/plant")
public class PlantController {

    @Autowired
    private IBaiduAiService baiduAiService;

    @PostMapping("/recognize")
    public Result<Map<String, Object>> recognizePlant(@RequestParam("image") MultipartFile image) {
        if (image.isEmpty()) {
            return Result.error(Code.SAVE_ERR, "图片不能为空");
        }
        JSONObject result = baiduAiService.plantRecognition(image);
        if (result.has("error")) {
            return Result.error(Code.SYSTEM_ERR, result.getString("error"));
        }
        return new Result<>(Code.GET_OK, result.toMap(), "识别成功");
    }
}

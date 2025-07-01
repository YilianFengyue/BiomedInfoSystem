package org.csu.service;

import org.json.JSONObject;
import org.springframework.web.multipart.MultipartFile;

public interface IBaiduAiService {
    JSONObject plantRecognition(MultipartFile file);
}

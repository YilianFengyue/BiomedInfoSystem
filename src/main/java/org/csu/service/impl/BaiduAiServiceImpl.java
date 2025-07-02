package org.csu.service.impl;

import com.baidu.aip.imageclassify.AipImageClassify;
import org.csu.service.IBaiduAiService;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;

@Service
public class BaiduAiServiceImpl implements IBaiduAiService {

    @Autowired
    private AipImageClassify aipImageClassify;

    @Override
    public JSONObject plantRecognition(MultipartFile file) {
        try {
            byte[] data = file.getBytes();
            // 调用接口
            HashMap<String, String> options = new HashMap<String, String>();
            options.put("baike_num", "1"); // 返回百科信息
            JSONObject res = aipImageClassify.plantDetect(data, options);
            return res;
        } catch (IOException e) {
            e.printStackTrace();
            return new JSONObject().put("error", "Failed to read file data.");
        }
    }
}

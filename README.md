# 生物医药信息系统后端

这是一个基于 Spring Boot 的生物医药信息系统后端项目。

---

## **API文档**

**基础路径 (Base Path)**: `/api`

**通用响应格式**:
所有接口均返回统一的 `Result` 对象结构：

```json
{
  "code": Integer,  // 业务状态码
  "data": Object,   // 成功时返回的数据
  "msg": String     // 描述信息
}
```

---

## **一、 文件上传模块**

这是一个完整的工作流，前端需要按顺序调用两个接口。

### **1.1 获取文件上传策略**

此接口是文件上传的第一步。前端调用此接口获取一个包含签名和策略的临时凭证，然后使用此凭证将文件直接上传到阿里云OSS。

*   **Endpoint**: `GET /api/oss/policy`
*   **方法**: `GET`
*   **描述**: 获取前端直传到阿里云OSS所需的Policy和签名。
*   **请求参数**: 无
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": {
            "accessid": "your_aliyun_access_key_id",
            "policy": "base64_encoded_policy_string",
            "signature": "generated_signature_string",
            "dir": "user-uploads/",
            "host": "https://your-bucket-name.oss-cn-beijing.aliyuncs.com",
            "expire": "timestamp_in_seconds"
        },
        "msg": "操作成功"
    }
    ```
*   **失败响应 (500 Internal Server Error)**:
    ```json
    {
        "code": 50000,
        "data": null,
        "msg": "服务器内部异常，无法获取上传策略"
    }
    ```

### **1.2 [新] 观测点与图片上传流程**

为了解决同一次观测中，上传多张图片会创建重复地理位置信息的问题，现采用新的两步式上传流程。旧的 `POST /api/herb/herbs/images` 接口已废弃。

#### **第一步：创建观测点**

*   **Endpoint**: `POST /api/herb/locations`
*   **方法**: `POST`
*   **描述**: 提交地理位置等信息，创建一个新的观测点记录。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "herbId": 1,
      "longitude": 116.404,
      "latitude": 39.913,
      "province": "北京市",
      "city": "北京市",
      "address": "故宫博物院",
      "observationYear": 2024,
      "description": "第一次观测"
    }
    ```
*   **成功响应 (200 OK)**: 返回创建成功的观测点对象，**客户端必须记录返回的 `id`**，用于第二步。
    ```json
    {
        "code": 20000,
        "data": {
            "id": 15, // <--- 这个是关键的 locationId
            "herbId": 1,
            "longitude": 116.404,
            "latitude": 39.913,
            "province": "北京市",
            "city": "北京市",
            "address": "故宫博物院",
            "observationYear": 2024,
            "description": "第一次观测",
            "createdAt": "2025-06-30T10:00:00"
        },
        "msg": "操作成功"
    }
    ```

#### **第二步：为观测点上传图片**

*   **Endpoint**: `POST /api/herb/locations/{locationId}/images`
*   **方法**: `POST`
*   **描述**: 为一个已存在的观测点批量关联图片。
*   **路径参数**: `{locationId}` (第一步操作返回的观测点ID)。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "images": [
        {
          "url": "https://<bucket>.oss-cn-beijing.aliyuncs.com/path/to/image1.jpg",
          "isPrimary": true,
          "description": "植株正面"
        },
        {
          "url": "https://<bucket>.oss-cn-beijing.aliyuncs.com/path/to/image2.jpg",
          "isPrimary": false,
          "description": "叶片特写"
        }
      ]
    }
    ```
*   **成功响应 (200 OK)**: 返回被成功保存的图片对象列表。
    ```json
    {
        "code": 20000,
        "data": [
            { "id": 21, "herbId": 1, "locationId": 15, "url": "...", "isPrimary": true, ... },
            { "id": 22, "herbId": 1, "locationId": 15, "url": "...", "isPrimary": false, ... }
        ],
        "msg": "操作成功"
    }
    ```

---

## **二、 药材资源管理 (Herb CRUD)**

### **2.1 分页条件查询药材列表**

*   **Endpoint**: `GET /api/herb/herbs`
*   **方法**: `GET`
*   **描述**: 获取药材列表，支持分页、条件过滤和排序。
*   **查询参数 (Query Parameters)**:

| 参数名 | 类型 | 是否必需 | 默认值 | 描述 |
|---|---|---|---|---|
| `page` | Number | 否 | `1` | 当前页码 |
| `limit` | Number | 否 | `10` | 每页记录数 |
| `name` | String | 否 | | 按药材名称模糊查询 |
| `scientificName` | String | 否 | | 按学名模糊查询 |
| `familyName` | String | 否 | | 按科名精确查询 |
| `resourceType` | String | 否 | | 按资源类型精确查询 |
| `sortBy` | String | 否 | `name` | 排序字段 |
| `order` | String | 否 | `asc` | 排序顺序 (`asc`/`desc`) |

*   **成功响应 (200 OK)**: 返回MyBatis-Plus的`IPage`分页对象。
    ```json
    {
        "code": 20000,
        "data": {
            "records": [
                { "id": 1, "name": "人参", ... },
                { "id": 2, "name": "当归", ... }
            ],
            "total": 100,
            "size": 10,
            "current": 1,
            "pages": 10
        },
        "msg": "操作成功"
    }
    ```

### **2.2 获取单个药材详情**

*   **Endpoint**: `GET /api/herb/herbs/{id}`
*   **方法**: `GET`
*   **描述**: 根据ID获取单个药材的完整信息。
*   **路径参数 (Path Parameters)**: `{id}` (药材的ID)
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": {
            "id": 1,
            "name": "人参",
            "scientificName": "Panax ginseng",
            ...
        },
        "msg": "操作成功"
    }
    ```
*   **失败响应 (200 OK with Error Code)**:
    ```json
    {
        "code": 20040,
        "data": null,
        "msg": "未找到指定ID的药材"
    }
    ```

### **2.3 新建药材**

*   **Endpoint**: `POST /api/herb/herbs`
*   **方法**: `POST`
*   **描述**: 创建一个新的药材条目。
*   **请求体 (Request Body)**: `application/json` (结构基于`HerbDto`)
    ```json
    {
      "name": "灵芝",
      "scientificName": "Ganoderma lucidum",
      "resourceType": "栽培"
    }
    ```
*   **成功响应 (200 OK)**: 返回创建成功后的药材对象，包含数据库生成的ID。

### **2.4 更新药材**

*   **Endpoint**: `PUT /api/herb/herbs/{id}`
*   **方法**: `PUT`
*   **描述**: 更新指定ID的药材信息。
*   **路径参数**: `{id}` (药材的ID)
*   **请求体 (Request Body)**: `application/json` (结构基于`HerbDto`)
*   **成功响应 (200 OK)**: 返回更新后的药材完整对象。

### **2.5 删除药材**

*   **Endpoint**: `DELETE /api/herb/herbs/{id}`
*   **方法**: `DELETE`
*   **描述**: 删除指定ID的药材。
*   **路径参数**: `{id}` (药材的ID)
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": null,
        "msg": "操作成功"
    }
    ```

### **2.6 按名称智能查询药材**

*   **Endpoint**: `GET /api/herb/herbs/searchByName`
*   **方法**: `GET`
*   **描述**: 根据药材名称关键字进行模糊搜索，返回分页结果。这是一个简化的搜索接口。
*   **查询参数 (Query Parameters)**:

| 参数名 | 类型 | 是否必需 | 默认值 | 描述 |
|---|---|---|---|---|
| `name` | String | **是** | | 查询的药材名称关键字 |
| `page` | Number | 否 | `1` | 当前页码 |
| `limit` | Number | 否 | `10` | 每页记录数 |

*   **成功响应 (200 OK)**: 返回与分页条件查询药材列表（2.1）结构相同的`IPage`分页对象。

---

## **三、 其他辅助接口**

### **3.1 获取药材地理分布**

*   **Endpoint**: `GET /api/herb/map/herb-distribution`
*   **方法**: `GET`
*   **描述**: 获取药材的地理分布数据，用于地图可视化。

### **3.2 获取药材生长数据**

*   **Endpoint**: `GET /api/herb/{herbId}/growth-data`
*   **方法**: `GET`
*   **描述**: 获取指定药材在所有观测点的生长数据历史记录。

### **3.3 获取药材的图片列表**

*   **Endpoint**: `GET /api/herb/herbs/{herbId}/images`
*   **方法**: `GET`
*   **描述**: 获取指定药材所有已保存的图片URL列表。

### **3.4 更新药材生长数据**

*   **Endpoint**: `PUT /api/herb/growth-data/{id}`
*   **方法**: `PUT`
*   **描述**: 更新指定ID的药材生长数据，并将旧数据备份到历史表。
*   **认证**: 需要JWT（用于记录操作人）。
*   **路径参数**: `{id}` (生长数据记录 `herb_growth_data` 的ID)
*   **请求体 (Request Body)**: `application/json` (结构基于`HerbGrowthDataDto`)
    ```json
    {
      "metricName": "平均株高",
      "metricValue": "150.5",
      "metricUnit": "厘米"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    { "code": 20000, "data": null, "msg": "操作成功" }
    ```
*   **失败响应**:
    ```json
    { "code": 20030, "data": null, "msg": "更新失败，未找到对应数据或发生内部错误" }
    ```

---

## **四、 用户与认证模块 (User & Auth)**

**基础路径**: `/api/users` (请注意，此模块需要网关/代理配置 `/api` 前缀)

### **4.1 用户注册**

*   **Endpoint**: `POST /api/users/register`
*   **方法**: `POST`
*   **描述**: 创建一个新用户。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "username": "new_user",
      "passwordHash": "a_strong_password"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    { "code": 20000, "data": null, "msg": "注册成功" }
    ```
*   **失败响应 (用户名已存在)**:
    ```json
    { "code": 20050, "data": null, "msg": "用户名被占用" }
    ```

### **4.2 用户登录**

*   **Endpoint**: `POST /api/users/login`
*   **方法**: `POST`
*   **描述**: 使用用户名和密码进行登录，成功后返回JWT。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "username": "existing_user",
      "passwordHash": "the_correct_password"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": {
            "token": "a_very_long_jwt_token_string"
        },
        "msg": "登录成功"
    }
    ```
*   **失败响应 (用户名或密码错误)**:
    ```json
    { "code": 20051, "data": null, "msg": "用户名错误" } // 或 "密码错误"
    ```

### **4.3 获取当前用户信息**

*   **Endpoint**: `GET /api/users/userInfo`
*   **方法**: `GET`
*   **描述**: 获取当前已登录用户的个人资料。
*   **认证**: 需要在请求头中携带有效的JWT (`Authorization: Bearer <token>`)。
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": {
            "userId": 1,
            "fullName": "张三",
            "avatarUrl": "http://example.com/avatar.jpg",
            "bio": "个人简介",
            "gender": "男",
            "birthDate": "2000-01-01"
        },
        "msg": "获取成功"
    }
    ```

### **4.4 更新当前用户信息**

*   **Endpoint**: `PUT /api/users/update`
*   **方法**: `PUT`
*   **描述**: 更新当前已登录用户的个人资料。
*   **认证**: 需要JWT。
*   **请求体 (Request Body)**: `application/json` (发送需要修改的字段即可)
    ```json
    {
      "fullName": "李四",
      "bio": "新的个人简介"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20000,
        "data": { // 返回更新后的完整用户信息
            "userId": 1,
            "fullName": "李四",
            "avatarUrl": "http://example.com/avatar.jpg",
            "bio": "新的个人简介",
            "gender": "男",
            "birthDate": "2000-01-01"
        },
        "msg": "更新成功"
    }
    ```

### **4.5 更新用户头像**

*   **Endpoint**: `PATCH /api/users/updateAvatar`
*   **方法**: `PATCH`
*   **描述**: 单独更新当前用户的头像URL。
*   **认证**: 需要JWT。
*   **查询参数 (Query Parameters)**:
    *   `avatar`: (String, 必需) 新的头像URL。
*   **成功响应 (200 OK)**:
    ```json
    { "code": 20000, "data": null, "msg": "更新头像成功" }
    ```
### **4.6 修改密码**

*   **Endpoint**: `PATCH /api/users/updatePwd`
*   **方法**: `PATCH`
*   **描述**: 修改当前用户的登录密码。
*   **认证**: 需要JWT。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "old_pwd": "original_password",
      "new_pwd": "new_strong_password",
      "re_pwd": "new_strong_password"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    { "code": 20000, "data": null, "msg": "密码已成功设置" }
    ```
*   **失败响应**:
    *   `{ "code": 20050, "msg": "两次输入的新密码不一致" }`
    *   `{ "code": 20050, "msg": "原密码填写错误" }`
    *   `{ "code": 500, "msg": "操作失败：您的账户尚未设置密码，请使用"设置密码"功能。" }`

### **4.7 (OAUTH) 设置初始密码**

*   **Endpoint**: `POST /api/users/set-password`
*   **方法**: `POST`
*   **描述**: 专为通过第三方登录（如OAuth2）且尚未设置密码的用户，提供设置初始密码的功能。
*   **认证**: 需要JWT。
*   **请求体 (Request Body)**: `application/json`
    ```json
    {
      "new_pwd": "new_strong_password",
      "re_pwd": "new_strong_password"
    }
    ```
*   **成功响应 (200 OK)**:
    ```json
    { "code": 0, "msg": "登录密码设置成功！" } // 这里code和msg可能与其他接口不同
    ```
*   **失败响应**:
    *   `{ "code": 1, "msg": "两次输入的新密码不一致" }`
    *   `{ "code": 1, "msg": "操作失败：您的账户已设置密码，请使用"修改密码"功能。" }`

---

## X、 智能服务

### **10.1 百度AI植物识别**

此接口接收一张图片，调用百度智能云的API进行植物识别，并返回识别结果。

*   **Endpoint**: `POST /api/plant/recognize`
*   **方法**: `POST`
*   **描述**: 上传一张植物图片进行识别。
*   **请求类型**: `multipart/form-data`
*   **请求参数**:

| 参数名 | 类型 | 是否必需 | 描述 |
|---|---|---|---|
| `image` | File | 是 | 需要识别的植物图片文件。 |

*   **成功响应 (200 OK)**:
    ```json
    {
        "code": 20041,
        "data": {
            "log_id": 1832328232969917849,
            "result": [
                {
                    "score": 0.853235,
                    "name": "紫荆",
                    "baike_info": {
                        "baike_url": "https://baike.baidu.com/item/%E7%B4%AB%E8%8D%86/6988",
                        "image_url": "https://cdn.example.com/image.jpg",
                        "description": "紫荆（学名：Cercis chinensis Bunge）：豆科紫荆属灌木或小乔木..."
                    }
                },
                {
                    "score": 0.05187,
                    "name": "羊蹄甲"
                }
            ]
        },
        "msg": "识别成功"
    }
    ```
    *注意：`data` 字段中的具体结构由百度AI接口返回，这里仅为示例。*

*   **失败响应 (图片为空)**:
    ```json
    {
        "code": 20010,
        "data": null,
        "msg": "图片不能为空"
    }
    ```

*   **失败响应 (识别服务出错)**:
    ```json
    {
        "code": 50000,
        "data": null,
        "msg": "具体的错误信息，例如：IAM Appkey is not valid"
    }
    ```


`
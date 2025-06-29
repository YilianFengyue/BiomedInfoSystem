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

### **1.2 保存图片及地点信息**

在前端成功将文件上传到OSS后，调用此接口，将文件的URL和相关的地点信息一并保存到后端数据库。这是一个事务性操作。

*   **Endpoint**: `POST /api/herb/herbs/images`
*   **方法**: `POST`
*   **描述**: 保存一张新的药草图片URL及其关联的观测点信息。
*   **请求体 (Request Body)**: `application/json`

    ```json
    {
      "herbId": 1,
      "url": "https://your-bucket.oss-cn-beijing.aliyuncs.com/user-uploads/image.jpg",
      "longitude": 116.404269,
      "latitude": 39.913169,
      "province": "北京市",
      "observationYear": 2024,
      "isPrimary": false,
      "city": "北京市",
      "address": "详细地址",
      "description": "图片描述"
    }
    ```

*   **请求体字段说明**:

| 字段名 | 类型 | 是否必需 | 描述 |
|---|---|---|---|
| `herbId` | Number | **是** | 关联的药草ID |
| `url` | String | **是** | 图片的OSS访问URL |
| `longitude` | Number | **是** | 经度 |
| `latitude` | Number | **是** | 纬度 |
| `province` | String | **是** | 省份 |
| `observationYear` | Number | **是** | 观测年份 |
| `isPrimary` | Boolean | 否 | 是否为主图，默认为false |
| `city` | String | 否 | 城市 |
| `address` | String | 否 | 详细地址 |
| `description` | String | 否 | 图片描述 |

*   **成功响应 (200 OK)**: 返回被成功保存的图片对象，包含了数据库生成的ID。
    ```json
    {
        "code": 20000,
        "data": {
            "id": 5,
            "herbId": 1,
            "locationId": 12,
            "url": "https://your-bucket.oss-cn-beijing.aliyuncs.com/user-uploads/image.jpg",
            "isPrimary": false,
            "description": "图片描述",
            "uploadedAt": "2025-06-29T12:00:00"
        },
        "msg": "图片及地点信息保存成功"
    }
    ```
*   **校验失败响应 (400 Bad Request)**:
    ```json
    {
        "code": 20060,
        "data": null,
        "msg": "药草ID不能为空; 观测年份不能为空"
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
    { "code": 20000, "data": null, "msg": "密码修改成功，请重新登录" }
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

# 生物医药数字信息系统 API文档 (模块一 & 模块二)


## 模块一: 数据中心与可视化平台

本模块API主要用于数据展示和分析。

### 1.1 地图可视化接口

#### `GET /map/herb-distribution`

**功能**: 获取所有药材的地理分布数据点，用于在地图上进行渲染。
- **对应功能点**: 1.1 中药材分布网络地图
- **查询参数**:
    - `herb_id` (integer, optional): 按指定药材ID筛选。
    - `province` (string, optional): 按省份筛选。
- **成功响应 (200 OK)**:
  ```json
  {
    "data": [
      {
        "location_id": 1,
        "herb_id": 1,
        "herb_name": "人参",
        "location_name": "吉林长白山人参种植基地",
        "longitude": 127.5534000,
        "latitude": 42.0233000,
        "city": "白山市"
      },
      {
        "location_id": 2,
        "herb_id": 2,
        "herb_name": "枸杞",
        "location_name": "宁夏中宁枸杞核心产区",
        "longitude": 105.6885000,
        "latitude": 37.4861000,
        "city": "中卫市"
      }
    ]
  }
  ```

### 1.2 统计分析接口

#### `GET /statistics/summary`

**功能**: 获取关键数据的总体概览统计，用于数据看板。
- **对应功能点**: 1.2 数据对比分析
- **成功响应 (200 OK)**:
  ```json
  {
    "data": {
      "total_herbs": 58,
      "total_locations": 150,
      "total_edu_resources": 25,
      "total_users": 120
    }
  }
  ```

#### `GET /statistics/herbs-by-province`

**功能**: 按省份统计药材分布点的数量。
- **对应功能点**: 1.2 数据对比分析
- **成功响应 (200 OK)**: 返回一个适用于渲染柱状图或饼图的数据结构。
  ```json
  {
    "data": [
      { "province": "吉林省", "count": 25 },
      { "province": "甘肃省", "count": 18 },
      { "province": "宁夏回族自治区", "count": 15 }
    ]
  }
  ```
  
### 1.3 数据溯源接口

#### `GET /locations/{locationId}/growth-data/history`

**功能**: 查询指定观测点某项生长数据的历史变更记录。
- **对应功能点**: 1.4 数据溯源管理
- **成功响应 (200 OK)**:
  ```json
  {
      "data": [
          {
              "id": 1,
              "metric_name": "预估产量",
              "old_value": "800",
              "new_value": "850",
              "action": "UPDATE",
              "changed_by": "admin",
              "changed_at": "2025-06-27T13:42:19Z",
              "remark": "根据最新航拍数据修正"
          }
      ]
  }
  ```

### 1.4 基础数据查询接口

这些是支撑UI展示所需的基础CRUD接口。

- `GET /herbs`: 获取药材列表。
- `GET /herbs/{id}`: 获取单个药材详情。
- `GET /locations`: 获取观测点列表。
- `GET /locations/{id}`: 获取单个观测点详情。
- `GET /herbs/{herbId}/images`: 获取药材的图片列表 (用于图谱比对UI)。

---

## 模块二: 多端数据采集与共享系统

本模块API主要用于支持手机APP和电脑终端的数据录入和文件传输。

### 2.1 数据采集接口 (增删改)

#### `POST /herbs`
**功能**: 创建一个新的药材条目。
- **对应功能点**: 2.1 手机APP/电脑终端数据采集

#### `PUT /herbs/{id}`
**功能**: 更新一个已有的药材条目。

#### `POST /locations`
**功能**: 为某个药材创建一个新的观测点记录。
- **请求体**:
  ```json
  {
    "herb_id": 3,
    "name": "甘肃岷县当归种植基地",
    "province": "甘肃省",
    "city": "定西市",
    "address": "岷县XXXX号",
    "longitude": 104.05,
    "latitude": 34.45,
    "altitude": 2300,
    "soil_type": "黄绵土"
  }
  ```

#### `PUT /locations/{id}`
**功能**: 更新一个已有的观测点记录。

#### `POST /herbs/{herbId}/images`
**功能**: 在图片上传到OSS后，将图片的元数据（URL、描述等）保存到数据库。
- **对应功能点**: 2.3 数据上传
- **请求体**:
  ```json
  {
    "url": "https://your-oss-bucket.oss-cn-hangzhou.aliyuncs.com/images/2025/06/some-uuid.jpg",
    "description": "现场拍摄的当归叶片特征",
    "is_primary": false,
    "location_id": 123 
  }
  ```

*所有创建和更新操作都需要用户已登录认证 (Bearer Token)。*

### 2.2 文件上传凭证接口

#### `GET /oss/upload-credentials`

**功能**: 从后端获取用于直传文件到阿里云OSS的临时凭证。
- **对应功能点**: 2.3 数据上传/下载
- **查询参数**:
  - `filename` (string, required): 要上传的原始文件名，用于后端生成存储路径。
  - `content_type` (string, required): 文件的MIME类型, e.g., `image/jpeg`。
- **成功响应 (200 OK)**:
  ```json
  {
    "data": {
      "accessKeyId": "STS.L3Tg...",
      "accessKeySecret": "88a4I...",
      "securityToken": "CAIS...=",
      "region": "oss-cn-hangzhou",
      "bucket": "your-oss-bucket-name",
      "key": "images/2025/06/some-uuid-based-on-filename.jpg",
      "upload_url": "https://your-oss-bucket-name.oss-cn-hangzhou.aliyuncs.com"
    }
  }
  ```

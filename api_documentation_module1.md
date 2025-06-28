# 生物医药信息系统 - 模块一 API接口文档

## 1. 介绍

本文档定义了生物医药信息系统 **模块一：药材信息管理** 的RESTful API

**Base URL**: `http://api.biomed.example.com/`

## 2. 认证

所有API请求都需要进行身份验证。请求应在HTTP头中包含一个有效的Bearer Token。

`Authorization: Bearer <Your_JWT_Token>`

未授权的请求将返回 `401 Unauthorized` 状态码。

---

## 3. 资源：药材 (Herbs)

药材是系统的核心资源。

### 3.1. `GET /herbs`

**功能**: 获取药材列表。支持分页、筛选和排序。

**查询参数**:

-   `page` (integer, optional, default: 1): 页码。
-   `limit` (integer, optional, default: 10): 每页数量。
-   `name` (string, optional): 按药材名称模糊查询。
-   `scientific_name` (string, optional): 按学名模糊查询。
-   `family_name` (string, optional): 按科名查询。
-   `resource_type` (enum, optional): 按资源类型筛选 ('野生', '栽培')。
-   `sort_by` (string, optional, default: 'name'): 排序字段 (e.g., 'name', 'created_at')。
-   `order` (enum, optional, default: 'asc'): 排序顺序 ('asc', 'desc')。

**成功响应 (200 OK)**:

```json
{
  "data": [
    {
      "id": 1,
      "name": "人参",
      "scientific_name": "Panax ginseng",
      "family_name": "五加科",
      "resource_type": "栽培",
      "life_form": "多年生草本",
      "description": "补气固脱，健脾益肺，宁心益智，养血生津。",
      "created_at": "2025-06-27T13:42:19Z",
      "updated_at": "2025-06-28T10:16:32Z"
    }
  ],
  "pagination": {
    "total": 58,
    "page": 1,
    "limit": 10,
    "total_pages": 6
  }
}
```

### 3.2. `POST /herbs`

**功能**: 创建一个新的药材条目。

**请求体 (application/json)**:

```json
{
  "name": "黄芪",
  "scientific_name": "Astragalus membranaceus",
  "family_name": "豆科",
  "resource_type": "栽培",
  "life_form": "多年生草本",
  "description": "补气升阳，固表止汗，利水消肿，生津养血，行滞通痹，托毒排脓，敛疮生肌。"
}
```

**成功响应 (201 Created)**:
返回新创建的药材对象。

```json
{
  "data": {
    "id": 59,
    "name": "黄芪",
    "scientific_name": "Astragalus membranaceus",
    "family_name": "豆科",
    "resource_type": "栽培",
    "life_form": "多年生草本",
    "description": "补气升阳，固表止汗，利水消肿，生津养血，行滞通痹，托毒排脓，敛疮生肌。",
    "created_at": "2025-06-29T10:00:00Z",
    "updated_at": "2025-06-29T10:00:00Z"
  }
}
```

**错误响应 (400 Bad Request)**:
如果请求体无效或 `name` 已存在。

### 3.3. `GET /herbs/{id}`

**功能**: 获取指定ID的药材详细信息。

**成功响应 (200 OK)**:

```json
{
  "data": {
    "id": 1,
    "name": "人参",
    // ... 其他字段 ...
    "images": [
        { "id": 1, "url": "...", "is_primary": true },
        { "id": 2, "url": "...", "is_primary": false }
    ],
    "locations": [
        { "id": 1, "name": "吉林长白山基地", "longitude": 128.0, "latitude": 42.0 }
    ]
  }
}
```

### 3.4. `PUT /herbs/{id}`

**功能**: 更新指定ID的药材信息。

**请求体 (application/json)**:
包含需要更新的字段。

```json
{
  "description": "更新后的药用价值描述。"
}
```

**成功响应 (200 OK)**:
返回更新后的完整药材对象。

### 3.5. `DELETE /herbs/{id}`

**功能**: 删除指定ID的药材。

**成功响应 (204 No Content)**.

---

## 4. 资源：药材图片 (Herb Images)

作为药材的子资源。

### 4.1. `GET /herbs/{herbId}/images`

**功能**: 获取指定药材的所有图片列表。

**成功响应 (200 OK)**:

```json
{
  "data": [
    {
      "id": 1,
      "url": "https://oss.example.com/images/herb1_1.jpg",
      "is_primary": true,
      "description": "人参全株图",
      "uploaded_at": "2025-06-28T11:00:00Z"
    }
  ]
}
```

### 4.2. `POST /herbs/{herbId}/images`

**功能**: 为指定药材上传一张新图片。

**请求体 (multipart/form-data)**:

-   `image`: 图片文件。
-   `description` (string, optional): 图片描述。
-   `is_primary` (boolean, optional, default: false): 是否设为主要图片。

**成功响应 (201 Created)**:
返回新创建的图片对象。

### 4.3. `POST /herbs/{herbId}/images/{imageId}/set-primary`

**功能**: 将指定图片设置为药材的主图。

**成功响应 (200 OK)**:
返回更新后的图片对象。

### 4.4. `DELETE /herbs/{herbId}/images/{imageId}`

**功能**: 删除指定ID的图片。

**成功响应 (204 No Content)**.

---

## 5. 资源：观测点 (Locations)

### 5.1. `GET /locations`

**功能**: 获取所有观测点列表，支持分页和地理位置查询。

**查询参数**:

-   `page`, `limit`: 分页参数。
-   `name` (string, optional): 按名称搜索。
-   `province`, `city`: 按省市筛选。
-   `near` (string, optional): 经纬度 'longitude,latitude'，查询附近的点。
-   `radius` (number, optional): 配合 `near` 使用，查询半径 (米)。

**成功响应 (200 OK)**.

### 5.2. `POST /locations`

**功能**: 创建一个新的观测点。

**请求体 (application/json)**:

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

**成功响应 (201 Created)**:
返回新创建的观测点对象。

### 5.3. `GET /locations/{id}`

**功能**: 获取指定ID的观测点详情。

**成功响应 (200 OK)**.

### 5.4. `PUT /locations/{id}`

**功能**: 更新指定ID的观测点信息。

**成功响应 (200 OK)**.

### 5.5. `DELETE /locations/{id}`

**功能**: 删除指定ID的观测点。

**成功响应 (204 No Content)**.

---

## 6. 资源：生长数据 (Growth Data)

作为观测点的子资源。

### 6.1. `GET /locations/{locationId}/growth-data`

**功能**: 获取指定观测点的所有生长/统计数据。

**成功响应 (200 OK)**:

```json
{
    "data": [
        {
            "id": 1,
            "metric_name": "预估产量",
            "metric_value": "500",
            "metric_unit": "公斤",
            "recorded_at": "2025-06-27T13:42:19Z"
        },
        {
            "id": 2,
            "metric_name": "土壤PH值",
            "metric_value": "6.5",
            "metric_unit": null,
            "recorded_at": "2025-06-27T13:42:19Z"
        }
    ]
}
```

### 6.2. `POST /locations/{locationId}/growth-data`

**功能**: 为指定观测点添加新的生长数据。

**请求体 (application/json)**:

```json
{
  "metric_name": "平均株高",
  "metric_value": "35.5",
  "metric_unit": "厘米"
}
```

**成功响应 (201 Created)**:
返回新创建的数据项。

### 6.3. `GET /locations/{locationId}/growth-data/history`

**功能**: 获取指定观测点生长数据的变更历史。

**查询参数**:

- `metric_name` (string, optional): 按指标名称筛选历史记录。

**成功响应 (200 OK)**:

```json
{
    "data": [
        {
            "id": 1,
            "origin_id": 3,
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
# 在线教育平台 API 文档

本文档提供了在线教育平台后端服务的详细API说明。

## 1. 统一响应格式

所有API的响应都遵循统一的结构：

```json
{
  "code": "Integer",
  "msg": "String",
  "data": "Object | Array | null"
}
```

- `code`: 状态码。通常 `200` 或 `0` 表示成功，其他值表示不同类型的错误。
- `msg`: 对本次请求结果的简要描述，如 "操作成功" 或具体的错误信息。
- `data`: 实际返回的数据。如果请求失败或没有数据返回，此字段可能为 `null`。

---

## 2. 课程管理 (`/courses`)

此模块负责课程的创建、查询和删除。

### 2.1 获取课程详情

- **Endpoint:** `GET /courses/{id}`
- **描述:** 根据课程ID获取单个课程的详细信息，包括其下的所有章节和课时。
- **路径参数:**
    - `id` (Long): 必需，课程的唯一标识符。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `CourseDetailDto`
    ```json
    {
      "id": 1,
      "title": "深入浅出Java编程",
      "teacherName": "张三",
      "coverImage": "https://example.com/cover.jpg",
      "chapters": [
        {
          "id": 101,
          "title": "第一章：Java入门",
          "lessons": [
            {
              "id": 1001,
              "title": "1.1 环境搭建",
              "contentType": "video",
              "resourceUrl": "https://livekit.io/video/1",
              "duration": 900
            },
            {
              "id": 1002,
              "title": "1.2 HelloWorld",
              "contentType": "video",
              "resourceUrl": "https://livekit.io/video/2",
              "duration": 600
            }
          ]
        },
        {
          "id": 102,
          "title": "第二章：面向对象",
          "lessons": []
        }
      ]
    }
    ```
- **失败响应 (`code: 4xx/5xx`):**
    - 当课程不存在时:
    ```json
    {
      "code": 1004,
      "msg": "未找到该课程",
      "data": null
    }
    ```

### 2.2 获取所有课程列表

- **Endpoint:** `GET /courses`
- **描述:** 获取平台上所有课程的摘要信息列表，用于课程中心或首页展示。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `List<CourseListDto>`
    ```json
    [
      {
        "id": 1,
        "title": "深入浅出Java编程",
        "teacherName": "张三",
        "coverImage": "https://example.com/cover.jpg",
        "studentCount": 1200,
        "rating": 4.8
      },
      {
        "id": 2,
        "title": "Python数据分析实战",
        "teacherName": "李四",
        "coverImage": "https://example.com/cover2.jpg",
        "studentCount": 2500,
        "rating": 4.9
      }
    ]
    ```

### 2.3 创建新课程

- **Endpoint:** `POST /courses`
- **描述:** 创建一个新课程，可以同时包含其章节信息。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `CourseCreateDto`
    ```json
    {
      "title": "Vue.js从入门到精通",
      "categoryId": 3,
      "teacherId": 5,
      "coverImage": "https://example.com/vue_cover.jpg",
      "introduction": "本课程将带你系统学习Vue.js...",
      "chapters": [
        {
          "title": "第一章：基础概念",
          "description": "介绍Vue的核心思想",
          "sortOrder": 1
        },
        {
          "title": "第二章：组件化开发",
          "description": "深入理解Vue组件",
          "sortOrder": 2
        }
      ]
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `CourseDetailDto` (返回创建好的完整课程信息)
    - 响应体结构同 **2.1 获取课程详情**。
- **失败响应 (`code: 4xx/5xx`):**
    - 当请求体验证失败时:
    ```json
    {
      "code": 1001,
      "msg": "课程标题不能为空",
      "data": null
    }
    ```

### 2.4 删除课程

- **Endpoint:** `DELETE /courses/{id}`
- **描述:** 根据ID删除一个课程及其所有相关内容（如章节、课时、选课记录等）。
- **路径参数:**
    - `id` (Long): 必需，要删除的课程的唯一标识符。
- **成功响应 (`code: 200`):**
    ```json
    {
      "code": 200,
      "msg": "课程删除成功",
      "data": null
    }
    ```

---

## 3. 课程章节管理 (`/chapters`)

此模块负责对课程中的独立章节进行管理。

### 3.1 删除章节

- **Endpoint:** `DELETE /chapters/{id}`
- **描述:** 根据ID删除一个章节及其包含的所有课时。
- **路径参数:**
    - `id` (Long): 必需，要删除的章节的唯一标识符。
- **成功响应 (`code: 200`):**
    ```json
    {
      "code": 200,
      "msg": "章节删除成功",
      "data": null
    }
    ```

---

## 4. 课程课时管理 (`/lessons`)

此模块负责对课程章节下的具体课时进行管理。

### 4.1 从资源创建新课时

- **Endpoint:** `POST /lessons`
- **描述:** 将一个平台内已存在的资源（如图文、视频）添加为指定章节下的一个新课时。
- **查询参数:**
    - `chapterId` (Long): 必需，新课时所属的章节ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `CreateLessonFromResourceDto`
    ```json
    {
      "title": "1.3 第一个Java程序",
      "resourceId": 55,
      "contentType": "video"
    }
    ```
    - `contentType` 的可选值为 `"document"` 或 `"video"`。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `LessonDto`
    ```json
    {
      "id": 1003,
      "title": "1.3 第一个Java程序",
      "contentType": "video",
      "resourceUrl": "https://livekit.io/video/3",
      "duration": 750
    }
    ```
- **失败响应 (`code: 4xx/5xx`):**
    - 当请求体验证失败时:
    ```json
    {
      "code": 1001,
      "msg": "必须指定资源ID",
      "data": null
    }
    ```

### 4.2 删除课时

- **Endpoint:** `DELETE /lessons/{id}`
- **描述:** 根据ID删除一个课时。
- **路径参数:**
    - `id` (Long): 必需，要删除的课时的唯一标识符。
- **成功响应 (`code: 200`):**
    ```json
    {
      "code": 200,
      "msg": "课时删除成功",
      "data": null
    }
    ```
---

## 5. 教学资源分类管理 (`/categories`)

此模块负责对教学资源的分类进行增删改查。

### 5.1 获取所有分类列表

- **Endpoint:** `GET /categories`
- **描述:** 获取所有教学资源的分类列表。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `List<CategoryDto>`
    ```json
    [
      {
        "id": 1,
        "name": "试验课程",
        "slug": "experimental-courses",
        "description": "包含各类试验操作和理论的课程"
      },
      {
        "id": 2,
        "name": "课题研究",
        "slug": "research-projects",
        "description": "学生和教师参与的科研项目"
      }
    ]
    ```

### 5.2 创建新分类

- **Endpoint:** `POST /categories`
- **描述:** 创建一个新的教学资源分类。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `CategoryDto` (id由后端生成)
    ```json
    {
      "name": "名医讲堂",
      "slug": "expert-lectures",
      "description": "知名专家的系列讲座"
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `CategoryDto` (包含后端生成的id)
    ```json
    {
      "id": 3,
      "name": "名医讲堂",
      "slug": "expert-lectures",
      "description": "知名专家的系列讲座"
    }
    ```

### 5.3 更新分类

- **Endpoint:** `PUT /categories/{id}`
- **描述:** 根据ID更新一个已有的分类。
- **路径参数:**
    - `id` (Integer): 必需，要更新的分类ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `CategoryDto`
    ```json
    {
      "name": "名医讲堂-精品课",
      "slug": "expert-lectures-premium",
      "description": "知名专家的系列精品讲座"
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `CategoryDto` (返回更新后的分类信息)
    ```json
    {
      "id": 3,
      "name": "名医讲堂-精品课",
      "slug": "expert-lectures-premium",
      "description": "知名专家的系列精品讲座"
    }
    ```

### 5.4 删除分类

- **Endpoint:** `DELETE /categories/{id}`
- **描述:** 根据ID删除一个分类。
- **路径参数:**
    - `id` (Integer): 必需，要删除的分类ID。
- **成功响应 (`code: 200`):**
    ```json
    {
      "code": 200,
      "msg": "操作成功",
      "data": null
    }
    ```
---

## 6. 教学资源管理 (`/resources`)

核心模块，管理试验课程、课题研究等图文/视频集合类资源。

### 6.1 分页查询教学资源列表

- **Endpoint:** `GET /resources`
- **描述:** 分页、排序、筛选查询教学资源列表。
- **查询参数:**
    - `page` (Integer, optional, default: 0): 页码。
    - `size` (Integer, optional, default: 20): 每页数量。
    - `sort` (String, optional, default: `createdAt,DESC`): 排序字段和方向，如 `sort=title,ASC`。
    - `categoryId` (Integer, optional): 按分类ID筛选。
    - `title` (String, optional): 按标题关键字模糊查询。
    - `status` (String, optional): 按资源状态筛选 (e.g., `published`, `draft`)。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `Page<ResourceListDto>` (Spring Data Page对象)
    ```json
    {
      "content": [
        {
          "id": 1,
          "title": "中药药理学研究",
          "categoryId": 2,
          "categoryName": "课题研究",
          "authorName": "王教授",
          "coverImageUrl": "https://example.com/cover.jpg",
          "status": "published",
          "createdAt": "2023-10-27T10:00:00"
        }
      ],
      "pageable": {
        "sort": { "sorted": true, ... },
        "offset": 0,
        "pageNumber": 0,
        "pageSize": 20,
        "paged": true,
        "unpaged": false
      },
      "last": true,
      "totalPages": 1,
      "totalElements": 1,
      "size": 20,
      "number": 0,
      "sort": { "sorted": true, ... },
      "first": true,
      "numberOfElements": 1,
      "empty": false
    }
    ```

### 6.2 获取单个资源详情

- **Endpoint:** `GET /resources/{id}`
- **描述:** 获取单个教学资源的详细信息，包括关联的视频列表。
- **路径参数:**
    - `id` (Long): 必需，资源的唯一标识符。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `ResourceDetailDto`
    ```json
    {
      "id": 1,
      "title": "中药药理学研究",
      "categoryId": 2,
      "categoryName": "课题研究",
      "authorId": 10,
      "authorName": "王教授",
      "coverImageUrl": "https://example.com/cover.jpg",
      "content": "<p>这是详细的富文本内容...</p>",
      "status": "published",
      "createdAt": "2023-10-27T10:00:00",
      "updatedAt": "2023-10-28T11:00:00",
      "publishedAt": "2023-10-27T12:00:00",
      "videos": [
        {
          "videoId": 201,
          "title": "第一讲：研究方法",
          "duration": 1200,
          "displayOrder": 1
        },
        {
          "videoId": 202,
          "title": "第二讲：数据分析",
          "duration": 1500,
          "displayOrder": 2
        }
      ]
    }
    ```

### 6.3 创建新资源 (已注释，仅供参考)

- **Endpoint:** `POST /resources`
- **描述:** 创建一篇新的教学资源。作者ID将从当前登录用户中获取。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `ResourceCreateDto`
    ```json
    {
      "title": "针灸学入门",
      "categoryId": 1,
      "coverImageUrl": "https://example.com/acupuncture.jpg",
      "content": "<p>从零开始学习针灸...</p>",
      "status": "draft"
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `ResourceDetailDto` (结构同6.2)

### 6.4 更新资源

- **Endpoint:** `PUT /resources/{id}`
- **描述:** 更新一篇教学资源的完整信息。
- **路径参数:**
    - `id` (Long): 必需，要更新的资源ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `ResourceUpdateDto`
    ```json
    {
      "title": "针灸学入门（修订版）",
      "categoryId": 1,
      "coverImageUrl": "https://example.com/acupuncture_v2.jpg",
      "content": "<p>更新后的内容...</p>",
      "status": "published"
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `ResourceDetailDto` (返回更新后的完整信息，结构同6.2)

### 6.5 删除资源

- **Endpoint:** `DELETE /resources/{id}`
- **描述:** 根据ID删除一篇教学资源及其与视频的关联关系。
- **路径参数:**
    - `id` (Long): 必需，要删除的资源ID。
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 6.6 更新资源状态

- **Endpoint:** `PATCH /resources/{id}/status`
- **描述:** 单独更新一篇教学资源的状态。
- **路径参数:**
    - `id` (Long): 必需，要更新的资源ID。
- **请求体 (`Content-Type: application/json`):**
    ```json
    {
      "status": "archived"
    }
    ```
    - `status` 可选值为 `"draft"`, `"published"`, `"archived"`。
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 6.7 为资源关联视频

- **Endpoint:** `POST /resources/{resourceId}/videos`
- **描述:** 将一个已存在的视频关联到指定资源下。
- **路径参数:**
    - `resourceId` (Long): 必需，目标资源ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `LinkVideoDto`
    ```json
    {
      "videoId": 305,
      "displayOrder": 3
    }
    ```
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 6.8 为资源解除视频关联

- **Endpoint:** `DELETE /resources/{resourceId}/videos/{videoId}`
- **描述:** 将一个视频从指定资源中移除。
- **路径参数:**
    - `resourceId` (Long): 必需，目标资源ID。
    - `videoId` (Long): 必需，要移除的视频ID。
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 6.9 获取资源下的视频列表

- **Endpoint:** `GET /resources/{resourceId}/videos`
- **描述:** 获取指定资源下所有已关联视频的列表。
- **路径参数:**
    - `resourceId` (Long): 必需，目标资源ID。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `List<VideoDto>`
    ```json
    [
      {
        "id": 201,
        "title": "第一讲：研究方法",
        "description": "...",
        "videoUrl": "https://oss.com/video1.mp4",
        "coverUrl": "https://oss.com/cover1.jpg",
        "duration": 1200,
        "uploaderId": 10,
        "uploaderName": "王教授",
        "status": "published",
        "createdAt": "2023-10-26T14:00:00"
      }
    ]
    ```

### 6.10 更新资源下视频的排序

- **Endpoint:** `PUT /resources/{resourceId}/videos/order`
- **描述:** 批量更新一个资源下所有视频的显示顺序。
- **路径参数:**
    - `resourceId` (Long): 必需，目标资源ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `List<Long>` (按顺序排列的视频ID列表)
    ```json
    [202, 201]
    ```
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

---

## 7. 统一资源上传 (`/edu`)

此模块提供一个统一的入口，用于上传图文或视频类型的教学资源。

### 7.1 统一上传接口

- **Endpoint:** `POST /edu/upload`
- **描述:** 根据`resourceType`字段自动区分并创建图文或视频资源。新创建的资源状态默认为`draft` (草稿)。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `ResourceUploadDto`
    ```json
    {
      "title": "我的第一个教学资源",
      "coverImageUrl": "https://example.com/cover.jpg",
      "authorId": 15,
      "categoryId": 1,
      "resourceType": "text", // or "video"
      "content": "<p>这是图文资源的内容...</p>",
      "description": "这是视频资源的简介...",
      "videoUrl": "https://oss.com/new_video.mp4",
      "duration": 360
    }
    ```
    - **注意:** 当`resourceType`为`text`时, `content`和`categoryId`为主要字段。当`resourceType`为`video`时, `description`, `videoUrl`, `duration`为主要字段。

- **成功响应 (`code: 200`):**
    - **当`resourceType: "text"`时, `data` 结构为 `EduResources` 实体:**
    ```json
    {
      "id": 102,
      "title": "我的第一个教学资源",
      "categoryId": 1,
      "authorId": 15,
      "coverImageUrl": "https://example.com/cover.jpg",
      "content": "<p>这是图文资源的内容...</p>",
      "status": "draft",
      "createdAt": "2023-10-29T10:00:00",
      "updatedAt": null,
      "publishedAt": null
    }
    ```
    - **当`resourceType: "video"`时, `data` 结构为 `EduVideos` 实体:**
    ```json
    {
        "id": 306,
        "title": "我的第一个教学资源",
        "description": "这是视频资源的简介...",
        "videoUrl": "https://oss.com/new_video.mp4",
        "coverUrl": "https://example.com/cover.jpg",
        "duration": 360,
        "uploaderId": 15,
        "status": "draft",
        "createdAt": "2023-10-29T10:00:00"
    }
    ```
- **失败响应 (`code: 4xx`):**
    ```json
    {
      "code": 1001,
      "msg": "无效的资源类型",
      "data": null
    }
    ```

---

## 8. 教学视频库管理与交互 (`/videos`)

此模块不仅管理视频库中的元数据，还处理视频的点赞、评论等交互功能。

### 8.1 分页查询视频库

- **Endpoint:** `GET /videos/page`
- **描述:** 分页查询视频库中的视频列表。
- **查询参数:**
    - `pageNum` (Integer, optional, default: 1): 页码。
    - `pageSize` (Integer, optional, default: 10): 每页数量。
    - `status` (String, optional): 按视频状态筛选 (e.g., `published`, `draft`)。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `PageDto<VideoDto>`
    ```json
    {
      "content": [
        {
            "id": 201,
            "title": "第一讲：研究方法",
            "description": "...",
            "videoUrl": "https://oss.com/video1.mp4",
            "coverUrl": "https://oss.com/cover1.jpg",
            "duration": 1200,
            "uploaderId": 10,
            "uploaderName": "王教授",
            "status": "published",
            "createdAt": "2023-10-26T14:00:00"
        }
      ],
      "pageNumber": 0,
      "pageSize": 10,
      "totalElements": 1,
      "totalPages": 1,
      "last": true,
      "first": true
    }
    ```

### 8.2 获取单个视频详情

- **Endpoint:** `GET /videos/{id}`
- **描述:** 获取单个视频的元数据信息。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `VideoDto` (结构同8.1中content数组的元素)

### 8.3 更新视频信息

- **Endpoint:** `PUT /videos/{id}`
- **描述:** 更新视频的元数据信息。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `VideoDto`
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `VideoDto` (返回更新后的视频信息)

### 8.4 删除视频

- **Endpoint:** `DELETE /videos/{id}`
- **描述:** 从视频库删除视频记录（不会删除OSS上的物理文件）。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 8.5 更新视频状态

- **Endpoint:** `PATCH /videos/{id}/status`
- **描述:** 单独更新一个视频的状态。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **请求体 (`Content-Type: application/json`):**
    ```json
    {
      "status": "published"
    }
    ```
    - `status` 可选值为 `"draft"`, `"published"`, `"archived"`。
- **成功响应 (`code: 200`):** `{"code": 200, "msg": "操作成功", "data": null}`

### 8.6 获取视频点赞信息

- **Endpoint:** `GET /videos/{id}/likes`
- **描述:** 获取指定视频的总点赞数和特定用户的点赞状态。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **查询参数:**
    - `userId` (Long): 必需，当前用户的ID。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `LikeDto`
    ```json
    {
      "count": 128,
      "isLiked": true
    }
    ```

### 8.7 点赞/取消点赞视频

- **Endpoint:** `POST /videos/{id}/like`
- **描述:** 为指定视频点赞或取消点赞。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **请求体 (`Content-Type: application/json`):**
    ```json
    {
      "userId": 25
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `LikeDto` (返回操作后最新的点赞状态和数量)
    ```json
    {
      "count": 129,
      "isLiked": true
    }
    ```

### 8.8 获取视频评论列表

- **Endpoint:** `GET /videos/{id}/comments`
- **描述:** 获取指定视频下的所有评论（通常是树状结构）。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `List<CommentDto>`
    ```json
    [
      {
        "id": 1,
        "content": "讲得太好了！",
        "userId": 30,
        "authorName": "学习者A",
        "avatarUrl": "https://example.com/avatar1.png",
        "createdAt": "2023-10-29T11:00:00",
        "parentId": null
      },
      {
        "id": 2,
        "content": "感谢分享！",
        "userId": 31,
        "authorName": "学习者B",
        "avatarUrl": "https://example.com/avatar2.png",
        "createdAt": "2023-10-29T11:05:00",
        "parentId": 1
      }
    ]
    ```

### 8.9 发表视频评论

- **Endpoint:** `POST /videos/{id}/comments`
- **描述:** 为指定视频发表一条新评论。
- **路径参数:**
    - `id` (Long): 必需，视频ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `CommentCreateDto`
    ```json
    {
      "userId": 32,
      "content": "这个知识点很有用。",
      "parentId": 1
    }
    ```
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `CommentDto` (返回创建好的完整评论信息)

---

## 9. 用户评价管理 (`/evaluations`)

此模块负责对用户的课程或学习表现进行评价。

### 9.1 创建新评价

- **Endpoint:** `POST /evaluations`
- **描述:** 提交一条新的用户评价。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `UserEvaluationDTO`
    ```json
    {
      "userId": 5,
      "periodId": 202301,
      "evaluatorId": 10,
      "totalScore": 95.5,
      "weightedScore": 96.2,
      "ranking": 3,
      "level": "优秀",
      "status": "completed",
      "comments": "该生表现优异，积极参与互动。"
    }
    ```
- **成功响应 (`code: 200`):** `{"code": 201, "msg": "评价创建成功", "data": null}` (注: code为示例)

### 9.2 获取所有评价

- **Endpoint:** `GET /evaluations`
- **描述:** 获取系统内所有的用户评价列表。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `List<UserEvaluationDTO>`
    ```json
    [
      {
        "id": 1,
        "userId": 5,
        "periodId": 202301,
        "evaluatorId": 10,
        "totalScore": 95.5,
        "weightedScore": 96.2,
        "ranking": 3,
        "level": "优秀",
        "status": "completed",
        "submitTime": "2023-10-29T12:00:00.000+00:00",
        "comments": "该生表现优异，积极参与互动。"
      }
    ]
    ```

### 9.3 获取单个评价

- **Endpoint:** `GET /evaluations/{id}`
- **描述:** 根据ID获取单个评价的详细信息。
- **路径参数:**
    - `id` (Long): 必需，评价的ID。
- **成功响应 (`code: 200`):**
    - **`data` 结构:** `UserEvaluationDTO` (结构同9.2中数组的元素)

### 9.4 更新评价

- **Endpoint:** `PUT /evaluations/{id}`
- **描述:** 根据ID更新一条已有的评价。
- **路径参数:**
    - `id` (Long): 必需，评价的ID。
- **请求体 (`Content-Type: application/json`):**
    - **结构:** `UserEvaluationDTO`
- **成功响应 (`code: 200`):** `{"code": 204, "msg": "评价更新成功", "data": null}` (注: code为示例)

### 9.5 删除评价

- **Endpoint:** `DELETE /evaluations/{id}`
- **描述:** 根据ID删除一条评价。
- **路径参数:**
    - `id` (Long): 必需，评价的ID。
- **成功响应 (`code: 200`):** `{"code": 202, "msg": "评价删除成功", "data": null}` (注: code为示例) 
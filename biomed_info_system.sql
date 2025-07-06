/*
 Navicat Premium Data Transfer

 Source Server         : mypetstore
 Source Server Type    : MySQL
 Source Server Version : 90001 (9.0.1)
 Source Host           : localhost:3306
 Source Schema         : biomed_info_system

 Target Server Type    : MySQL
 Target Server Version : 90001 (9.0.1)
 File Encoding         : 65001

 Date: 06/07/2025 15:02:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_conversation
-- ----------------------------
DROP TABLE IF EXISTS `ai_conversation`;
CREATE TABLE `ai_conversation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话ID',
  `message_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息类型(user/assistant)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容',
  `context` json NULL COMMENT '上下文信息',
  `model_used` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '使用的AI模型',
  `response_time` int NULL DEFAULT NULL COMMENT '响应时间(毫秒)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_session`(`user_id` ASC, `session_id` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE,
  CONSTRAINT `ai_conversation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_conversation
-- ----------------------------
INSERT INTO `ai_conversation` VALUES (1, 108, 'sess_20240701_001', 'user', '请介绍一下血府逐瘀汤的组成和功效', NULL, 'gpt-3.5-turbo', NULL, '2025-07-06 11:02:16');
INSERT INTO `ai_conversation` VALUES (2, 108, 'sess_20240701_001', 'assistant', '血府逐瘀汤出自《医林改错》，由王清任创制。组成：桃仁12g，红花9g，当归9g，生地黄9g，川芎4.5g，赤芍6g，牛膝9g，桔梗4.5g，柴胡3g，枳壳6g，甘草3g。功效：活血祛瘀，行气止痛。主治胸中血瘀，血行不畅所致的胸痛、头痛等症。', NULL, 'gpt-3.5-turbo', 1200, '2025-07-06 11:02:16');
INSERT INTO `ai_conversation` VALUES (3, 109, 'sess_20240702_001', 'user', '川芎和当归在方剂中如何配伍？', NULL, 'gpt-3.5-turbo', NULL, '2025-07-06 11:02:16');
INSERT INTO `ai_conversation` VALUES (4, 109, 'sess_20240702_001', 'assistant', '川芎与当归是经典的血分药物配伍。当归补血活血，川芎行气活血。两药相配，当归补中有行，川芎行中有补，既能养血又能活血，补而不滞，行而不伤。在血府逐瘀汤、四物汤等方中都有此配伍。', NULL, 'gpt-3.5-turbo', 980, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程标题',
  `subtitle` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '课程副标题',
  `category_id` int NOT NULL COMMENT '分类ID',
  `teacher_id` bigint NOT NULL COMMENT '教师ID',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '课程介绍',
  `objectives` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '学习目标',
  `difficulty_level` tinyint NULL DEFAULT 1 COMMENT '难度等级 1-5',
  `duration` int NULL DEFAULT NULL COMMENT '课程时长(分钟)',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '课程价格',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态',
  `view_count` int NULL DEFAULT 0 COMMENT '观看次数',
  `student_count` int NULL DEFAULT 0 COMMENT '学生数量',
  `rating` decimal(3, 1) NULL DEFAULT 0.0 COMMENT '评分',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_teacher`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `edu_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `course_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '中医基础理论精讲', '系统学习中医理论核心内容', 1, 101, NULL, '本课程全面讲解中医基础理论的核心内容，包括阴阳五行、脏腑经络、气血津液等重要概念', NULL, 2, NULL, 0.00, 'published', 1580, 126, 4.7, NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `course` VALUES (2, '方剂学实用教程', '经典方剂的临床应用指导', 2, 101, NULL, '深入讲解经典方剂的组方原理、功效主治及临床应用技巧', NULL, 3, NULL, 0.00, 'published', 890, 89, 4.8, NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `course` VALUES (3, '中药材野外识别', '实地识别常用中药材', 3, 108, NULL, '通过实地考察和标本观察，掌握常用中药材的识别要点', NULL, 2, NULL, 0.00, 'published', 456, 67, 4.5, NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for course_chapter
-- ----------------------------
DROP TABLE IF EXISTS `course_chapter`;
CREATE TABLE `course_chapter`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '章节标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '章节描述',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `duration` int NULL DEFAULT 0 COMMENT '时长',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `course_chapter_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程章节表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_chapter
-- ----------------------------
INSERT INTO `course_chapter` VALUES (1, 1, '阴阳学说', '阴阳的基本概念、特性及在中医学中的应用', 1, 120, '2025-07-06 11:02:16');
INSERT INTO `course_chapter` VALUES (2, 1, '五行学说', '五行的基本概念、特性及脏腑归属', 2, 150, '2025-07-06 11:02:16');
INSERT INTO `course_chapter` VALUES (3, 2, '解表剂', '解表剂的分类、代表方剂及临床应用', 1, 180, '2025-07-06 11:02:16');
INSERT INTO `course_chapter` VALUES (4, 2, '补益剂', '补益剂的分类、代表方剂及临床应用', 2, 200, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for course_lesson
-- ----------------------------
DROP TABLE IF EXISTS `course_lesson`;
CREATE TABLE `course_lesson`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `chapter_id` bigint NOT NULL COMMENT '章节ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课时标题',
  `content_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容类型(video/document/quiz)',
  `content_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '内容地址',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文本内容',
  `duration` int NULL DEFAULT 0 COMMENT '时长(秒)',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `is_free` tinyint NULL DEFAULT 0 COMMENT '是否免费',
  `view_count` int NULL DEFAULT 0 COMMENT '观看次数',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter`(`chapter_id` ASC) USING BTREE,
  INDEX `idx_course`(`course_id` ASC) USING BTREE,
  CONSTRAINT `course_lesson_ibfk_1` FOREIGN KEY (`chapter_id`) REFERENCES `course_chapter` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `course_lesson_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程课时表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_lesson
-- ----------------------------
INSERT INTO `course_lesson` VALUES (1, 1, 1, '阴阳的基本概念', 'video', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/courses/yinyang-concept.mp4', NULL, 1800, 1, 1, 0, '2025-07-06 11:02:16');
INSERT INTO `course_lesson` VALUES (2, 1, 1, '阴阳的相互关系', 'video', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/courses/yinyang-relation.mp4', NULL, 2100, 2, 0, 0, '2025-07-06 11:02:16');
INSERT INTO `course_lesson` VALUES (3, 3, 2, '麻黄汤的组成与功效', 'video', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/courses/mahuang-tang.mp4', NULL, 1650, 1, 1, 0, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for course_note
-- ----------------------------
DROP TABLE IF EXISTS `course_note`;
CREATE TABLE `course_note`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `lesson_id` bigint NOT NULL COMMENT '课时ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '笔记内容',
  `timestamp` int NULL DEFAULT 0 COMMENT '视频时间点(秒)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `lesson_id`(`lesson_id` ASC) USING BTREE,
  INDEX `idx_user_lesson`(`user_id` ASC, `lesson_id` ASC) USING BTREE,
  CONSTRAINT `course_note_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `course_note_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `course_lesson` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程笔记表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_note
-- ----------------------------
INSERT INTO `course_note` VALUES (1, 108, 1, '阴阳是中医理论的核心，阴阳失调是疾病的根本原因', 680, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `course_note` VALUES (2, 108, 2, '阴阳相互依存、相互制约、相互转化', 1250, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `course_note` VALUES (3, 109, 3, '麻黄汤：麻黄、桂枝、杏仁、甘草，主治外感风寒表实证', 890, '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for disease
-- ----------------------------
DROP TABLE IF EXISTS `disease`;
CREATE TABLE `disease`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '疾病名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '疾病编码',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '疾病分类',
  `symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主要症状',
  `pathogenesis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '病因病机',
  `syndrome_differentiation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '辨证要点',
  `treatment_principle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '治疗原则',
  `prevention` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预防措施',
  `prognosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预后',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '疾病信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of disease
-- ----------------------------
INSERT INTO `disease` VALUES (1, '血瘀头痛', 'G44.001', '头痛', '头痛如刺，痛有定处，舌质紫暗，脉涩', '瘀血阻络，不通则痛', NULL, '活血化瘀，通络止痛', NULL, NULL, '2025-07-06 11:02:16');
INSERT INTO `disease` VALUES (2, '脾胃气虚', 'K59.001', '脾胃病', '食少便溏，神疲乏力，面色萎黄，舌淡苔白', '脾胃虚弱，运化失职', NULL, '健脾益气，调理脾胃', NULL, NULL, '2025-07-06 11:02:16');
INSERT INTO `disease` VALUES (3, '风热感冒', 'J00.001', '外感病', '发热，头痛，咽痛，咳嗽，舌红苔薄黄', '风热之邪侵袭肺卫', NULL, '疏风清热，宣肺解表', NULL, NULL, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for edu_categories
-- ----------------------------
DROP TABLE IF EXISTS `edu_categories`;
CREATE TABLE `edu_categories`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称 (如: 试验课程, 课题研究)',
  `slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类别名 (用于URL, e.g., experiment-course)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_slug`(`slug` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学资源分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_categories
-- ----------------------------
INSERT INTO `edu_categories` VALUES (1, '试验课程', 'experiment-course', NULL);
INSERT INTO `edu_categories` VALUES (2, '课题研究', 'research-project', NULL);
INSERT INTO `edu_categories` VALUES (3, '培训素材', 'training-material', NULL);

-- ----------------------------
-- Table structure for edu_resource_video_link
-- ----------------------------
DROP TABLE IF EXISTS `edu_resource_video_link`;
CREATE TABLE `edu_resource_video_link`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联主键ID',
  `resource_id` bigint NOT NULL COMMENT '外键：教学资源ID',
  `video_id` bigint NOT NULL COMMENT '外键：教学视频ID',
  `display_order` int NOT NULL DEFAULT 0 COMMENT '显示顺序 (用于课程章节排序)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_resource_video`(`resource_id` ASC, `video_id` ASC) USING BTREE,
  INDEX `fk_link_video_id`(`video_id` ASC) USING BTREE,
  CONSTRAINT `fk_link_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `edu_resources` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_link_video_id` FOREIGN KEY (`video_id`) REFERENCES `edu_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源与视频的关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_resource_video_link
-- ----------------------------

-- ----------------------------
-- Table structure for edu_resources
-- ----------------------------
DROP TABLE IF EXISTS `edu_resources`;
CREATE TABLE `edu_resources`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '资源主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源标题',
  `category_id` int NOT NULL COMMENT '外键：关联的分类ID',
  `author_id` bigint NOT NULL COMMENT '外键：作者的用户ID',
  `cover_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片URL',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '资源主体内容 (由富文本编辑器生成)',
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT '状态 (draft-草稿, published-已发布, archived-已归档)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `published_at` timestamp NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_author_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `fk_resource_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_resource_category_id` FOREIGN KEY (`category_id`) REFERENCES `edu_categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学资源主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_resources
-- ----------------------------
INSERT INTO `edu_resources` VALUES (2, '关于特定环境下当归成分变化的初步研究', 2, 2, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'archived', '2025-06-27 14:13:48', '2025-06-27 14:13:48', '2025-07-03 15:36:17');
INSERT INTO `edu_resources` VALUES (3, '关于现代生活中中医药的用法', 1, 110, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'published', '2025-06-30 19:57:28', '2025-06-30 19:57:34', NULL);
INSERT INTO `edu_resources` VALUES (4, '论为什么中医药在抗疫中发挥了重要作用', 3, 108, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'draft', '2025-06-30 20:06:50', '2025-06-30 20:06:55', NULL);
INSERT INTO `edu_resources` VALUES (5, '论华迪为什么式神', 2, 111, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'archived', '2025-06-30 20:18:52', '2025-06-30 20:18:57', NULL);
INSERT INTO `edu_resources` VALUES (6, '论枸杞的药用成分', 2, 101, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'published', '2025-07-01 14:06:14', '2025-07-01 14:07:18', NULL);
INSERT INTO `edu_resources` VALUES (7, '测试用例测试用例', 2, 111, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/0700c483-213f-4016-b2fc-82567999473c_shu.jpg', '<h2>都说了这个是测试用例！！！</h2>', 'published', '2025-07-02 09:23:44', '2025-07-02 20:48:28', '2025-07-02 09:23:44');
INSERT INTO `edu_resources` VALUES (8, '关于外国对中医药的了解', 2, 109, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/6a4d3ba0-e65c-4295-a2ef-f405672aa29d_dkss(1).jpg', '<h2>得克萨斯州的中医药了解程度</h2><p>我们应当抱着一颗虔诚的心去学习中医药理论</p><p>学习很重要</p>', 'published', '2025-07-02 11:11:41', '2025-07-02 11:11:40', '2025-07-02 11:11:41');
INSERT INTO `edu_resources` VALUES (10, '青年与长辈之间也需要中药调节', 1, 112, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/52661b01-c54b-4234-b887-b105f004152b_ae8c8b41e23ce12919e5c325f81098d.jpg', '<h2>中医药自古以来都十分重要</h2><p>早在本草纲目当中我们就可以看到……</p>', 'draft', '2025-07-03 16:18:28', '2025-07-03 16:18:27', '2025-07-03 16:55:27');
INSERT INTO `edu_resources` VALUES (11, '小狗疾病也可以用中药医治', 2, 112, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/e59e2ef1-869f-4ede-9a58-45b7390d346f_dbd15a4bd68e367668cb168c113e489.jpg', '<h2>不求额定</h2>', 'draft', '2025-07-03 17:38:24', '2025-07-03 17:38:23', NULL);

-- ----------------------------
-- Table structure for edu_videos
-- ----------------------------
DROP TABLE IF EXISTS `edu_videos`;
CREATE TABLE `edu_videos`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '视频主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '视频简介',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频文件URL (来自OSS)',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频封面URL (可选)',
  `duration` int NULL DEFAULT 0 COMMENT '视频时长 (单位: 秒)',
  `uploader_id` bigint NOT NULL COMMENT '外键：上传者的用户ID',
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT '状态 (draft-草稿, published-已发布, archived-已归档)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uploader_id`(`uploader_id` ASC) USING BTREE,
  CONSTRAINT `fk_video_uploader_id` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学视频库' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_videos
-- ----------------------------
INSERT INTO `edu_videos` VALUES (4, '陆岳本人', '这是一个帅哥名字叫陆岳', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/bd91c4f7-4b28-4981-9f8c-044a66a7d6c7_Luyue.mp4', NULL, 3, 109, 'archived', '2025-07-02 09:27:02');
INSERT INTO `edu_videos` VALUES (5, '第二个视频', '第二次上传', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/062abe4f-0424-4f3b-b693-7f1567aa247b_Luyue.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/8772636c-54a8-4566-a9b2-aef824f5a185_006.jpg', 3, 109, 'published', '2025-07-02 09:32:07');
INSERT INTO `edu_videos` VALUES (6, '实地考察记录', '这是一群年轻人', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/d85d3c11-7bfa-48c0-9a97-f8720e3c0919_f35c764572f5e65322f9f752476feecd_20250702_11155361.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/8617965d-a347-48bb-a011-609a885eb5db_003().jpg', 33, 108, 'archived', '2025-07-02 11:20:16');
INSERT INTO `edu_videos` VALUES (7, '暗访陕西地头蛇', '一群勇敢的年轻人暗访黑暗组织', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/9ed1aedb-b262-4e86-88b3-e351cc2334ed_video02.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/dd2e63fc-2fe0-4003-ab46-b88a1809bc36_暴行03.jpg', 30, 111, 'draft', '2025-07-02 14:42:58');
INSERT INTO `edu_videos` VALUES (9, '风土人情', '精彩不', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/d861b755-6938-4d72-8ef6-573dabf53d2a_春晚.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/06309d05-58cf-4292-9de0-7b86049603d6_微信图片_20230929192031.jpg', 6, 112, 'draft', '2025-07-03 16:13:49');
INSERT INTO `edu_videos` VALUES (10, '日常生活中中医药扑朔迷离', '中南大学防灾演练', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/eba7c217-e162-459d-86ea-2e1863a9d003_a0446cdfd5739c8178c07d627646e7bd.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/86aa6257-438a-4d28-9fc9-44afcf345076_德克萨斯05.jpg', 24, 112, 'published', '2025-07-03 17:10:02');
INSERT INTO `edu_videos` VALUES (11, '尖叫抛开', '哈哈哈哈', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/6c6e2d83-b8fc-4811-a6a5-dd783ccb187d_8036009a518ce052038cf62fb2c2b50f.mp4', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/5c6a45d0-cb0e-4fb5-bd39-e290b8d766c0_1f995e76e448fe1ad4a24c927ebef62.jpg', 3, 112, 'published', '2025-07-03 17:38:57');

-- ----------------------------
-- Table structure for evaluation_dimension
-- ----------------------------
DROP TABLE IF EXISTS `evaluation_dimension`;
CREATE TABLE `evaluation_dimension`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '维度名称',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '维度代码',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '维度描述',
  `weight` decimal(5, 2) NOT NULL COMMENT '权重',
  `parent_id` int NULL DEFAULT 0 COMMENT '父级维度',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价维度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluation_dimension
-- ----------------------------
INSERT INTO `evaluation_dimension` VALUES (1, '教学工作', 'TEACHING', '教学工作相关评价', 30.00, 0, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_dimension` VALUES (2, '科研工作', 'RESEARCH', '科研工作相关评价', 40.00, 0, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_dimension` VALUES (3, '服务工作', 'SERVICE', '服务工作相关评价', 20.00, 0, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_dimension` VALUES (4, '创新发展', 'INNOVATION', '创新发展相关评价', 10.00, 0, 0, 1, '2025-07-06 10:51:30');

-- ----------------------------
-- Table structure for evaluation_indicator
-- ----------------------------
DROP TABLE IF EXISTS `evaluation_indicator`;
CREATE TABLE `evaluation_indicator`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `dimension_id` int NOT NULL COMMENT '所属维度ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标名称',
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '指标代码',
  `data_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据类型',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计量单位',
  `calculation_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '计算方法',
  `weight` decimal(5, 2) NOT NULL COMMENT '权重',
  `max_score` decimal(6, 2) NULL DEFAULT 100.00 COMMENT '最高分值',
  `scoring_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评分规则',
  `auto_calculate` tinyint NULL DEFAULT 0 COMMENT '是否自动计算',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dimension`(`dimension_id` ASC) USING BTREE,
  CONSTRAINT `evaluation_indicator_ibfk_1` FOREIGN KEY (`dimension_id`) REFERENCES `evaluation_dimension` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价指标表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluation_indicator
-- ----------------------------
INSERT INTO `evaluation_indicator` VALUES (1, 1, '教学工作量', 'TEACHING_HOURS', 'number', '课时', NULL, 40.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (2, 1, '学生评教', 'STUDENT_EVALUATION', 'number', '分', NULL, 30.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (3, 1, '教学改革项目', 'TEACHING_REFORM', 'number', '项', NULL, 30.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (4, 2, '发表论文', 'RESEARCH_PAPERS', 'number', '篇', NULL, 50.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (5, 2, '科研项目', 'RESEARCH_PROJECTS', 'number', '项', NULL, 30.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (6, 2, '科研经费', 'RESEARCH_FUNDING', 'number', '万元', NULL, 20.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (7, 3, '学术兼职', 'ACADEMIC_POSITIONS', 'number', '个', NULL, 50.00, 100.00, NULL, 0, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (8, 3, '社会服务', 'SOCIAL_SERVICE', 'number', '次', NULL, 50.00, 100.00, NULL, 0, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (9, 4, '创新项目', 'INNOVATION_PROJECTS', 'number', '项', NULL, 60.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');
INSERT INTO `evaluation_indicator` VALUES (10, 4, '专利成果', 'PATENTS', 'number', '件', NULL, 40.00, 100.00, NULL, 1, 0, 1, '2025-07-06 10:51:30');

-- ----------------------------
-- Table structure for evaluation_period
-- ----------------------------
DROP TABLE IF EXISTS `evaluation_period`;
CREATE TABLE `evaluation_period`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '周期名称',
  `period_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '周期类型',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dates`(`start_date` ASC, `end_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价周期表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluation_period
-- ----------------------------
INSERT INTO `evaluation_period` VALUES (1, '2024年度教师业绩评价', 'annual', '2024-01-01', '2024-12-31', 'active', '2024年度全体教师年终业绩考核评价', 1, '2025-07-06 11:02:16');
INSERT INTO `evaluation_period` VALUES (2, '2024年上半年教学评价', 'semester', '2024-02-26', '2024-07-15', 'closed', '2024年春季学期教学工作专项评价', 1, '2025-07-06 11:02:16');
INSERT INTO `evaluation_period` VALUES (3, '2024年第三季度科研评价', 'quarterly', '2024-07-01', '2024-09-30', 'active', '第三季度科研工作进展评价', 1, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for formula
-- ----------------------------
DROP TABLE IF EXISTS `formula`;
CREATE TABLE `formula` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL COMMENT '方剂名称',
    `alias` VARCHAR(200) COMMENT '别名',
    `source` VARCHAR(100) COMMENT '出处典籍',
    `dynasty` VARCHAR(50) COMMENT '朝代',
    `author` VARCHAR(100) COMMENT '创方人',
    `category_id` INT COMMENT '分类ID',
    `composition` TEXT COMMENT '药物组成',
    `preparation` TEXT COMMENT '制法',
    `usage` TEXT COMMENT '用法',
    `dosage_form` VARCHAR(50) COMMENT '剂型',
    `function_effect` TEXT COMMENT '功用',
    `main_treatment` TEXT COMMENT '主治',
    `clinical_application` TEXT COMMENT '临床应用',
    `pharmacological_action` TEXT COMMENT '药理作用',
    `contraindication` TEXT COMMENT '禁忌',
    `caution` TEXT COMMENT '注意事项',
    `modern_research` TEXT COMMENT '现代研究',
    `remarks` TEXT COMMENT '备注',
    `status` TINYINT DEFAULT 1 COMMENT '状态 1-正常 0-禁用',
    `created_by` BIGINT COMMENT '创建人',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_name` (`name`),
    INDEX `idx_source` (`source`),
    INDEX `idx_category` (`category_id`)
) COMMENT '方剂基本信息表';

-- ----------------------------
-- Table structure for formula_category
-- ----------------------------
DROP TABLE IF EXISTS `formula_category`;
CREATE TABLE `formula_category` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `parent_id` INT DEFAULT 0 COMMENT '父级分类ID',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `description` TEXT COMMENT '分类描述',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT '方剂分类表';

-- ----------------------------
-- Table structure for formula_herb
-- ----------------------------
DROP TABLE IF EXISTS `formula_herb`;
CREATE TABLE `formula_herb` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `formula_id` BIGINT NOT NULL COMMENT '方剂ID',
    `herb_id` BIGINT NOT NULL COMMENT '药材ID',
    `herb_name` VARCHAR(50) NOT NULL COMMENT '药材名称',
    `dosage` VARCHAR(20) COMMENT '用量',
    `unit` VARCHAR(10) COMMENT '单位',
    `role` VARCHAR(20) COMMENT '配伍作用(君臣佐使)',
    `processing` VARCHAR(50) COMMENT '炮制方法',
    `usage_note` TEXT COMMENT '用法备注',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`formula_id`) REFERENCES `formula`(`id`) ON DELETE CASCADE,
    INDEX `idx_formula` (`formula_id`),
    INDEX `idx_herb` (`herb_id`)
) COMMENT '方剂药物组成表';

-- ----------------------------
-- Table structure for formula_disease
-- ----------------------------
DROP TABLE IF EXISTS `formula_disease`;
CREATE TABLE `formula_disease` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `formula_id` BIGINT NOT NULL COMMENT '方剂ID',
    `disease_name` VARCHAR(100) NOT NULL COMMENT '疾病名称',
    `disease_code` VARCHAR(50) COMMENT '疾病编码',
    `syndrome` VARCHAR(200) COMMENT '证候',
    `efficacy_level` TINYINT COMMENT '疗效等级 1-5',
    `evidence_level` VARCHAR(20) COMMENT '循证等级',
    `clinical_data` TEXT COMMENT '临床数据',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`formula_id`) REFERENCES `formula`(`id`) ON DELETE CASCADE,
    INDEX `idx_formula` (`formula_id`),
    INDEX `idx_disease` (`disease_name`)
) COMMENT '方剂主治疾病关联表';

-- ----------------------------
-- Table structure for formula_modification
-- ----------------------------
DROP TABLE IF EXISTS `formula_modification`;
CREATE TABLE `formula_modification` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `base_formula_id` BIGINT NOT NULL COMMENT '基础方剂ID',
    `modified_name` VARCHAR(100) COMMENT '加减方名称',
    `modification_type` VARCHAR(20) COMMENT '变化类型(加味、减味、药量调整)',
    `condition_description` TEXT COMMENT '适应条件',
    `herb_changes` TEXT COMMENT '药物变化详情',
    `effect_changes` TEXT COMMENT '功效变化',
    `created_by` BIGINT COMMENT '创建人',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`base_formula_id`) REFERENCES `formula`(`id`) ON DELETE CASCADE
) COMMENT '方剂加减变化表';

-- ----------------------------
-- Table structure for formula_case
-- ----------------------------
DROP TABLE IF EXISTS `formula_case`;
CREATE TABLE `formula_case` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `formula_id` BIGINT NOT NULL COMMENT '方剂ID',
    `case_title` VARCHAR(200) COMMENT '医案标题',
    `patient_info` TEXT COMMENT '患者信息',
    `chief_complaint` TEXT COMMENT '主诉',
    `history_present` TEXT COMMENT '现病史',
    `physical_exam` TEXT COMMENT '体格检查',
    `tongue_pulse` TEXT COMMENT '舌脉',
    `tcm_diagnosis` TEXT COMMENT '中医诊断',
    `treatment_principle` TEXT COMMENT '治法',
    `prescription` TEXT COMMENT '处方',
    `follow_up` TEXT COMMENT '随访记录',
    `outcome` TEXT COMMENT '疗效',
    `doctor_name` VARCHAR(50) COMMENT '医生姓名',
    `hospital` VARCHAR(100) COMMENT '医院',
    `case_date` DATE COMMENT '医案日期',
    `source` VARCHAR(100) COMMENT '资料来源',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`formula_id`) REFERENCES `formula`(`id`) ON DELETE CASCADE
) COMMENT '方剂临床验案表';

-- ----------------------------
-- Table structure for formula_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `formula_evaluation`;
CREATE TABLE `formula_evaluation` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `formula_id` BIGINT NOT NULL COMMENT '方剂ID',
    `evaluator_id` BIGINT COMMENT '评价人ID',
    `evaluation_type` VARCHAR(20) COMMENT '评价类型(临床疗效、安全性、经济性)',
    `score` DECIMAL(3,1) COMMENT '评分',
    `evaluation_content` TEXT COMMENT '评价内容',
    `evidence_files` TEXT COMMENT '证据文件',
    `evaluation_date` DATE COMMENT '评价日期',
    `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`formula_id`) REFERENCES `formula`(`id`) ON DELETE CASCADE
) COMMENT '方剂评价表';

-- ----------------------------
-- Table structure for herb
-- ----------------------------
DROP TABLE IF EXISTS `herb`;
CREATE TABLE `herb`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '药材名称',
  `scientific_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学名',
  `family_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科名',
  `resource_type` enum('野生','栽培') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '野生' COMMENT '资源类型 (野生/栽培)',
  `life_form` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生活型 (如: 乔木, 灌木, 多年生草本)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '简介/药用价值描述',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name` ASC) USING BTREE COMMENT '药材名称唯一索引'
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材主信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb
-- ----------------------------
INSERT INTO `herb` VALUES (1, '人参', 'Panax ginseng', '五加科', '栽培', '多年生草本', '补气固脱，健脾益肺，宁心益智，养血生津。', '2025-06-27 13:42:19', '2025-06-29 19:22:03');
INSERT INTO `herb` VALUES (2, '枸杞', 'Lycium barbarum', '茄科', '栽培', '灌木', '滋补肝肾，益精明目。用于虚劳精亏，腰膝酸痛，眩晕耳鸣，内热消渴，血虚萎黄，目昏不明。', '2025-06-27 13:42:19', '2025-07-01 11:52:57');
INSERT INTO `herb` VALUES (3, '当归', 'Angelica sinensis', '伞形科', '栽培', '多年生草本', '补血活血，调经止痛，润肠通便。', '2025-06-27 13:42:19', '2025-06-28 10:16:32');
INSERT INTO `herb` VALUES (4, '小花黄堇', 'Corydalis racemosa (Thunb.) Pers.', '罂粟科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:49');
INSERT INTO `herb` VALUES (5, '地锦苗', 'Corydalis sheareri S. Moore', '罂粟科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:50');
INSERT INTO `herb` VALUES (6, '红豆', 'Vigna unguiculata (Linn.) Walp.', '豆科', '栽培', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:51');
INSERT INTO `herb` VALUES (7, '蚁蚀草', 'Pteris vittata L.', '凤尾蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:52');
INSERT INTO `herb` VALUES (8, '毛轴鞭米蕨', 'Cheilosoria chusana (Hook.) Ching et Shing', '中国蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:52');
INSERT INTO `herb` VALUES (9, '野罂粟金粉蕨', 'Onychium japonicum (Thunb.) Kuntze', '野罂粟金粉蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:53');
INSERT INTO `herb` VALUES (10, '卷柏铁线蕨', 'Adiantum flabellulatum L.', '铁线蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:54');
INSERT INTO `herb` VALUES (11, '新兴尖毛蕨', 'Cyclosorus acuminatus (Houtt.) Nakai', '金腰蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:54');
INSERT INTO `herb` VALUES (12, '华南毛蕨', 'Cyclosorus parasiticus (L.) Farwell', '金腰蕨科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:55');
INSERT INTO `herb` VALUES (13, '野鸦椿', 'Euscaphis japonica (Thunb.) Dippel', '省油茶科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:56');
INSERT INTO `herb` VALUES (14, '光核勾儿茶', 'Berchemia polyphylla Wall. ex M. A. Lawsen var. leioclada (Hand.-Mazz.) Hand.-Mazz.', '鼠李科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:56');
INSERT INTO `herb` VALUES (15, '马甲子', 'Paliurus ramosissimus (Lour.) Poir', '鼠李科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:57');
INSERT INTO `herb` VALUES (16, '小菊花', 'Wikstroemia micrantha Hemsl.', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:57');
INSERT INTO `herb` VALUES (17, '长葛蓬莱菜', 'Viola inconspicua Bl.', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:58');
INSERT INTO `herb` VALUES (18, '西跌草', 'Oxalis corniculata L.', '酢浆草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:59');
INSERT INTO `herb` VALUES (19, '红花西跌草', 'Oxalis cornymbosa DC.', '酢浆草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:16:59');
INSERT INTO `herb` VALUES (20, '尼泊尔充篷草', 'Geranium nepalense Sweet', '横叶儿苗科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:17:00');
INSERT INTO `herb` VALUES (21, '展毛野牡丹', 'Melastoma normale D. Don', '野牡丹科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (22, '鸡矢藤', 'Paederia scandens (Lour.) Merr.', '茜草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (23, '翻果菊', 'Pterocypsela indica (L.) Shih', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (24, '筋骨草', 'Ajuga decumbens Thunb.', '唇形科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (25, '细风轮菜', 'Clinopodium gracile (Benth.) Matsum.', '居麻科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (26, '灯亮草', 'Clinopodium polycephalum (Vaniot) C.Y. Wu et H.W. Li', '居麻科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (27, '针茅菊', 'Aster subulatus Michx.', '菊科', '栽培', '家养', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (28, '夜香树', 'Cestrum nocturnum L.', '茄科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (29, '夜香藤', 'Rostellularia procumbens (L.) Nees', '本术科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (30, '鬼针草', 'Bidens bipinnata L.', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (31, '东风菊', 'Bidens tripartita L.', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (32, '瑞英', 'Blumea megacephala (Randeria) Chang et Y.Q. Tseng', '菊科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (33, '天名精', 'Carpesium abrotanodies L.', '天名精科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (34, '天冬', 'Asparagus cochinchinensis (Lour.) Merr.', '百合科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (35, '长葶万年竹', 'Disporum bodinieri (Lév. et Vaniot) Wang et Tang', '百合科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (36, '使君子', 'Quisqualis indica L.', '使君子科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (37, '大拟莎草', 'Carex lanceolata Boott', '莎草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (38, '西溪莎草', 'Cyperus iria L.', '莎草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (39, '圆头莎草', 'Cyperus rotundus L.', '莎草科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (40, '石南藤', 'Piper wallichii (Miq.) Hand.-Mazz.', '胡椒科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (41, '陕甘花楸', 'Sorbus koehneana C.K. Schneid', '蔷薇科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (42, '日本落叶松', 'Larix kaempferi (Lamb.) Carriere', '松科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (43, '柞木溲疏', 'Geum japonicum Thunb. var. chinense Bolle', '蔷薇科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (44, '柞木松', 'Smilax chingii F.T. Wang & Tang', '百合科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (45, '蛇足山旋花', 'Stachyurus himalaicus Hook.f. et Thoms.', '旋花科', '野生', '一年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (46, '金豆', 'Camptolypis macrocarpa var. glabrusculum Schneid', '豆科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (47, '朱槿(变种)', 'Hibiscus rosa-sinensis (L.) Druce', '芸香科', '栽培', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (48, '细风轮菜(变种)', 'Phellodendron chinense Schneid. var. glabrusculum Schneid', '五加科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (49, '木兰', 'Schizophragma molle (Rehd.) Chun', '木兰科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (50, '钩叶地黄', 'Pedicularis verticillata L.', '玄参科', '野生', '一年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (51, '柞木溲疏(变种)', 'Hydrangea rosthornii Diels', '虎耳草科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (52, '叶萼', 'Hemipilia henryi Rechb. f. ex Rolfe', '石竹科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (53, '南川盾民盾草(变种)', 'Epimedium sagittatum (Sieb. et Zucc.) Maxim.', '小檗科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (54, '盾盾草', 'Svalia nanchuanensis H.T. Sun var. nanchuanensis form. intermedia H.T. Sun', '属科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (55, '报春花', 'Pyrossia precaborea (Hand.-Mazz.) Ching', '报春花科', '野生', '灌木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (56, '长葶万年竹(变种)', 'Lysimachia paridiformis Franch.', '百合科', '野生', '多年生草本植物', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (57, '落叶松(变种)', 'Idesia polycarpa Maxim. var. vestita Diels', '落叶松科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');
INSERT INTO `herb` VALUES (58, '毛鹊树(变种)', 'Cotinus coggygria Scop. var. pubescens Engl.', '漆树科', '野生', '乔木', '根据重庆地区数据批量导入', '2025-06-28 10:15:39', '2025-06-28 10:15:39');

-- ----------------------------
-- Table structure for herb_growth_data
-- ----------------------------
DROP TABLE IF EXISTS `herb_growth_data`;
CREATE TABLE `herb_growth_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `location_id` bigint NOT NULL COMMENT '外键：关联的观测点ID',
  `metric_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称 (如: 产量, 平均株高)',
  `metric_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标值',
  `metric_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '指标单位 (如: 公斤, 厘米)',
  `recorded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_location_metric`(`location_id` ASC, `metric_name` ASC) USING BTREE COMMENT '同一观测点同一指标唯一',
  CONSTRAINT `fk_data_location_id` FOREIGN KEY (`location_id`) REFERENCES `herb_location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生长/统计数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_growth_data
-- ----------------------------

-- ----------------------------
-- Table structure for herb_growth_data_history
-- ----------------------------
DROP TABLE IF EXISTS `herb_growth_data_history`;
CREATE TABLE `herb_growth_data_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史记录主键ID',
  `origin_id` bigint NOT NULL COMMENT '原数据表的主键ID',
  `location_id` bigint NOT NULL COMMENT '关联的观测点ID',
  `metric_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称',
  `old_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变更前的值',
  `new_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变更后的值',
  `action` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型 (如: CREATE, UPDATE, DELETE)',
  `changed_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'system' COMMENT '操作人',
  `changed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '变更时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '变更备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_history_origin_id`(`origin_id` ASC) USING BTREE,
  INDEX `idx_history_location_id`(`location_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生长/统计数据变更历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_growth_data_history
-- ----------------------------
INSERT INTO `herb_growth_data_history` VALUES (1, 3, 2, '预估产量', '800', '850', 'UPDATE', 'admin', '2025-06-27 13:42:19', '根据最新航拍数据修正');
INSERT INTO `herb_growth_data_history` VALUES (2, 3, 14, '预估产量', '400', '850', 'UPDATE', 'system', '2025-06-30 10:26:15', '最新修正');
INSERT INTO `herb_growth_data_history` VALUES (3, 3, 12, '土壤PH', '7', '9', 'UPDATE', 'Lu', '2025-07-02 19:53:10', '最新观测修正');
INSERT INTO `herb_growth_data_history` VALUES (4, 3, 14, '含糖量', '45', '46', 'UPDATE', 'system', '2025-07-02 20:09:39', '最新修正');

-- ----------------------------
-- Table structure for herb_image
-- ----------------------------
DROP TABLE IF EXISTS `herb_image`;
CREATE TABLE `herb_image`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `herb_id` bigint NOT NULL COMMENT '外键：关联的药材ID',
  `location_id` bigint NULL DEFAULT NULL COMMENT '【可选】外键：关联的观测点ID，用于现场实拍图',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片地址URL',
  `is_primary` tinyint(1) NULL DEFAULT 0 COMMENT '是否为主图 (0-否, 1-是)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片描述',
  `uploaded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_herb_id_image`(`herb_id` ASC) USING BTREE,
  INDEX `idx_location_id_image`(`location_id` ASC) USING BTREE,
  CONSTRAINT `fk_image_herb_id` FOREIGN KEY (`herb_id`) REFERENCES `herb` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_image_location_id` FOREIGN KEY (`location_id`) REFERENCES `herb_location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材图片表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_image
-- ----------------------------
INSERT INTO `herb_image` VALUES (26, 31, 28, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751633356676_东风菊.webp', 0, '附加图片: 东风菊.webp', '2025-07-04 20:49:18');
INSERT INTO `herb_image` VALUES (27, 36, 29, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751633831589_使君子.webp', 0, '附加图片: 使君子.webp', '2025-07-04 20:57:12');
INSERT INTO `herb_image` VALUES (28, 14, 30, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751633915075_光核勾儿茶.webp', 0, '附加图片: 光核勾儿茶.webp', '2025-07-04 20:58:36');
INSERT INTO `herb_image` VALUES (29, 12, 31, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635264247_华南毛蕨.webp', 0, '附加图片: 华南毛蕨.webp', '2025-07-04 21:21:05');
INSERT INTO `herb_image` VALUES (30, 53, 32, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635336412_南川盾民盾草(变种).webp', 0, '附加图片: 南川盾民盾草(变种).webp', '2025-07-04 21:22:17');
INSERT INTO `herb_image` VALUES (31, 10, 33, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635427706_卷柏铁线蕨.webp', 0, '附加图片: 卷柏铁线蕨.webp', '2025-07-04 21:23:48');
INSERT INTO `herb_image` VALUES (32, 52, 34, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635521605_叶萼.webp', 0, '附加图片: 叶萼.webp', '2025-07-04 21:25:22');
INSERT INTO `herb_image` VALUES (33, 39, 35, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635634322_圆头莎草.webp', 0, '附加图片: 圆头莎草.webp', '2025-07-04 21:27:15');
INSERT INTO `herb_image` VALUES (34, 5, 36, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635669057_地锦苗.webp', 0, '附加图片: 地锦苗.webp', '2025-07-04 21:27:49');
INSERT INTO `herb_image` VALUES (35, 28, 37, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635688844_夜香树.webp', 0, '附加图片: 夜香树.webp', '2025-07-04 21:28:09');
INSERT INTO `herb_image` VALUES (36, 29, 38, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635707243_夜香藤.webp', 0, '附加图片: 夜香藤.webp', '2025-07-04 21:28:27');
INSERT INTO `herb_image` VALUES (37, 1, 39, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751635938577_人参.webp', 0, '附加图片: 人参.webp', '2025-07-04 21:32:19');
INSERT INTO `herb_image` VALUES (38, 33, 40, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700642469_天名精.webp', 0, '附加图片: 天名精.webp', '2025-07-05 15:30:43');
INSERT INTO `herb_image` VALUES (39, 4, 41, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700697030_小花黄堇.webp', 0, '附加图片: 小花黄堇.webp', '2025-07-05 15:31:37');
INSERT INTO `herb_image` VALUES (40, 16, 42, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700734738_小菊花.webp', 0, '附加图片: 小菊花.webp', '2025-07-05 15:32:15');
INSERT INTO `herb_image` VALUES (41, 20, 43, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700790603_尼泊尔充篷草.webp', 0, '附加图片: 尼泊尔充篷草.webp', '2025-07-05 15:33:11');
INSERT INTO `herb_image` VALUES (42, 21, 44, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700828047_展毛野牡丹.webp', 0, '附加图片: 展毛野牡丹.webp', '2025-07-05 15:33:49');
INSERT INTO `herb_image` VALUES (43, 3, 45, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700868385_当归.webp', 0, '附加图片: 当归.webp', '2025-07-05 15:34:28');
INSERT INTO `herb_image` VALUES (44, 55, 46, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700906052_报春花.webp', 0, '附加图片: 报春花.webp', '2025-07-05 15:35:06');
INSERT INTO `herb_image` VALUES (45, 11, 47, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700946747_新兴尖毛蕨.webp', 0, '附加图片: 新兴尖毛蕨.webp', '2025-07-05 15:35:48');
INSERT INTO `herb_image` VALUES (46, 42, 48, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751700996589_日本落叶松.webp', 0, '附加图片: 日本落叶松.webp', '2025-07-05 15:36:37');
INSERT INTO `herb_image` VALUES (47, 49, 49, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701029408_木兰.webp', 0, '附加图片: 木兰.webp', '2025-07-05 15:37:10');
INSERT INTO `herb_image` VALUES (48, 47, 50, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701080214_朱槿(变种).webp', 0, '附加图片: 朱槿(变种).webp', '2025-07-05 15:38:00');
INSERT INTO `herb_image` VALUES (49, 2, 51, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701122178_枸杞.webp', 0, '附加图片: 枸杞.webp', '2025-07-05 15:38:42');
INSERT INTO `herb_image` VALUES (50, 44, 52, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701160936_柞木松.webp', 0, '附加图片: 柞木松.webp', '2025-07-05 15:39:21');
INSERT INTO `herb_image` VALUES (51, 43, 53, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701206887_柞木溲疏.webp', 0, '附加图片: 柞木溲疏.webp', '2025-07-05 15:40:07');
INSERT INTO `herb_image` VALUES (52, 51, 54, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701250732_柞木溲疏(变种).webp', 0, '附加图片: 柞木溲疏(变种).webp', '2025-07-05 15:40:51');
INSERT INTO `herb_image` VALUES (53, 8, 55, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701298529_毛轴鞭米蕨.webp', 0, '附加图片: 毛轴鞭米蕨.webp', '2025-07-05 15:41:39');
INSERT INTO `herb_image` VALUES (54, 58, 56, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701344843_毛鹊树(变种).webp', 0, '附加图片: 毛鹊树(变种).webp', '2025-07-05 15:42:25');
INSERT INTO `herb_image` VALUES (55, 26, 57, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701404291_灯亮草.webp', 0, '附加图片: 灯亮草.webp', '2025-07-05 15:43:25');
INSERT INTO `herb_image` VALUES (56, 32, 58, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701653240_瑞英.webp', 0, '附加图片: 瑞英.webp', '2025-07-05 15:47:34');
INSERT INTO `herb_image` VALUES (57, 54, 59, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701733389_盾盾草.webp', 0, '附加图片: 盾盾草.webp', '2025-07-05 15:48:54');
INSERT INTO `herb_image` VALUES (58, 40, 60, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701793914_石南藤.webp', 0, '附加图片: 石南藤.webp', '2025-07-05 15:49:54');
INSERT INTO `herb_image` VALUES (59, 24, 61, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701840333_筋骨草.webp', 0, '附加图片: 筋骨草.webp', '2025-07-05 15:50:41');
INSERT INTO `herb_image` VALUES (60, 19, 62, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701892738_红花西跌草.webp', 0, '附加图片: 红花西跌草.webp', '2025-07-05 15:51:33');
INSERT INTO `herb_image` VALUES (61, 6, 63, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751701968705_红豆.webp', 0, '附加图片: 红豆.webp', '2025-07-05 15:52:49');
INSERT INTO `herb_image` VALUES (62, 25, 64, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702008063_细风轮菜.webp', 0, '附加图片: 细风轮菜.webp', '2025-07-05 15:53:29');
INSERT INTO `herb_image` VALUES (63, 48, 65, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702081064_细风轮菜(变种).jpg', 0, '附加图片: 细风轮菜(变种).jpg', '2025-07-05 15:54:42');
INSERT INTO `herb_image` VALUES (64, 23, 66, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702137720_翻果菊.webp', 0, '附加图片: 翻果菊.webp', '2025-07-05 15:55:38');
INSERT INTO `herb_image` VALUES (65, 57, 67, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702183033_落叶松(变种).webp', 0, '附加图片: 落叶松(变种).webp', '2025-07-05 15:56:23');
INSERT INTO `herb_image` VALUES (66, 7, 68, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702295756_蚁蚀草.webp', 0, '附加图片: 蚁蚀草.webp', '2025-07-05 15:58:17');
INSERT INTO `herb_image` VALUES (67, 45, 69, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702351549_蛇足山旋花.webp', 0, '附加图片: 蛇足山旋花.webp', '2025-07-05 15:59:31');
INSERT INTO `herb_image` VALUES (68, 38, 70, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702406800_西溪莎草.webp', 0, '附加图片: 西溪莎草.webp', '2025-07-05 16:00:07');
INSERT INTO `herb_image` VALUES (69, 18, 71, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702470039_西跌草.webp', 0, '附加图片: 西跌草.webp', '2025-07-05 16:01:12');
INSERT INTO `herb_image` VALUES (70, 9, 72, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702508351_野罂粟金粉蕨.webp', 0, '附加图片: 野罂粟金粉蕨.webp', '2025-07-05 16:01:48');
INSERT INTO `herb_image` VALUES (71, 13, 73, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702542907_野鸦椿.webp', 0, '附加图片: 野鸦椿.webp', '2025-07-05 16:02:23');
INSERT INTO `herb_image` VALUES (72, 46, 74, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702581987_金豆.webp', 0, '附加图片: 金豆.webp', '2025-07-05 16:03:02');
INSERT INTO `herb_image` VALUES (73, 27, 75, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702631172_针茅菊.webp', 0, '附加图片: 针茅菊.webp', '2025-07-05 16:03:52');
INSERT INTO `herb_image` VALUES (74, 50, 76, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702670403_钩叶地黄.webp', 0, '附加图片: 钩叶地黄.webp', '2025-07-05 16:04:31');
INSERT INTO `herb_image` VALUES (75, 17, 77, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702734289_长葛蓬莱菜.webp', 0, '附加图片: 长葛蓬莱菜.webp', '2025-07-05 16:05:35');
INSERT INTO `herb_image` VALUES (76, 35, 78, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702797560_长葶万年竹.jpg', 0, '附加图片: 长葶万年竹.jpg', '2025-07-05 16:06:39');
INSERT INTO `herb_image` VALUES (77, 56, 79, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702852436_长葶万年竹(变种).webp', 0, '附加图片: 长葶万年竹(变种).webp', '2025-07-05 16:07:33');
INSERT INTO `herb_image` VALUES (78, 41, 80, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702902345_陕甘花楸.webp', 0, '附加图片: 陕甘花楸.webp', '2025-07-05 16:08:22');
INSERT INTO `herb_image` VALUES (79, 15, 81, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751702979118_马甲子.webp', 0, '附加图片: 马甲子.webp', '2025-07-05 16:09:41');
INSERT INTO `herb_image` VALUES (80, 30, 82, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751703022705_鬼针草.webp', 0, '附加图片: 鬼针草.webp', '2025-07-05 16:10:23');
INSERT INTO `herb_image` VALUES (81, 22, 83, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751703086438_鸡矢藤.webp', 0, '附加图片: 鸡矢藤.webp', '2025-07-05 16:11:29');
INSERT INTO `herb_image` VALUES (82, 37, 84, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751703622033_大拟莎草.webp', 0, '附加图片: 大拟莎草.webp', '2025-07-05 16:20:24');
INSERT INTO `herb_image` VALUES (83, 34, 85, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751703672924_天冬.webp', 0, '附加图片: 天冬.webp', '2025-07-05 16:21:13');

-- ----------------------------
-- Table structure for herb_location
-- ----------------------------
DROP TABLE IF EXISTS `herb_location`;
CREATE TABLE `herb_location`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID, 代表一次唯一的观测记录',
  `herb_id` bigint NOT NULL COMMENT '外键：关联的药材ID',
  `longitude` decimal(10, 7) NOT NULL COMMENT '经度 (e.g., 116.404269)',
  `latitude` decimal(10, 7) NOT NULL COMMENT '纬度 (e.g., 39.913169)',
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址/地名',
  `observation_year` int NOT NULL COMMENT '观测/采集年份',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_herb_id`(`herb_id` ASC) USING BTREE,
  INDEX `idx_province_city`(`province` ASC, `city` ASC) USING BTREE,
  CONSTRAINT `fk_location_herb_id` FOREIGN KEY (`herb_id`) REFERENCES `herb` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 86 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材地理分布(观测点)表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_location
-- ----------------------------
INSERT INTO `herb_location` VALUES (28, 31, 105.4418660, 28.8709800, '四川省', '泸州市', '4栋3单元1101', 2025, '2025-07-04 20:49:17');
INSERT INTO `herb_location` VALUES (29, 36, 117.1629560, 39.1106730, '天津市', '天津市', '天津大学', 2025, '2025-07-04 20:57:12');
INSERT INTO `herb_location` VALUES (30, 14, 115.9535600, 29.6611600, '江西省', '九江市', '九江', 2025, '2025-07-04 20:58:35');
INSERT INTO `herb_location` VALUES (31, 12, 122.9941830, 41.1082390, '辽宁省', '鞍山市', '鞍山', 2025, '2025-07-04 21:21:04');
INSERT INTO `herb_location` VALUES (32, 53, 117.2015090, 39.0853180, '天津市', '天津市', '天津市', 2025, '2025-07-04 21:22:16');
INSERT INTO `herb_location` VALUES (33, 10, 113.1173940, 36.1951420, '山西省', '长治市', '长野市', 2025, '2025-07-04 21:23:48');
INSERT INTO `herb_location` VALUES (34, 52, 115.9334900, 28.5579210, '江西省', '南昌市', '南昌', 2025, '2025-07-04 21:25:22');
INSERT INTO `herb_location` VALUES (35, 39, 103.7962880, 25.4908660, '云南省', '曲靖市', '曲靖', 2025, '2025-07-04 21:27:14');
INSERT INTO `herb_location` VALUES (36, 5, 114.5149760, 38.0420070, '河北省', '石家庄市', '石家庄', 2025, '2025-07-04 21:27:49');
INSERT INTO `herb_location` VALUES (37, 28, 118.6757240, 24.8744520, '福建省', '泉州市', '泉州', 2025, '2025-07-04 21:28:09');
INSERT INTO `herb_location` VALUES (38, 29, 107.0319220, 27.7219310, '贵州省', '遵义市', '遵义', 2025, '2025-07-04 21:28:27');
INSERT INTO `herb_location` VALUES (39, 1, 103.8583086, 30.7836424, '四川省', '', '四川省成都市郫都区德源街道大禹东路', 2025, '2025-07-04 21:32:19');
INSERT INTO `herb_location` VALUES (40, 33, 115.9334900, 28.5579210, '江西省', '南昌市', '南昌', 2025, '2025-07-05 15:30:42');
INSERT INTO `herb_location` VALUES (41, 4, 114.0219880, 33.0140380, '河南省', '驻马店市', '驻马市', 2025, '2025-07-05 15:31:37');
INSERT INTO `herb_location` VALUES (42, 16, 109.9531500, 40.6213270, '内蒙古自治区', '包头市', '包头市', 2025, '2025-07-05 15:32:15');
INSERT INTO `herb_location` VALUES (43, 20, 87.6168240, 43.8253770, '新疆维吾尔自治区', '乌鲁木齐市', '乌鲁木齐市', 2025, '2025-07-05 15:33:11');
INSERT INTO `herb_location` VALUES (44, 21, 105.1967700, 37.5001850, '宁夏回族自治区', '中卫市', '中卫市', 2025, '2025-07-05 15:33:48');
INSERT INTO `herb_location` VALUES (45, 3, 125.1040780, 46.5894980, '黑龙江省', '大庆市', '大庆市', 2025, '2025-07-05 15:34:28');
INSERT INTO `herb_location` VALUES (46, 55, 113.1289220, 29.3564800, '湖南省', '岳阳市', '岳阳市', 2025, '2025-07-05 15:35:06');
INSERT INTO `herb_location` VALUES (47, 11, 125.9397210, 41.7283120, '吉林省', '通化市', '通化市', 2025, '2025-07-05 15:35:47');
INSERT INTO `herb_location` VALUES (48, 42, 117.0186030, 32.5853840, '安徽省', '淮南市', '淮南市', 2025, '2025-07-05 15:36:37');
INSERT INTO `herb_location` VALUES (49, 49, 120.0868810, 30.8941780, '浙江省', '湖州市', '湖州市', 2025, '2025-07-05 15:37:09');
INSERT INTO `herb_location` VALUES (50, 47, 107.2376820, 34.3628620, '陕西省', '宝鸡市', '宝鸡市', 2025, '2025-07-05 15:38:00');
INSERT INTO `herb_location` VALUES (51, 2, 119.5268500, 35.4169120, '山东省', '日照市', '日照市', 2025, '2025-07-05 15:38:42');
INSERT INTO `herb_location` VALUES (52, 44, 122.2433090, 43.6535660, '内蒙古自治区', '通辽市', '通辽市', 2025, '2025-07-05 15:39:21');
INSERT INTO `herb_location` VALUES (53, 43, 119.2964110, 26.0742860, '福建省', '福州市', '福州市', 2025, '2025-07-05 15:40:07');
INSERT INTO `herb_location` VALUES (54, 51, 119.2964110, 26.0742860, '福建省', '福州市', '福州市', 2025, '2025-07-05 15:40:51');
INSERT INTO `herb_location` VALUES (55, 8, 105.8440040, 32.4357740, '四川省', '广元市', '广元市', 2025, '2025-07-05 15:41:39');
INSERT INTO `herb_location` VALUES (56, 58, 121.4207900, 28.6557160, '浙江省', '台州市', '台州市', 2025, '2025-07-05 15:42:25');
INSERT INTO `herb_location` VALUES (57, 26, 119.9228830, 32.4566920, '江苏省', '泰州市', '泰州市', 2025, '2025-07-05 15:43:24');
INSERT INTO `herb_location` VALUES (58, 32, 108.9396450, 34.3432070, '陕西省', '西安市', '西安市', 2025, '2025-07-05 15:47:33');
INSERT INTO `herb_location` VALUES (59, 54, 113.3667490, 40.0971100, '山西省', '大同市', '大同市', 2025, '2025-07-05 15:48:53');
INSERT INTO `herb_location` VALUES (60, 40, 106.5504830, 29.5637070, '重庆市', '重庆市', '重庆市', 2025, '2025-07-05 15:49:54');
INSERT INTO `herb_location` VALUES (61, 24, 114.4168260, 27.8162450, '江西省', '宜春市', '宜春市', 2025, '2025-07-05 15:50:40');
INSERT INTO `herb_location` VALUES (62, 19, 116.5197290, 31.7358920, '安徽省', '六安市', '六安市', 2025, '2025-07-05 15:51:33');
INSERT INTO `herb_location` VALUES (63, 6, 122.8381020, 45.6201310, '吉林省', '白城市', '白城市', 2025, '2025-07-05 15:52:49');
INSERT INTO `herb_location` VALUES (64, 25, 111.2869620, 30.6921700, '湖北省', '宜昌市', '宜昌市', 2025, '2025-07-05 15:53:28');
INSERT INTO `herb_location` VALUES (65, 48, 113.1327830, 27.8288620, '湖南省', '株洲市', '株洲市', 2025, '2025-07-05 15:54:41');
INSERT INTO `herb_location` VALUES (66, 23, 111.1445400, 37.5189960, '山西省', '吕梁市', '吕梁市', 2025, '2025-07-05 15:55:38');
INSERT INTO `herb_location` VALUES (67, 57, 121.6245400, 29.8602580, '浙江省', '宁波市', '宁波市', 2025, '2025-07-05 15:56:23');
INSERT INTO `herb_location` VALUES (68, 7, 112.4538950, 34.6197020, '河南省', '洛阳市', '洛阳市', 2025, '2025-07-05 15:58:16');
INSERT INTO `herb_location` VALUES (69, 45, 113.5973240, 24.8109770, '广东省', '韶关市', '韶关市', 2025, '2025-07-05 15:59:12');
INSERT INTO `herb_location` VALUES (70, 38, 125.1040780, 46.5894980, '黑龙江省', '大庆市', '大庆市', 2025, '2025-07-05 16:00:07');
INSERT INTO `herb_location` VALUES (71, 18, 116.7983620, 33.9562640, '安徽省', '淮北市', '淮北市', 2025, '2025-07-05 16:01:10');
INSERT INTO `herb_location` VALUES (72, 9, 121.5090620, 25.0443320, '台湾省', '台北市', '台北市', 2025, '2025-07-05 16:01:48');
INSERT INTO `herb_location` VALUES (73, 13, 120.5852940, 31.2997580, '江苏省', '苏州市', '苏州市', 2025, '2025-07-05 16:02:23');
INSERT INTO `herb_location` VALUES (74, 46, 109.1202480, 21.4813050, '广西壮族自治区', '北海市', '北海市', 2025, '2025-07-05 16:03:02');
INSERT INTO `herb_location` VALUES (75, 27, 110.1984180, 20.0458050, '海南省', '海口市', '海口市', 2025, '2025-07-05 16:03:51');
INSERT INTO `herb_location` VALUES (76, 50, 105.7248280, 34.5815140, '甘肃省', '天水市', '天水市', 2025, '2025-07-05 16:04:30');
INSERT INTO `herb_location` VALUES (77, 17, 112.9211845, 28.1755600, '湖南省', '', '湖南省长沙市岳麓区岳麓街道桃花岭村石岭坳小区', 2025, '2025-07-05 16:05:34');
INSERT INTO `herb_location` VALUES (78, 35, 115.6689870, 37.7393670, '河北省', '衡水市', '衡水市', 2025, '2025-07-05 16:06:37');
INSERT INTO `herb_location` VALUES (79, 56, 100.2259360, 26.8551650, '云南省', '丽江市', '丽江市', 2025, '2025-07-05 16:07:32');
INSERT INTO `herb_location` VALUES (80, 41, 107.0231900, 33.0663730, '陕西省', '汉中市', '汉中市', 2025, '2025-07-05 16:08:22');
INSERT INTO `herb_location` VALUES (81, 15, 115.9535600, 29.6611600, '江西省', '九江市', '九江市', 2025, '2025-07-05 16:09:39');
INSERT INTO `herb_location` VALUES (82, 30, 101.7777950, 36.6166210, '青海省', '西宁市', '西宁市', 2025, '2025-07-05 16:10:23');
INSERT INTO `herb_location` VALUES (83, 22, 110.1797520, 25.2356150, '广西壮族自治区', '桂林市', '桂林市', 2025, '2025-07-05 16:11:26');
INSERT INTO `herb_location` VALUES (84, 37, 111.9944680, 27.6998380, '湖南省', '娄底市', '娄底市', 2025, '2025-07-05 16:20:22');
INSERT INTO `herb_location` VALUES (85, 34, 121.6147860, 38.9139620, '辽宁省', '大连市', '大连市', 2025, '2025-07-05 16:21:13');

-- ----------------------------
-- Table structure for indicator_score
-- ----------------------------
DROP TABLE IF EXISTS `indicator_score`;
CREATE TABLE `indicator_score`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `evaluation_id` bigint NOT NULL COMMENT '评价记录ID',
  `indicator_id` int NOT NULL COMMENT '指标ID',
  `original_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始数值',
  `score` decimal(6, 2) NULL DEFAULT 0.00 COMMENT '得分',
  `evidence_files` json NULL COMMENT '佐证材料',
  `evaluator_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价说明',
  `auto_calculated` tinyint NULL DEFAULT 0 COMMENT '是否自动计算',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_evaluation_indicator`(`evaluation_id` ASC, `indicator_id` ASC) USING BTREE,
  INDEX `indicator_id`(`indicator_id` ASC) USING BTREE,
  CONSTRAINT `indicator_score_ibfk_1` FOREIGN KEY (`evaluation_id`) REFERENCES `user_evaluation` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `indicator_score_ibfk_2` FOREIGN KEY (`indicator_id`) REFERENCES `evaluation_indicator` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '指标得分详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of indicator_score
-- ----------------------------
INSERT INTO `indicator_score` VALUES (1, 1, 1, '320', 95.00, NULL, '完成年度教学工作量要求，超额完成', 1, '2025-07-06 11:02:16');
INSERT INTO `indicator_score` VALUES (2, 1, 4, '8', 90.00, NULL, '发表SCI论文3篇，核心期刊论文5篇', 1, '2025-07-06 11:02:16');
INSERT INTO `indicator_score` VALUES (3, 1, 5, '2', 85.00, NULL, '主持国家自然科学基金1项，参与省部级项目1项', 1, '2025-07-06 11:02:16');
INSERT INTO `indicator_score` VALUES (4, 2, 1, '280', 87.50, NULL, '完成基本教学工作量', 1, '2025-07-06 11:02:16');
INSERT INTO `indicator_score` VALUES (5, 2, 2, '4.6', 92.00, NULL, '学生评教分数较高', 1, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_base`;
CREATE TABLE `knowledge_base`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容',
  `content_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容类型',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `source_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源URL',
  `embedding_vector` json NULL COMMENT '向量表示',
  `view_count` int NULL DEFAULT 0 COMMENT '查看次数',
  `relevance_score` decimal(5, 3) NULL DEFAULT 0.000 COMMENT '相关性得分',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_created_by`(`created_by` ASC) USING BTREE,
  FULLTEXT INDEX `ft_content`(`title`, `content`, `tags`)
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库条目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_base
-- ----------------------------
INSERT INTO `knowledge_base` VALUES (1, '血府逐瘀汤临床应用指南', '血府逐瘀汤是治疗血瘀证的代表方剂，临床应用广泛。现代研究表明，该方具有改善微循环、抗血小板聚集、调节血脂等作用...', 'clinical_guide', '方剂学', '血府逐瘀汤,血瘀证,临床应用', NULL, NULL, 156, 0.000, 101, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `knowledge_base` VALUES (2, '川芎的药理作用研究进展', '川芎是常用的活血化瘀药，现代药理研究发现其主要活性成分包括川芎嗪、阿魏酸等，具有扩血管、抗血栓、神经保护等作用...', 'research_review', '中药学', '川芎,药理作用,活血化瘀', NULL, NULL, 89, 0.000, 108, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `knowledge_base` VALUES (3, '中医四诊客观化研究现状', '中医四诊的客观化是中医现代化的重要方向。目前在望诊、闻诊、问诊、切诊各方面都有相关技术突破，如舌象仪、脉象仪等设备的应用...', 'technology_review', '中医诊断学', '四诊,客观化,现代化', NULL, NULL, 234, 0.000, 109, '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for literature
-- ----------------------------
DROP TABLE IF EXISTS `literature`;
CREATE TABLE `literature`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文献标题',
  `authors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '作者',
  `publication` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '期刊名称',
  `publish_year` int NULL DEFAULT NULL COMMENT '发表年份',
  `doi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'DOI',
  `abstract` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '摘要',
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关键词',
  `research_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '研究领域',
  `impact_factor` decimal(6, 3) NULL DEFAULT NULL COMMENT '影响因子',
  `citation_count` int NULL DEFAULT 0 COMMENT '引用次数',
  `pdf_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'PDF地址',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_title`(`title`(100) ASC) USING BTREE,
  INDEX `idx_year`(`publish_year` ASC) USING BTREE,
  INDEX `idx_field`(`research_field` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文献资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of literature
-- ----------------------------
INSERT INTO `literature` VALUES (1, 'Traditional Chinese Medicine in the treatment of COVID-19: a systematic review', 'Zhang Y, Li M, Wang H', 'Nature Medicine', 2023, NULL, 'This systematic review evaluates the efficacy of Traditional Chinese Medicine...', 'TCM, COVID-19, systematic review, herbal medicine', '中医药临床研究', 87.241, 0, NULL, 'PubMed', '2025-07-06 11:02:16');
INSERT INTO `literature` VALUES (2, 'Artificial intelligence applications in Traditional Chinese Medicine diagnosis', 'Chen L, Wu X, Liu J', 'Computers in Biology and Medicine', 2024, NULL, 'Recent advances in AI technology have opened new possibilities for TCM diagnosis...', 'AI, TCM diagnosis, machine learning, digital health', '中医信息学', 7.700, 0, NULL, 'ScienceDirect', '2025-07-06 11:02:16');
INSERT INTO `literature` VALUES (3, '中药网络药理学研究方法与应用进展', '李明,王华,陈静', '中国中药杂志', 2024, NULL, '网络药理学为中药复方作用机制研究提供了新的思路和方法...', '网络药理学,中药,作用机制,系统生物学', '中药药理学', 2.890, 0, NULL, 'CNKI', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作用户ID',
  `operation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作名称',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模块名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求方法',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户代理',
  `execution_time` int NULL DEFAULT NULL COMMENT '执行时间(毫秒)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作状态',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 101, '创建方剂', 'formula', 'POST', '/api/formula', NULL, '192.168.1.100', NULL, 250, 'success', NULL, '2025-07-06 11:02:16');
INSERT INTO `operation_log` VALUES (2, 108, '上传课程视频', 'course', 'POST', '/api/course/video/upload', NULL, '192.168.1.101', NULL, 1500, 'success', NULL, '2025-07-06 11:02:16');
INSERT INTO `operation_log` VALUES (3, 109, 'AI对话查询', 'ai_assistant', 'POST', '/api/ai/chat', NULL, '192.168.1.102', NULL, 800, 'success', NULL, '2025-07-06 11:02:16');
INSERT INTO `operation_log` VALUES (4, 1, '用户评价审核', 'evaluation', 'PUT', '/api/evaluation/review', NULL, '192.168.1.200', NULL, 120, 'success', NULL, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for performance_data
-- ----------------------------
DROP TABLE IF EXISTS `performance_data`;
CREATE TABLE `performance_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `data_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据类型',
  `data_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据键',
  `data_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '数据值',
  `data_date` date NULL DEFAULT NULL COMMENT '数据日期',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据来源',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'valid' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_type`(`user_id` ASC, `data_type` ASC) USING BTREE,
  INDEX `idx_user_date`(`user_id` ASC, `data_date` ASC) USING BTREE,
  CONSTRAINT `performance_data_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '业绩数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of performance_data
-- ----------------------------
INSERT INTO `performance_data` VALUES (1, 101, 'TEACHING', 'course_hours', '320', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');
INSERT INTO `performance_data` VALUES (2, 101, 'RESEARCH', 'paper_count', '8', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');
INSERT INTO `performance_data` VALUES (3, 101, 'RESEARCH', 'funding_amount', '580000', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');
INSERT INTO `performance_data` VALUES (4, 108, 'TEACHING', 'course_hours', '280', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');
INSERT INTO `performance_data` VALUES (5, 108, 'TEACHING', 'student_rating', '4.6', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');
INSERT INTO `performance_data` VALUES (6, 109, 'INNOVATION', 'patent_count', '2', '2024-12-31', 'system', 'valid', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for project_member
-- ----------------------------
DROP TABLE IF EXISTS `project_member`;
CREATE TABLE `project_member`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色',
  `contribution_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '贡献度百分比',
  `join_date` date NULL DEFAULT NULL COMMENT '加入日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_user`(`project_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `project_member_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `research_project` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `project_member_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目参与人员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project_member
-- ----------------------------
INSERT INTO `project_member` VALUES (1, 1, 101, 'PI', 40.00, '2024-01-01', 'active', '2025-07-06 11:02:16');
INSERT INTO `project_member` VALUES (2, 1, 108, 'Co-PI', 25.00, '2024-01-01', 'active', '2025-07-06 11:02:16');
INSERT INTO `project_member` VALUES (3, 1, 109, 'researcher', 20.00, '2024-01-15', 'active', '2025-07-06 11:02:16');
INSERT INTO `project_member` VALUES (4, 2, 108, 'PI', 50.00, '2023-07-01', 'active', '2025-07-06 11:02:16');
INSERT INTO `project_member` VALUES (5, 2, 110, 'researcher', 30.00, '2023-07-01', 'active', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for research_achievement
-- ----------------------------
DROP TABLE IF EXISTS `research_achievement`;
CREATE TABLE `research_achievement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NULL DEFAULT NULL COMMENT '关联项目ID',
  `achievement_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '成果类型',
  `title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '成果标题',
  `authors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '作者',
  `first_author_id` bigint NULL DEFAULT NULL COMMENT '第一作者ID',
  `publication` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发表期刊/出版社',
  `publish_date` date NULL DEFAULT NULL COMMENT '发表日期',
  `impact_factor` decimal(6, 3) NULL DEFAULT NULL COMMENT '影响因子',
  `citation_count` int NULL DEFAULT 0 COMMENT '引用次数',
  `doi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'DOI',
  `abstract` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '摘要',
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关键词',
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件地址',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'published' COMMENT '状态',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `first_author_id`(`first_author_id` ASC) USING BTREE,
  INDEX `idx_project`(`project_id` ASC) USING BTREE,
  INDEX `idx_type`(`achievement_type` ASC) USING BTREE,
  CONSTRAINT `research_achievement_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `research_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `research_achievement_ibfk_2` FOREIGN KEY (`first_author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '科研成果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of research_achievement
-- ----------------------------
INSERT INTO `research_achievement` VALUES (1, 1, 'paper', 'Network pharmacology-based investigation of Xuefu Zhuyu Decoction in treating coronary heart disease', '王老师,Lin,luyue', 101, 'Journal of Ethnopharmacology', '2024-06-15', 4.360, 12, '10.1016/j.jep.2024.117892', NULL, NULL, NULL, 'published', NULL, '2025-07-06 11:02:16');
INSERT INTO `research_achievement` VALUES (2, 2, 'paper', 'Wild medicinal plant resources survey in Chongqing region: current status and conservation strategies', 'Lin,王银波,Huqi', 108, 'Chinese Medicine', '2024-03-22', 3.850, 8, '10.1186/s13020-024-00895-x', NULL, NULL, NULL, 'published', NULL, '2025-07-06 11:02:16');
INSERT INTO `research_achievement` VALUES (3, 3, 'patent', '基于深度学习的中医舌象自动识别方法', 'luyue,Lin,王老师', 109, '国家知识产权局', '2024-05-10', NULL, 0, 'CN202410567891.2', NULL, NULL, NULL, 'published', NULL, '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for research_project
-- ----------------------------
DROP TABLE IF EXISTS `research_project`;
CREATE TABLE `research_project`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `project_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目编号',
  `project_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目类型',
  `funding_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资助来源',
  `funding_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '资助金额',
  `principal_investigator` bigint NULL DEFAULT NULL COMMENT '项目负责人ID',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '状态',
  `abstract` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目摘要',
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关键词',
  `research_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '研究领域',
  `achievements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目成果',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pi`(`principal_investigator` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `research_project_ibfk_1` FOREIGN KEY (`principal_investigator`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '科研项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of research_project
-- ----------------------------
INSERT INTO `research_project` VALUES (1, '基于网络药理学的血府逐瘀汤治疗冠心病机制研究', 'NSF2024-TCM-001', '国家自然科学基金', '国家自然科学基金委', 580000.00, 101, '2024-01-01', '2027-12-31', 'active', '运用网络药理学方法研究血府逐瘀汤治疗冠心病的分子机制', NULL, '中医药网络药理学', NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `research_project` VALUES (2, '重庆地区野生中药资源调查与保护研究', 'CSTC2023-HERB-002', '重庆市科技计划', '重庆市科技局', 350000.00, 108, '2023-07-01', '2026-06-30', 'active', '系统调查重庆地区野生中药资源分布现状，建立保护策略', NULL, '中药资源学', NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `research_project` VALUES (3, '人工智能在中医辨证论治中的应用研究', 'AI-TCM-2024-003', '企业合作', '华为技术有限公司', 800000.00, 109, '2024-03-01', '2025-02-28', 'active', '开发基于深度学习的中医智能辨证系统', NULL, '中医信息学', NULL, '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for study_record
-- ----------------------------
DROP TABLE IF EXISTS `study_record`;
CREATE TABLE `study_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `lesson_id` bigint NOT NULL COMMENT '课时ID',
  `progress` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '学习进度百分比',
  `study_duration` int NULL DEFAULT 0 COMMENT '学习时长(秒)',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `last_position` int NULL DEFAULT 0 COMMENT '最后观看位置(秒)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_lesson`(`user_id` ASC, `lesson_id` ASC) USING BTREE,
  INDEX `course_id`(`course_id` ASC) USING BTREE,
  INDEX `lesson_id`(`lesson_id` ASC) USING BTREE,
  INDEX `idx_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE,
  CONSTRAINT `study_record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `study_record_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `study_record_ibfk_3` FOREIGN KEY (`lesson_id`) REFERENCES `course_lesson` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学习记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of study_record
-- ----------------------------
INSERT INTO `study_record` VALUES (1, 108, 1, 1, 100.00, 1800, NULL, 1800, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `study_record` VALUES (2, 108, 1, 2, 65.50, 1200, NULL, 1375, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `study_record` VALUES (3, 109, 2, 3, 88.20, 1456, NULL, 1456, '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `study_record` VALUES (4, 110, 1, 1, 45.30, 815, NULL, 815, '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置值',
  `config_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'string' COMMENT '配置类型',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置描述',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置分组',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES (1, 'system.name', '生物医药数字信息系统', 'string', '系统名称', 'basic', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');
INSERT INTO `system_config` VALUES (2, 'system.version', '2.0.0', 'string', '系统版本', 'basic', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');
INSERT INTO `system_config` VALUES (3, 'ai.model.provider', 'openai', 'string', 'AI模型提供商', 'ai', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');
INSERT INTO `system_config` VALUES (4, 'ai.model.name', 'gpt-3.5-turbo', 'string', 'AI模型名称', 'ai', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');
INSERT INTO `system_config` VALUES (5, 'evaluation.auto.calculate', 'true', 'boolean', '是否开启自动评价', 'evaluation', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');
INSERT INTO `system_config` VALUES (6, 'file.upload.max.size', '100', 'number', '文件上传最大大小(MB)', 'upload', 0, '2025-07-06 10:51:30', '2025-07-06 10:51:30');

-- ----------------------------
-- Table structure for user_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `user_evaluation`;
CREATE TABLE `user_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '被评价用户ID',
  `period_id` int NOT NULL COMMENT '评价周期ID',
  `evaluator_id` bigint NULL DEFAULT NULL COMMENT '评价人ID',
  `total_score` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '总分',
  `weighted_score` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '加权总分',
  `ranking` int NULL DEFAULT NULL COMMENT '排名',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '等级',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态',
  `submit_time` timestamp NULL DEFAULT NULL COMMENT '提交时间',
  `comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价意见',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_period`(`user_id` ASC, `period_id` ASC) USING BTREE,
  INDEX `period_id`(`period_id` ASC) USING BTREE,
  CONSTRAINT `user_evaluation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_evaluation_ibfk_2` FOREIGN KEY (`period_id`) REFERENCES `evaluation_period` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户评价记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_evaluation
-- ----------------------------
INSERT INTO `user_evaluation` VALUES (1, 101, 1, 1, 92.50, 89.30, 2, '优秀', 'approved', NULL, '教学认真负责，科研成果突出，在方剂学研究方面贡献显著', '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `user_evaluation` VALUES (2, 108, 1, 1, 88.20, 85.60, 5, '良好', 'approved', NULL, '年轻教师，教学热情高，科研潜力大，在中药资源调查方面表现突出', '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `user_evaluation` VALUES (3, 109, 1, 1, 91.80, 88.90, 3, '优秀', 'submitted', NULL, '在AI与中医结合方面有创新性研究，技术能力强', '2025-07-06 11:02:16', '2025-07-06 11:02:16');
INSERT INTO `user_evaluation` VALUES (4, 110, 2, 1, 85.60, 82.40, 8, '良好', 'approved', NULL, '教学基本功扎实，学生评价较好', '2025-07-06 11:02:16', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for user_profiles
-- ----------------------------
DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles`  (
  `user_id` bigint NOT NULL COMMENT '用户ID, 外键关联users.id',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `gender` enum('male','female','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'unknown' COMMENT '性别',
  `bio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个人简介',
  PRIMARY KEY (`user_id`) USING BTREE,
  CONSTRAINT `fk_profile_user_id_simple` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_profiles
-- ----------------------------
INSERT INTO `user_profiles` VALUES (1, '系统管理员', 'https://placehold.co/100x100/FF7F7F/333?text=A', 'unknown', NULL);
INSERT INTO `user_profiles` VALUES (101, '王老师', 'https://placehold.co/100x100/A8D8B9/333?text=W', 'male', '资深中医药学教师');
INSERT INTO `user_profiles` VALUES (108, 'Lin', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751454947519_avatar_undefined.jpg', 'male', '一个正在努力的学生');
INSERT INTO `user_profiles` VALUES (109, 'luyue', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751631525462_avatar_undefined.jpg', 'unknown', NULL);
INSERT INTO `user_profiles` VALUES (110, '王银波', 'https://placehold.co/100x100/A8D8B9/333?text=W', 'unknown', '');
INSERT INTO `user_profiles` VALUES (111, '林文浩', 'https://placehold.co/100x100/A8D8B9/333?text=L', 'female', NULL);
INSERT INTO `user_profiles` VALUES (112, 'Huqi', 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751532004222_avatar_undefined.jpg', 'unknown', NULL);
INSERT INTO `user_profiles` VALUES (113, '尚思宇', NULL, 'unknown', NULL);

-- ----------------------------
-- Table structure for user_third_party_auths
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_auths`;
CREATE TABLE `user_third_party_auths`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'github',
  `provider_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `1`(`user_id` ASC) USING BTREE,
  CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_third_party_auths
-- ----------------------------
INSERT INTO `user_third_party_auths` VALUES (1, 107, 'github', '150018177');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户主键ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` tinyint(1) NOT NULL DEFAULT 1 COMMENT '角色 (0-管理员, 1-学生, 2-教师, 3-研究员)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '加盐哈希后的密码',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '账户状态 (1-正常, 2-禁用)',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表 (简化版)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', NULL, 0, '2025-06-27 14:30:15', '...hashed_password_for_admin...', 1, '2025-06-28 15:28:02');
INSERT INTO `users` VALUES (2, '李同学', NULL, 1, '2025-06-27 14:13:48', '', 1, '2025-06-28 15:28:03');
INSERT INTO `users` VALUES (101, '王老师', NULL, 2, '2025-06-27 14:28:30', '...hashed_password_for_teacher...', 1, '2025-06-28 15:28:05');
INSERT INTO `users` VALUES (108, 'Lin', NULL, 2, '2025-06-29 16:32:42', '$2a$10$Uk2Oie93pvXy9cx0clkmEO2QP/GtfK3dIYMmLAfxa9qGmQ5xksTa2', 1, '2025-07-02 20:45:09');
INSERT INTO `users` VALUES (109, 'luyue', NULL, 0, '2025-06-29 16:54:18', '$2a$10$Sm1pBRCzgd6/TPeAF04UYO/Mi3vmcGgQjhH0chUawg8tpq28F56dm', 1, '2025-07-03 18:26:13');
INSERT INTO `users` VALUES (110, '王银波', NULL, 0, '2025-06-29 22:28:36', '$2a$10$rG.OBzencti0t5XEGk6MAeGT9v1EAyQd66KXayQRD02yJ38tueM4e', 1, '2025-07-03 18:29:09');
INSERT INTO `users` VALUES (111, '林文浩', NULL, 0, '2025-06-30 16:41:21', '$2a$10$MMAzSJcZfG8npPH.0GjFvuJYh/.VeyGjcSi23HOMyZdtFrHBZHDb2', 1, '2025-07-04 20:50:13');
INSERT INTO `users` VALUES (112, 'Huqi', NULL, 0, '2025-06-30 21:39:10', '$2a$10$q.b7SXqY4qUrGbqaf.jm5eUsx.TAJOa.8g8JbG2nHeYjnonDKpoSi', 1, '2025-07-03 16:40:14');
INSERT INTO `users` VALUES (113, '尚思宇', NULL, 0, '2025-07-01 10:04:04', '$2a$10$asSsnemldrepdXvLplqo.OybaEUswYg3cJVePOrxqtliO5Za2Q1Su', 1, '2025-07-01 10:04:04');

-- ----------------------------
-- Table structure for video_comments
-- ----------------------------
DROP TABLE IF EXISTS `video_comments`;
CREATE TABLE `video_comments`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '留言主键ID',
  `video_id` bigint NOT NULL COMMENT '外键：教学视频ID',
  `user_id` bigint NOT NULL COMMENT '外键：留言用户的ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '外键：回复的父留言ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '留言时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_comment_video_id`(`video_id` ASC) USING BTREE,
  INDEX `fk_comment_user_id`(`user_id` ASC) USING BTREE,
  INDEX `fk_comment_parent_id`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `fk_comment_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `video_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_video_id` FOREIGN KEY (`video_id`) REFERENCES `edu_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '视频留言表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of video_comments
-- ----------------------------
INSERT INTO `video_comments` VALUES (1, 6, 109, '拍摄的作者大大好帅啊啊啊', NULL, '2025-07-02 13:37:52');
INSERT INTO `video_comments` VALUES (2, 5, 109, '你谁啊', NULL, '2025-07-02 13:41:34');
INSERT INTO `video_comments` VALUES (3, 5, 109, '我是你吖', NULL, '2025-07-02 13:50:13');
INSERT INTO `video_comments` VALUES (4, 4, 109, '就是本人', NULL, '2025-07-02 13:57:03');
INSERT INTO `video_comments` VALUES (5, 6, 109, '1111', NULL, '2025-07-02 14:13:34');
INSERT INTO `video_comments` VALUES (6, 6, 109, '222222', NULL, '2025-07-02 14:13:37');
INSERT INTO `video_comments` VALUES (7, 6, 109, '阿萨撒啊', NULL, '2025-07-02 14:13:41');
INSERT INTO `video_comments` VALUES (8, 6, 109, '你好，我是奶龙\n', NULL, '2025-07-02 14:34:09');
INSERT INTO `video_comments` VALUES (9, 6, 108, '膜拜\n', NULL, '2025-07-02 19:17:24');
INSERT INTO `video_comments` VALUES (10, 10, 112, 'hi hi i', NULL, '2025-07-03 17:34:14');
INSERT INTO `video_comments` VALUES (11, 10, 109, 'manba out', NULL, '2025-07-03 18:27:54');
INSERT INTO `video_comments` VALUES (12, 5, 109, '你好，我是乃龙', NULL, '2025-07-04 19:10:14');

-- ----------------------------
-- Table structure for video_likes
-- ----------------------------
DROP TABLE IF EXISTS `video_likes`;
CREATE TABLE `video_likes`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞主键ID',
  `video_id` bigint NOT NULL COMMENT '外键：教学视频ID',
  `user_id` bigint NOT NULL COMMENT '外键：点赞用户的ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_video_user_like`(`video_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `fk_like_video_id`(`video_id` ASC) USING BTREE,
  INDEX `fk_like_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_like_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_like_video_id` FOREIGN KEY (`video_id`) REFERENCES `edu_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '视频点赞表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of video_likes
-- ----------------------------
INSERT INTO `video_likes` VALUES (4, 6, 109, '2025-07-02 13:49:33');
INSERT INTO `video_likes` VALUES (6, 6, 108, '2025-07-02 19:17:29');
INSERT INTO `video_likes` VALUES (7, 10, 112, '2025-07-03 17:34:09');
INSERT INTO `video_likes` VALUES (8, 11, 109, '2025-07-03 18:31:09');

SET FOREIGN_KEY_CHECKS = 1;

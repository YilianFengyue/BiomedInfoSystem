/*
 Navicat Premium Data Transfer

 Source Server         : luyue
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : biomed_info_system

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 08/07/2025 17:02:26
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话记录表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程章节表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程课时表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程笔记表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '疾病信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of disease
-- ----------------------------
INSERT INTO `disease` VALUES (1, '血瘀头痛', 'G44.001', '头痛', '头痛如刺，痛有定处，舌质紫暗，脉涩', '瘀血阻络，不通则痛', NULL, '活血化瘀，通络止痛', NULL, NULL, '2025-07-06 11:02:16');
INSERT INTO `disease` VALUES (2, '脾胃气虚', 'K59.001', '脾胃病', '食少便溏，神疲乏力，面色萎黄，舌淡苔白', '脾胃虚弱，运化失职', NULL, '健脾益气，调理脾胃', NULL, NULL, '2025-07-06 11:02:16');
INSERT INTO `disease` VALUES (3, '风热感冒', 'J00.001', '外感病', '发热，头痛，咽痛，咳嗽，舌红苔薄黄', '风热之邪侵袭肺卫', NULL, '疏风清热，宣肺解表', NULL, NULL, '2025-07-06 11:02:16');
INSERT INTO `disease` VALUES (4, '湿热痞满', NULL, '胸痞', '心下痞满，按之则痛，恶心呕吐，口苦不爽', '湿热互结，阻滞中焦，气机不畅', NULL, NULL, NULL, NULL, '2025-07-07 20:13:11');
INSERT INTO `disease` VALUES (5, '三焦湿热证', NULL, '湿热证', '头痛身重，胸闷腹胀，小便不利，舌苔黄腻', '湿热弥漫三焦，气化不行', NULL, NULL, NULL, NULL, '2025-07-07 20:13:11');
INSERT INTO `disease` VALUES (6, '肾虚', NULL, '虚证', '腰膝酸软，头晕耳鸣，盗汗遗精，骨蒸潮热，手足心热，口燥咽干', '肾阴亏虚，虚火内扰', NULL, NULL, NULL, NULL, '2025-07-07 20:16:00');
INSERT INTO `disease` VALUES (7, '耳鸣', NULL, '内科杂病', '头昏眼花，两耳蝉鸣，常伴有记忆力减退', '肾精不足，髓海空虚', NULL, NULL, NULL, NULL, '2025-07-07 20:16:00');
INSERT INTO `disease` VALUES (8, '肝郁血虚证', NULL, '气血津液证', '两胁作痛，头痛目眩，口燥咽干，神疲食少，月经不调，乳房作胀', '肝失疏泄，脾虚血少', NULL, NULL, NULL, NULL, '2025-07-07 20:17:08');
INSERT INTO `disease` VALUES (9, '月经不调', NULL, '妇科病', '月经周期或出血量的异常，伴有乳房胀痛、情绪波动', '肝气郁结，冲任失调', NULL, NULL, NULL, NULL, '2025-07-07 20:17:08');
INSERT INTO `disease` VALUES (12, '虚劳', NULL, '内科杂病', '面色萎黄或苍白，神疲乏力，心悸气短，食少便溏', '脏腑功能衰退，气血阴阳亏虚所致', NULL, '补益气血，调理阴阳', NULL, NULL, '2025-07-07 20:30:45');
INSERT INTO `disease` VALUES (13, '感冒', NULL, '外感病', '发热，恶寒，头痛，鼻塞，流涕，咳嗽，咽痛', '风邪或时行病毒侵袭肺卫，致卫表不和，肺失宣肃', NULL, '疏风解表，宣肺利咽', NULL, NULL, '2025-07-07 20:31:09');
INSERT INTO `disease` VALUES (14, '伤寒', NULL, '外感六淫', '往来寒热，胸胁苦满，嘿嘿不欲饮食，心烦喜呕', '邪在半表半里，枢机不利', NULL, '和解少阳', NULL, NULL, '2025-07-07 20:34:01');
INSERT INTO `disease` VALUES (15, '太阳中风证', NULL, '外感病', '发热恶风，汗出，头痛，鼻鸣干呕，苔薄白，脉浮缓', '风寒袭表，卫强营弱', NULL, '解肌发表，调和营卫', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (16, '营血亏虚证', NULL, '血证', '心悸失眠，头晕目眩，面色无华，爪甲苍白，妇女月经量少色淡、后期或经闭，舌淡，脉细', '血液亏虚，脏腑百脉失养', NULL, '补血养血', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (17, '气阴两虚证', NULL, '虚证', '乏力，气短，自汗，口渴，咽干，舌干红少津，脉虚数', '气虚与阴津亏损同时存在', NULL, '益气养阴', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (18, '阳明热盛证', NULL, '热证', '大热，大汗，大渴，脉洪大', '邪热炽盛于阳明气分', NULL, '清热生津', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (19, '中气下陷证', NULL, '虚证', '体倦乏力，食少腹胀，便溏，肛门下坠，或久泻、脱肛，或子宫脱垂，舌淡，脉虚', '脾气虚衰，升举无力', NULL, '补中益气，升阳举陷', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (20, '心脾两虚证', NULL, '虚证', '心悸怔忡，健忘失眠，食少体倦，面色萎黄，或崩漏，便血，皮下紫癜，舌淡，苔薄白，脉细弱', '思虑过度，劳伤心脾，气血亏虚', NULL, '补益心脾，养血安神', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (21, '肝胆实火证', NULL, '火证', '头痛目赤，胁痛口苦，耳聋，耳肿；或湿热下注，症见阴肿，阴痒，筋痿，阴汗，小便淋浊，妇女带下黄臭等', '肝经郁火或湿热下注', NULL, '清泻肝胆实火，清利肝经湿热', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (22, '脘腹胀满', NULL, '脾胃病', '胃脘腹部胀满，不思饮食，嗳腐吞酸', '湿滞中焦，脾胃气机受阻；或饮食停滞', NULL, '燥湿健脾，行气和胃；或消食导滞', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (23, '食积停滞证', NULL, '脾胃病', '脘腹痞满，嗳腐吞酸，厌食，呕吐，或大便泄泻，舌苔厚腻，脉滑', '饮食不节，停滞中脘，脾运失健', NULL, '消食导滞，和胃', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (24, '风湿痹证（肝肾两亏，气血不足）', NULL, '痹证', '腰膝疼痛，关节屈伸不利，或麻木不仁，畏寒喜温，心悸气短，舌淡苔白，脉细弱', '素体肝肾气血不足，风寒湿邪乘虚侵袭', NULL, '祛风湿，止痹痛，补肝肾，益气血', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (25, '血虚经闭', NULL, '妇科病', '经期延后，量少色淡，渐至经闭，面色萎黄或苍白，头晕目眩，心悸失眠', '素体血虚，或大病、久病、失血过多，冲任血少', NULL, '补血养血，活血调经', NULL, NULL, '2025-07-08 15:25:20');
INSERT INTO `disease` VALUES (26, '阳明腑实证', NULL, '里实热证', '潮热，谵语，腹满疼痛拒按，大便秘结，或热结旁流，舌苔黄燥起刺，或焦黑，脉沉实', '燥热与肠中糟粕相结', NULL, '峻下热结', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (27, '胆胃不和、痰热内扰证', NULL, '痰证', '胆怯易惊，头眩心悸，心烦不眠，或呕吐呃逆，苔白腻或微黄，脉弦滑', '胆气虚，痰热扰心', NULL, '理气化痰，和胃利胆', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (28, '六郁证', NULL, '郁证', '胸膈痞闷，脘腹胀痛，嗳腐吞酸，恶心呕吐，饮食不化', '气、血、湿、火、痰、食相互郁结', NULL, '行气解郁，化痰消食', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (29, '寒热错杂痞证', NULL, '痞证', '心下痞，但满而不痛，或呕吐，肠鸣下利，舌苔腻而微黄', '中焦气机不畅，寒热错杂', NULL, '和胃降逆，开结除痞', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (30, '血瘀气滞胃痛', NULL, '胃痛', '胃脘疼痛，痛有定处，如针刺或刀割感，舌质紫暗或有瘀斑，脉涩', '气滞导致血行不畅，瘀血停滞胃络', NULL, '活血化瘀，行气止痛', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (31, '肾阳不足证', NULL, '虚证', '腰膝酸软冷痛，畏寒肢冷，小便不利或反多，痰饮喘咳，下利清谷，阳痿早泄，舌淡胖，苔白滑，脉沉弱', '肾阳亏虚，温煦、气化功能减退', NULL, '温补肾阳', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (32, '虚烦不得眠', NULL, '不寐', '心烦不眠，心悸盗汗，头目眩晕，咽干口燥，舌红少苔，脉细数', '肝血不足，虚热内扰', NULL, '养血安神，清热除烦', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (33, '脾虚湿盛证', NULL, '虚证', '食少便溏，或吐或泻，脘腹胀满，面色萎黄，神疲乏力，舌淡苔白腻，脉虚缓', '脾气虚弱，运化失职，湿浊内生', NULL, '益气健脾，渗湿止泻', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (34, '表虚自汗', NULL, '汗证', '时时汗出，恶风，体虚易感风邪，舌淡苔薄白，脉浮虚', '卫气不固，肌表疏松', NULL, '益气固表止汗', NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `disease` VALUES (35, '肝火犯胃证', NULL, '胃痛', '胃脘灼痛，痛势急迫，嘈杂泛酸，口干口苦，烦躁易怒，舌红苔黄，脉弦数', '肝火横逆，气机失调，直犯胃腑', NULL, '清肝泻火，降逆和胃', NULL, NULL, '2025-07-08 15:40:04');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价维度表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价指标表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评价周期表' ROW_FORMAT = DYNAMIC;

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
CREATE TABLE `formula`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方剂名称',
  `alias` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '出处典籍',
  `dynasty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '朝代',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创方人',
  `category_id` int NULL DEFAULT NULL COMMENT '分类ID',
  `composition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '药物组成',
  `preparation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '制法',
  `usage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用法',
  `dosage_form` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '剂型',
  `function_effect` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '功用',
  `main_treatment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主治',
  `clinical_application` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '临床应用',
  `pharmacological_action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '药理作用',
  `contraindication` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '禁忌',
  `caution` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '注意事项',
  `modern_research` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '现代研究',
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1-正常 0-禁用',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_source`(`source` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂基本信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula
-- ----------------------------
INSERT INTO `formula` VALUES (1, '麻黄汤', NULL, '伤寒论', '汉代', '张仲景', 1, '麻黄、桂枝、杏仁、甘草', '上四味，以水九升，先煮麻黄，减二升，去上沫，内诸药，煮取二升半，去滓，温服八合。', '温服，服后取微汗。', '汤剂', '发汗解表，宣肺平喘', '外感风寒表实证。症见恶寒发热，头身疼痛，无汗而喘，舌苔薄白，脉浮紧。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-07 19:10:33', '2025-07-07 19:10:33');
INSERT INTO `formula` VALUES (2, '四君子汤', '四君汤', '太平惠民和剂局方', '宋代', '陈师文', 2, '人参、白术、茯苓、炙甘草', '上为末，每服二钱，水一盏，煎至七分，通口服，不拘时候。', '水煎服。', '汤剂', '益气健脾', '脾胃气虚证。面色萎黄，语声低微，气短乏力，食少便溏，舌淡苔白，脉虚弱。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-07 19:10:33', '2025-07-07 19:10:33');
INSERT INTO `formula` VALUES (3, '血府逐瘀汤', NULL, '医林改错', '清代', '王清任', 3, '桃仁、红花、当归、生地黄、牛膝、川芎、桔梗、赤芍、枳壳、甘草、柴胡', '水煎服', '每日一剂，分两次温服。', '汤剂', '活血化瘀，行气止痛', '胸中血瘀证。胸痛，头痛，日久不愈，痛如针刺而有定处，或呃逆日久不止，或饮水即呛，干呕，或内热瞀闷，心悸失眠，急躁易怒，入暮潮热，唇暗或两目暗黑，舌质暗红，或舌有瘀斑、瘀点，脉涩或弦紧。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-07 19:10:33', '2025-07-07 19:10:33');
INSERT INTO `formula` VALUES (4, '银翘散', NULL, '温病条辨', '清代', '吴鞠通', 4, '金银花、连翘、苦桔梗、薄荷、竹叶、生甘草、荆芥穗、淡豆豉、牛蒡子', '上杵为散，每服六钱，鲜苇根汤煎，香气大出，即取服，勿过煎。', '苇根汤煎，温服。', '散剂/汤剂', '辛凉透表，清热解毒', '温病初起。发热，微恶风寒，无汗或有汗不畅，头痛口渴，咳嗽咽痛，舌尖红，苔薄白或薄黄，脉浮数。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-07 19:10:33', '2025-07-07 19:10:33');
INSERT INTO `formula` VALUES (5, '竹叶石膏汤', '六味竹叶石膏汤', '注解伤寒论', '金', '成无己。 年份:公元1144年。\r\n\r\n成无己', 5, '竹叶、石膏、麦门冬、人参、甘草、半夏', '以水一斗，煮取六升', '温服一升，日三服', '汤剂', '清气分热，清热生津', '伤寒、温病、暑病余热未清，气津两伤证', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-07 20:01:24', '2025-07-07 20:03:44');
INSERT INTO `formula` VALUES (6, '黄连解毒汤', NULL, '外台秘要', '唐代', '王焘', NULL, '黄连、黄芩、黄柏、栀子', NULL, '水煎服，每日一剂，分两次温服。', NULL, '泻火解毒', '三焦火毒证。大热烦躁，口燥咽干，错语不眠；或热病吐血、衄血；或身热发斑，或热甚发狂；或外科痈肿疔毒，小便黄赤，舌红苔黄，脉数有力。', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2025-07-07 20:13:24', '2025-07-07 20:13:24');
INSERT INTO `formula` VALUES (7, '六味地黄丸', NULL, '小儿药证直诀', '宋代', '钱乙', NULL, '熟地黄、山茱萸、山药、泽泻、牡丹皮、茯苓', NULL, '制成蜜丸，每次6-9克，每日2-3次，空腹温水送服。', NULL, '滋阴补肾', '肾阴虚证。腰膝酸软，头晕耳鸣，盗汗，遗精，消渴；或骨蒸潮热，手足心热，舌燥咽痛；以及小儿囟门不合，舌红少苔，脉沉细数。', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2025-07-07 20:16:03', '2025-07-07 20:16:03');
INSERT INTO `formula` VALUES (8, '逍遥散', NULL, '太平惠民和剂局方', '宋代', '官方（太医局）', NULL, '柴胡、当归、白芍、白术、茯苓、炙甘草、薄荷、生姜', NULL, '作散剂，每次6克，以烧生姜、薄荷少许，同煎汤调服，每日两次。亦可作汤剂，水煎服。', NULL, '疏肝解郁，养血健脾', '肝郁血虚证。两胁作痛，头痛目眩，口燥咽干，神疲食少，或往来寒热，或月经不调，乳房作胀，脉弦而虚者。', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2025-07-07 20:17:08', '2025-07-07 20:17:08');
INSERT INTO `formula` VALUES (11, '小柴胡汤', NULL, '伤寒论', '汉代', '张仲景', NULL, '柴胡、黄芩、人参、半夏、炙甘草、生姜、大枣', NULL, '去滓再煎，温服。', NULL, '和解少阳', '伤寒少阳证。往来寒热，胸胁苦满，嘿嘿不欲饮食，心烦喜呕，口苦，咽干，目眩。', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2025-07-07 20:34:01', '2025-07-07 20:34:01');
INSERT INTO `formula` VALUES (12, '桂枝汤', NULL, '伤寒论', '汉代', '张仲景', 1, '桂枝、芍药、生姜、大枣、甘草', NULL, '温服，服后进少量热稀粥，以助药力，温覆令一时许，遍身微似有汗者益佳。', '汤剂', '解肌发表，调和营卫', '外感风寒表虚证。症见发热头痛，汗出恶风，鼻鸣干呕，苔薄白，脉浮缓。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:25:33', '2025-07-08 15:25:33');
INSERT INTO `formula` VALUES (13, '四物汤', NULL, '太平惠民和剂局方', '宋代', '官方（太医局）', 3, '当归、川芎、白芍、熟地黄', NULL, '水煎服，每日一剂，分两次温服。', '汤剂', '补血和血，调经化瘀', '营血亏虚，或血行不畅。冲任虚损，月经不调，脐腹作痛，崩中漏下，血瘕块硬，时发疼痛；或产后气血亏损，恶露不行；或瘀血作痛。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:52', '2025-07-08 15:31:52');
INSERT INTO `formula` VALUES (14, '生脉散', NULL, '内外伤辨惑论', '金元', '李杲', 2, '人参、麦冬、五味子', NULL, '水煎服。', '散剂/汤剂', '益气生津，敛阴止汗', '温热、暑热，耗气伤阴证。汗多神疲，体倦乏力，气短懒言，咽干口渴，舌干红，脉虚数。久咳肺虚，气阴两虚证。干咳少痰，气短自汗，口干舌燥，脉虚细。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (15, '白虎汤', NULL, '伤寒论', '汉代', '张仲景', 4, '石膏、知母、甘草、粳米', NULL, '水煎，米熟汤成，去滓温服。', '汤剂', '清热生津', '阳明气分热盛证。壮热面赤，烦渴引饮，汗出恶热，脉洪大有力。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (16, '补中益气汤', NULL, '脾胃论', '金元', '李杲', 2, '黄芪、人参、白术、炙甘草、当归、陈皮、升麻、柴胡', NULL, '水煎服。', '汤剂', '补中益气，升阳举陷', '脾胃气虚，中气下陷证。食少发热，自汗，气短乏力，精神倦怠，以及脱肛、子宫脱垂等。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (17, '归脾汤', NULL, '济生方', '宋代', '严用和', 2, '白术、茯神、黄芪、龙眼肉、酸枣仁、人参、木香、炙甘草、当归、远志', NULL, '加生姜、大枣，水煎服。', '汤剂', '益气补血，健脾养心', '心脾两虚证。思虑过度，劳伤心脾，气血亏虚所致的心悸怔忡，健忘失眠，食少体倦，面色萎黄。脾不统血证。崩漏，便血，皮下紫癜等。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (18, '龙胆泻肝汤', NULL, '医方集解', '清代', '汪昂', 4, '龙胆草、黄芩、栀子、泽泻、木通、车前子、当归、生地黄、柴胡、甘草', NULL, '水煎服。', '汤剂', '清泻肝胆实火，清利肝经湿热', '肝胆实火上炎证和肝经湿热下注证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (19, '平胃散', NULL, '太平惠民和剂局方', '宋代', '官方（太医局）', NULL, '苍术、厚朴、陈皮、甘草', NULL, '上为末，每服二钱，加生姜二片，大枣二枚，水煎服。', '散剂/汤剂', '燥湿运脾，行气和胃', '湿滞脾胃证。脘腹胀满，不思饮食，口淡无味，恶心呕吐，嗳气吞酸，肢体沉重，怠惰嗜卧，常多自利，舌苔白腻而厚，脉缓。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (20, '保和丸', NULL, '丹溪心法', '元代', '朱丹溪', NULL, '山楂、神曲、莱菔子、半夏、茯苓、陈皮、连翘', NULL, '上为末，炊饼为丸，如梧桐子大，每服七八十丸，食远，用白汤下。现代可作汤剂。', '丸剂/汤剂', '消食和胃', '食积停滞证。脘腹痞满，嗳腐吞酸，不欲饮食，舌苔厚腻，脉滑。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (21, '独活寄生汤', NULL, '备急千金要方', '唐代', '孙思邈', 2, '独活、桑寄生、秦艽、防风、细辛、当归、芍药、川芎、干地黄、杜仲、牛膝、人参、茯苓、甘草', NULL, '水煎服。', '汤剂', '祛风湿，止痹痛，补肝肾，益气血', '风寒湿痹，日久不愈，肝肾两虚，气血不足。症见腰膝疼痛，痿软，肢节屈伸不利，或麻木不仁，畏寒喜温，心悸气短，舌淡苔白，脉象细弱。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:31:59', '2025-07-08 15:31:59');
INSERT INTO `formula` VALUES (22, '大承气汤', NULL, '伤寒论', '汉代', '张仲景', NULL, '大黄、厚朴、枳实、芒硝', NULL, '水煎，先煮厚朴、枳实，后下大黄，芒硝溶服。', '汤剂', '峻下热结', '阳明腑实证。痞、满、燥、实、坚，五者俱备。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (23, '温胆汤', NULL, '三因极一病证方论', '宋代', '陈言', NULL, '半夏、竹茹、枳实、陈皮、茯苓、甘草', NULL, '加生姜、大枣水煎服。', '汤剂', '理气化痰，和胃利胆', '胆胃不和，痰热内扰证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (24, '越鞠丸', NULL, '丹溪心法', '元代', '朱丹溪', NULL, '苍术、香附、川芎、神曲、栀子', NULL, '上为末，水泛为丸。', '丸剂/汤剂', '行气解郁', '六郁证（气、血、痰、火、湿、食）。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (25, '半夏泻心汤', NULL, '伤寒论', '汉代', '张仲景', NULL, '半夏、黄芩、干姜、人参、黄连、大枣、炙甘草', NULL, '水煎服。', '汤剂', '和胃降逆，开结除痞', '寒热错杂之痞证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (26, '丹参饮', NULL, '医林改错', '清代', '王清任', 3, '丹参、檀香、砂仁', NULL, '水煎服。', '汤剂', '活血祛瘀，行气止痛', '血瘀气滞所致的胸、胃、脘腹疼痛。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (27, '金匮肾气丸', NULL, '金匮要略', '汉代', '张仲景', 2, '干地黄、山药、山茱萸、泽泻、茯苓、牡丹皮、桂枝、附子', NULL, '上为末，炼蜜和丸，如梧桐子大，酒下十五丸，加至二十丸，日再服。', '丸剂', '温补肾阳', '肾阳不足证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (28, '酸枣仁汤', NULL, '金匮要略', '汉代', '张仲景', 2, '酸枣仁、甘草、知母、茯苓、川芎', NULL, '水煎，分温再服。', '汤剂', '养血安神，清热除烦', '肝血不足，虚热内扰所致的虚烦不眠。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (29, '参苓白术散', NULL, '太平惠民和剂局方', '宋代', '官方（太医局）', 2, '人参、白术、茯苓、山药、甘草、白扁豆、莲子、薏苡仁、砂仁、桔梗', NULL, '为末，每服二钱，枣汤调下。', '散剂/汤剂', '益气健脾，渗湿止泻', '脾虚湿盛证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (30, '玉屏风散', NULL, '丹溪心法附方', '元代', '朱丹溪', 2, '防风、黄芪、白术', NULL, '上为末，每服三钱，水一盏半，加大枣一枚，煎至七分，食后热服。', '散剂/汤剂', '益气固表止汗', '表虚自汗。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');
INSERT INTO `formula` VALUES (31, '左金丸', NULL, '丹溪心法', '元代', '朱丹溪', 4, '黄连、吴茱萸', NULL, '上为末，水泛为丸，白汤下五十丸。', '丸剂/汤剂', '清肝泻火，降逆止呕', '肝火犯胃证。', NULL, NULL, NULL, NULL, NULL, NULL, 1, 101, '2025-07-08 15:40:04', '2025-07-08 15:40:04');

-- ----------------------------
-- Table structure for formula_case
-- ----------------------------
DROP TABLE IF EXISTS `formula_case`;
CREATE TABLE `formula_case`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `formula_id` bigint NOT NULL COMMENT '方剂ID',
  `case_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '医案标题',
  `patient_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '患者信息',
  `chief_complaint` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主诉',
  `history_present` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '现病史',
  `physical_exam` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '体格检查',
  `tongue_pulse` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '舌脉',
  `tcm_diagnosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '中医诊断',
  `treatment_principle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '治法',
  `prescription` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '处方',
  `follow_up` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '随访记录',
  `outcome` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '疗效',
  `doctor_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '医生姓名',
  `hospital` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '医院',
  `case_date` date NULL DEFAULT NULL COMMENT '医案日期',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资料来源',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `formula_id`(`formula_id` ASC) USING BTREE,
  CONSTRAINT `formula_case_ibfk_1` FOREIGN KEY (`formula_id`) REFERENCES `formula` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂临床验案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_case
-- ----------------------------
INSERT INTO `formula_case` VALUES (1, 3, '王某某，头痛案', '患者，男，45岁', '反复性头痛五年，痛如针刺，部位固定', '患者五年前无明显诱因出现头痛，呈持续性刺痛，位于左侧巅顶，每因情绪激动或劳累后加重。曾多方求医，效果不佳。近一月疼痛加剧，伴有心烦易怒，夜寐不安。', NULL, NULL, '头痛（瘀血头痛）', '活血化瘀，行气止痛', '血府逐瘀汤原方，七剂', NULL, '服药七剂后，头痛明显减轻，睡眠改善。继续调理半月，头痛基本消失，随访半年未复发。', '李医生', NULL, '2023-05-10', NULL, '2025-07-07 19:10:33');

-- ----------------------------
-- Table structure for formula_category
-- ----------------------------
DROP TABLE IF EXISTS `formula_category`;
CREATE TABLE `formula_category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `parent_id` int NULL DEFAULT 0 COMMENT '父级分类ID',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分类描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_category
-- ----------------------------
INSERT INTO `formula_category` VALUES (1, '解表剂', 0, 0, '用于治疗表证的方剂', '2025-07-07 19:10:33');
INSERT INTO `formula_category` VALUES (2, '补益剂', 0, 0, '用于补益气血阴阳的方剂', '2025-07-07 19:10:33');
INSERT INTO `formula_category` VALUES (3, '理血剂', 0, 0, '用于理血调血的方剂', '2025-07-07 19:10:33');
INSERT INTO `formula_category` VALUES (4, '清热剂', 0, 0, '用于清热解毒的方剂', '2025-07-07 19:10:33');

-- ----------------------------
-- Table structure for formula_disease
-- ----------------------------
DROP TABLE IF EXISTS `formula_disease`;
CREATE TABLE `formula_disease`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `formula_id` bigint NOT NULL COMMENT '方剂ID',
  `disease_id` bigint NOT NULL COMMENT '疾病名称',
  `disease_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '疾病编码',
  `syndrome` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '证候',
  `efficacy_level` tinyint NULL DEFAULT NULL COMMENT '疗效等级 1-5',
  `evidence_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '循证等级',
  `clinical_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '临床数据',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_formula`(`formula_id` ASC) USING BTREE,
  INDEX `idx_disease`(`disease_id` ASC) USING BTREE,
  CONSTRAINT `formula_disease_ibfk_1` FOREIGN KEY (`formula_id`) REFERENCES `formula` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `formula_disease_ibfk_2` FOREIGN KEY (`disease_id`) REFERENCES `disease` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂主治疾病关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_disease
-- ----------------------------
INSERT INTO `formula_disease` VALUES (1, 1, 1, 'J00.001', '风寒束表，肺气不宣证', 5, NULL, NULL, '2025-07-07 19:10:33');
INSERT INTO `formula_disease` VALUES (2, 2, 2, 'K59.001', '脾胃气虚证', 5, NULL, NULL, '2025-07-07 19:10:33');
INSERT INTO `formula_disease` VALUES (3, 3, 3, 'I20.001', '气滞血瘀证', 5, NULL, NULL, '2025-07-07 19:10:33');
INSERT INTO `formula_disease` VALUES (4, 3, 1, 'G44.001', '瘀血头痛', 4, NULL, NULL, '2025-07-07 19:10:33');
INSERT INTO `formula_disease` VALUES (5, 4, 2, 'J00.002', '风热犯卫证', 5, NULL, NULL, '2025-07-07 19:10:33');
INSERT INTO `formula_disease` VALUES (6, 5, 1, 'I20.002', '气津两伤证', 5, NULL, NULL, '2025-07-07 20:06:24');
INSERT INTO `formula_disease` VALUES (7, 7, 6, NULL, '肾阴虚证', 5, NULL, NULL, '2025-07-07 20:16:10');
INSERT INTO `formula_disease` VALUES (8, 7, 7, NULL, '头晕耳鸣', 4, NULL, NULL, '2025-07-07 20:16:10');
INSERT INTO `formula_disease` VALUES (9, 8, 8, NULL, '肝郁血虚证', 5, NULL, NULL, '2025-07-07 20:17:08');
INSERT INTO `formula_disease` VALUES (10, 8, 9, NULL, '月经不调', 4, NULL, NULL, '2025-07-07 20:17:08');
INSERT INTO `formula_disease` VALUES (11, 2, 12, NULL, '脾胃气虚证', 5, NULL, NULL, '2025-07-07 20:30:45');
INSERT INTO `formula_disease` VALUES (12, 4, 13, NULL, '风热犯卫证', 5, NULL, NULL, '2025-07-07 20:31:09');
INSERT INTO `formula_disease` VALUES (13, 11, 14, NULL, '少阳病证', 5, NULL, NULL, '2025-07-07 20:34:01');
INSERT INTO `formula_disease` VALUES (14, 12, 15, NULL, '太阳中风证', NULL, NULL, NULL, '2025-07-08 15:25:33');
INSERT INTO `formula_disease` VALUES (15, 13, 16, NULL, '营血亏虚证', NULL, NULL, NULL, '2025-07-08 15:31:52');
INSERT INTO `formula_disease` VALUES (16, 13, 25, NULL, '血虚经闭', NULL, NULL, NULL, '2025-07-08 15:31:52');
INSERT INTO `formula_disease` VALUES (17, 14, 17, NULL, '气阴两虚证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (18, 15, 18, NULL, '阳明热盛证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (19, 16, 19, NULL, '中气下陷证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (20, 16, 2, NULL, '脾胃气虚证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (21, 17, 20, NULL, '心脾两虚证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (22, 18, 21, NULL, '肝胆实火证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (23, 19, 22, NULL, '脘腹胀满(湿滞脾胃)', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (24, 20, 23, NULL, '食积停滞证', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (25, 21, 24, NULL, '风湿痹证（肝肾两亏，气血不足）', NULL, NULL, NULL, '2025-07-08 15:31:59');
INSERT INTO `formula_disease` VALUES (26, 22, 26, NULL, '阳明腑实证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (27, 23, 27, NULL, '胆胃不和、痰热内扰证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (28, 24, 28, NULL, '六郁证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (29, 25, 29, NULL, '寒热错杂痞证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (30, 26, 30, NULL, '血瘀气滞胃痛', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (31, 27, 31, NULL, '肾阳不足证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (32, 28, 32, NULL, '虚烦不得眠', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (33, 29, 33, NULL, '脾虚湿盛证', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (34, 30, 34, NULL, '表虚自汗', NULL, NULL, NULL, '2025-07-08 15:40:04');
INSERT INTO `formula_disease` VALUES (35, 31, 35, NULL, '肝火犯胃证', NULL, NULL, NULL, '2025-07-08 15:40:04');

-- ----------------------------
-- Table structure for formula_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `formula_evaluation`;
CREATE TABLE `formula_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `formula_id` bigint NOT NULL COMMENT '方剂ID',
  `evaluator_id` bigint NULL DEFAULT NULL COMMENT '评价人ID',
  `evaluation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价类型(临床疗效、安全性、经济性)',
  `score` decimal(3, 1) NULL DEFAULT NULL COMMENT '评分',
  `evaluation_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `evidence_files` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '证据文件',
  `evaluation_date` date NULL DEFAULT NULL COMMENT '评价日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '状态',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `formula_id`(`formula_id` ASC) USING BTREE,
  CONSTRAINT `formula_evaluation_ibfk_1` FOREIGN KEY (`formula_id`) REFERENCES `formula` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_evaluation
-- ----------------------------
INSERT INTO `formula_evaluation` VALUES (1, 2, 108, '临床疗效', 4.8, '我母亲脾胃虚弱，食欲不振，服用四君子汤加减化裁后，食欲明显改善，精神状态也好了很多，是健脾益气良方。', NULL, NULL, 'approved', '2025-07-07 19:10:33');

-- ----------------------------
-- Table structure for formula_herb
-- ----------------------------
DROP TABLE IF EXISTS `formula_herb`;
CREATE TABLE `formula_herb`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `formula_id` bigint NOT NULL COMMENT '方剂ID',
  `herb_id` bigint NOT NULL COMMENT '药材ID',
  `herb_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '药材名称',
  `dosage` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用量',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配伍作用(君臣佐使)',
  `processing` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '炮制方法',
  `usage_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用法备注',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_formula`(`formula_id` ASC) USING BTREE,
  INDEX `idx_herb`(`herb_id` ASC) USING BTREE,
  CONSTRAINT `formula_herb_ibfk_1` FOREIGN KEY (`formula_id`) REFERENCES `formula` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂药物组成表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_herb
-- ----------------------------
INSERT INTO `formula_herb` VALUES (1, 1, 10, '麻黄', '9', 'g', '君药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (2, 1, 11, '桂枝', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (3, 1, 12, '杏仁', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (4, 1, 13, '炙甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (5, 2, 1, '人参', '9', 'g', '君药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (6, 2, 64, '白术', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (7, 2, 65, '茯苓', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (8, 2, 13, '炙甘草', '6', 'g', '使药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (9, 3, 20, '桃仁', '12', 'g', '臣药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (10, 3, 21, '红花', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (11, 3, 3, '当归', '9', 'g', '君药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (12, 3, 22, '生地黄', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (13, 3, 23, '川芎', '5', 'g', '佐药', NULL, NULL, 0, '2025-07-07 19:10:33');
INSERT INTO `formula_herb` VALUES (14, 6, 74, '黄连', '9', 'g', '君药', NULL, NULL, 0, '2025-07-07 20:13:35');
INSERT INTO `formula_herb` VALUES (15, 6, 75, '黄芩', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:13:35');
INSERT INTO `formula_herb` VALUES (16, 6, 76, '黄柏', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:13:35');
INSERT INTO `formula_herb` VALUES (17, 6, 77, '栀子', '9', 'g', '使药', NULL, NULL, 0, '2025-07-07 20:13:35');
INSERT INTO `formula_herb` VALUES (18, 7, 78, '熟地黄', '240', 'g', '君药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (19, 7, 79, '山茱萸', '120', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (20, 7, 80, '山药', '120', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (21, 7, 81, '泽泻', '90', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (22, 7, 82, '牡丹皮', '90', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (23, 7, 65, '茯苓', '90', 'g', '使药', NULL, NULL, 0, '2025-07-07 20:16:07');
INSERT INTO `formula_herb` VALUES (24, 8, 83, '柴胡', '30', 'g', '君药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (25, 8, 3, '当归', '30', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (26, 8, 84, '白芍', '30', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (27, 8, 64, '白术', '30', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (28, 8, 65, '茯苓', '30', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (29, 8, 63, '甘草', '15', 'g', '使药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (30, 8, 89, '薄荷', '少许', '', '引经药', NULL, NULL, 0, '2025-07-07 20:17:08');
INSERT INTO `formula_herb` VALUES (31, 11, 83, '柴胡', '12', 'g', '君药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (32, 11, 75, '黄芩', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (33, 11, 85, '半夏', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (34, 11, 92, '生姜', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (35, 11, 1, '人参', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (36, 11, 93, '大枣', '12', '枚', '使药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (37, 11, 63, '甘草', '5', 'g', '使药', NULL, NULL, 0, '2025-07-07 20:34:01');
INSERT INTO `formula_herb` VALUES (38, 12, 61, '桂枝', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:25:33');
INSERT INTO `formula_herb` VALUES (39, 12, 84, '白芍', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:25:33');
INSERT INTO `formula_herb` VALUES (40, 12, 92, '生姜', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:25:33');
INSERT INTO `formula_herb` VALUES (41, 12, 93, '大枣', '12', '枚', '佐药', NULL, NULL, 0, '2025-07-08 15:25:33');
INSERT INTO `formula_herb` VALUES (42, 12, 63, '甘草', '6', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:25:33');
INSERT INTO `formula_herb` VALUES (43, 13, 78, '熟地黄', '12', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:52');
INSERT INTO `formula_herb` VALUES (44, 13, 3, '当归', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:52');
INSERT INTO `formula_herb` VALUES (45, 13, 84, '白芍', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:52');
INSERT INTO `formula_herb` VALUES (46, 13, 23, '川芎', '6', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:52');
INSERT INTO `formula_herb` VALUES (47, 14, 1, '人参', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (48, 14, 96, '麦冬', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (49, 14, 97, '五味子', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (50, 15, 122, '石膏', '30', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (51, 15, 98, '知母', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (52, 15, 63, '甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (53, 15, 99, '粳米', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (54, 16, 100, '黄芪', '15', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (55, 16, 1, '人参', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (56, 16, 64, '白术', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (57, 16, 13, '炙甘草', '5', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (58, 16, 3, '当归', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (59, 16, 101, '陈皮', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (60, 16, 102, '升麻', '3', 'g', '引经药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (61, 16, 83, '柴胡', '3', 'g', '引经药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (62, 17, 64, '白术', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (63, 17, 1, '人参', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (64, 17, 100, '黄芪', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (65, 17, 3, '当归', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (66, 17, 65, '茯苓', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (67, 17, 105, '远志', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (68, 17, 104, '酸枣仁', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (69, 17, 103, '龙眼肉', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (70, 17, 106, '木香', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (71, 17, 13, '炙甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (72, 18, 107, '龙胆', '6', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (73, 18, 75, '黄芩', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (74, 18, 77, '栀子', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (75, 18, 81, '泽泻', '12', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (76, 18, 109, '木通', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (77, 18, 108, '车前子', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (78, 18, 3, '当归', '3', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (79, 18, 22, '生地黄', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (80, 18, 83, '柴胡', '6', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (81, 18, 63, '甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (82, 19, 110, '苍术', '15', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (83, 19, 111, '厚朴', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (84, 19, 101, '陈皮', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (85, 19, 63, '甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (86, 20, 112, '山楂', '180', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (87, 20, 113, '神曲', '60', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (88, 20, 114, '莱菔子', '30', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (89, 20, 85, '半夏', '90', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (90, 20, 65, '茯苓', '90', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (91, 20, 101, '陈皮', '30', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (92, 20, 68, '连翘', '30', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (93, 21, 115, '独活', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (94, 21, 116, '桑寄生', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (95, 21, 117, '秦艽', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (96, 21, 118, '防风', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (97, 21, 119, '细辛', '3', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (98, 21, 3, '当归', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (99, 21, 84, '白芍', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (100, 21, 23, '川芎', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (101, 21, 22, '生地黄', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (102, 21, 121, '杜仲', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (103, 21, 120, '牛膝', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (104, 21, 1, '人参', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (105, 21, 65, '茯苓', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (106, 21, 63, '甘草', '6', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:31:59');
INSERT INTO `formula_herb` VALUES (107, 22, 123, '大黄', '12', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (108, 22, 124, '芒硝', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (109, 22, 111, '厚朴', '24', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (110, 22, 125, '枳实', '5', '枚', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (111, 23, 126, '竹茹', '6', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (112, 23, 125, '枳实', '6', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (113, 23, 85, '半夏', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (114, 23, 101, '陈皮', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (115, 23, 63, '甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (116, 23, 65, '茯苓', '5', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (117, 24, 127, '香附', '6', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (118, 24, 23, '川芎', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (119, 24, 110, '苍术', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (120, 24, 113, '神曲', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (121, 24, 77, '栀子', '6', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (122, 25, 85, '半夏', '12', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (123, 25, 128, '干姜', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (124, 25, 75, '黄芩', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (125, 25, 74, '黄连', '3', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (126, 25, 1, '人参', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (127, 25, 13, '炙甘草', '9', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (128, 26, 129, '丹参', '30', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (129, 26, 130, '砂仁', '3', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (130, 27, 78, '熟地黄', '240', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (131, 27, 79, '山茱萸', '120', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (132, 27, 80, '山药', '120', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (133, 27, 131, '附子', '30', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (134, 27, 61, '桂枝', '30', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (135, 27, 81, '泽泻', '90', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (136, 27, 82, '牡丹皮', '90', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (137, 27, 65, '茯苓', '90', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (138, 28, 104, '酸枣仁', '15', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (139, 28, 23, '川芎', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (140, 28, 65, '茯苓', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (141, 28, 98, '知母', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (142, 28, 63, '甘草', '3', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (143, 29, 1, '人参', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (144, 29, 64, '白术', '9', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (145, 29, 65, '茯苓', '9', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (146, 29, 80, '山药', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (147, 29, 134, '薏苡仁', '9', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (148, 29, 130, '砂仁', '5', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (149, 29, 133, '桔梗', '5', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (150, 29, 13, '炙甘草', '5', 'g', '使药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (151, 30, 100, '黄芪', '12', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (152, 30, 64, '白术', '6', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (153, 30, 118, '防风', '6', 'g', '佐药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (154, 31, 74, '黄连', '180', 'g', '君药', NULL, NULL, 0, '2025-07-08 15:40:04');
INSERT INTO `formula_herb` VALUES (155, 31, 136, '吴茱萸', '30', 'g', '臣药', NULL, NULL, 0, '2025-07-08 15:40:04');

-- ----------------------------
-- Table structure for formula_modification
-- ----------------------------
DROP TABLE IF EXISTS `formula_modification`;
CREATE TABLE `formula_modification`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `base_formula_id` bigint NOT NULL COMMENT '基础方剂ID',
  `modified_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '加减方名称',
  `modification_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '变化类型(加味、减味、药量调整)',
  `condition_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '适应条件',
  `herb_changes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '药物变化详情',
  `effect_changes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '功效变化',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `base_formula_id`(`base_formula_id` ASC) USING BTREE,
  CONSTRAINT `formula_modification_ibfk_1` FOREIGN KEY (`base_formula_id`) REFERENCES `formula` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '方剂加减变化表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of formula_modification
-- ----------------------------
INSERT INTO `formula_modification` VALUES (1, 1, '三拗汤', '减味', '适用于外感风寒，肺气不宣之咳嗽声重，痰涕清稀，鼻塞，恶寒发热，无汗，头痛，苔薄白，脉浮紧。', '麻黄汤去桂枝', NULL, NULL, '2025-07-07 19:10:33');

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
) ENGINE = InnoDB AUTO_INCREMENT = 137 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材主信息表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `herb` VALUES (60, '麻黄', 'Ephedrae Herba', '麻黄科', '野生', '灌木', '喜光、耐干旱、耐盐碱、抗严寒。主治喘咳、水气也，旁治恶风、恶寒、无汗、身疼、骨节痛、一身黄肿。', '2025-07-07 19:32:00', '2025-07-07 19:32:00');
INSERT INTO `herb` VALUES (61, '桂枝', 'Cinnamomum cassia (L.) D. Don', '樟科', '栽培', '乔木', '温中补肾、散寒止痛的功效，主治腰膝冷痛，虚寒胃痛，慢性消化不良，腹痛吐泻，受寒经闭等疾病', '2025-07-07 19:35:38', '2025-07-07 19:35:38');
INSERT INTO `herb` VALUES (62, '杏仁', 'Prunus armeniaca L.', '蔷薇科', '栽培', '乔木', '杏仁广泛应用于食品、化妆品及医药等领域。', '2025-07-07 19:37:40', '2025-07-07 19:37:40');
INSERT INTO `herb` VALUES (63, '甘草', 'Glycyrrhiza uralensis Fisch.', '豆科', '野生', '多年生草本植物', '根及根状茎供药用，有益气、解毒、调和诸药等功效，可治气短、腹痛、食物中毒等症。', '2025-07-07 19:39:31', '2025-07-07 19:39:31');
INSERT INTO `herb` VALUES (64, '白术', 'Atractylodes macrocephala Koidz.', '菊科', '野生', '多年生草本植物', '在《神农本草经》中白术被描述为具有健脾胃、消除水肿、增强免疫力等多种功效的药用植物。', '2025-07-07 19:41:09', '2025-07-07 19:41:09');
INSERT INTO `herb` VALUES (65, '茯苓', 'Poria cocos(Schw.)Wolf', '多孔菌科', '野生', '真菌菌核', '味甘、淡，性平。', '2025-07-07 19:42:59', '2025-07-07 19:42:59');
INSERT INTO `herb` VALUES (66, '炙甘草', 'RADIX GLYCYRRHIZAE PREPARATA', '豆科', '野生', '多年生草本植物', '具有益气滋阴，通阳复脉治疗功效。', '2025-07-07 19:44:36', '2025-07-07 19:44:36');
INSERT INTO `herb` VALUES (67, '金银花', 'Lonicera japonica Thunb.', '忍冬科', '野生', '藤本', '《名医别录》：今处处皆有，似藤生，凌冬不凋，故名忍冬。', '2025-07-07 19:46:37', '2025-07-07 19:46:37');
INSERT INTO `herb` VALUES (68, '连翘', 'Forsythia suspensa (Thunb.) Vahl', '木樨科', '野生', '灌木', '据《本草纲目》记载，连翘具有清热解毒、消肿散结的功效。', '2025-07-07 19:48:04', '2025-07-07 19:48:04');
INSERT INTO `herb` VALUES (69, '苦桔梗', 'Platycodon grandiflorus (Jacq.) A.DC.', '桔梗科', '野生', '多年生草本植物', '桔梗有祛痰、镇咳、抗炎、抗溃疡、降血压、扩张血管、解热、镇痛、镇静、降血糖、抗胆碱、抗过敏、抗肿瘤及提高免疫力等广泛的药理活性。', '2025-07-07 19:49:52', '2025-07-07 19:49:52');
INSERT INTO `herb` VALUES (70, '生甘草', 'Glycyrrhiza uralensis Fisch.', '豆科', '野生', '多年生草本植物', '具有补脾益气、清热解毒、祛痰止咳等功效。', '2025-07-07 19:51:59', '2025-07-07 19:51:59');
INSERT INTO `herb` VALUES (71, '荆芥穗', 'Schizonepeta tenusfolia Briq.', '唇形科', '野生', '植物花穗', '解表散风，透疹，消疮。', '2025-07-07 19:53:51', '2025-07-07 19:53:51');
INSERT INTO `herb` VALUES (72, '淡豆豉', '暂无', '豆科', '野生', '一年生草本植物', '用于伤寒热病，寒热，头痛，烦躁，胸闷。', '2025-07-07 19:55:52', '2025-07-07 19:55:52');
INSERT INTO `herb` VALUES (73, '牛蒡子', 'Arctium lappa L.', '菊科', '野生', '二年生草本植物', '牛蒡含有多种营养成分，其肉质直根可食用，可炒食、煮食、生食或加工成饮料，幼嫩叶片和叶柄叶可作为蔬菜食用。', '2025-07-07 19:57:43', '2025-07-07 19:57:43');
INSERT INTO `herb` VALUES (74, '黄连', 'Coptis chinensis', '毛茛科', '栽培', '多年生草本', '清热燥湿，泻火解毒。', '2025-07-07 20:12:56', '2025-07-07 20:12:56');
INSERT INTO `herb` VALUES (75, '黄芩', 'Scutellaria baicalensis', '唇形科', '栽培', '多年生草本', '清热燥湿，泻火解毒，止血，安胎。', '2025-07-07 20:12:56', '2025-07-07 20:12:56');
INSERT INTO `herb` VALUES (76, '黄柏', 'Phellodendron amurense', '芸香科', '野生', '乔木', '清热燥湿，泻火除蒸，解毒疗疮。', '2025-07-07 20:12:56', '2025-07-07 20:12:56');
INSERT INTO `herb` VALUES (77, '栀子', 'Gardenia jasminoides', '茜草科', '栽培', '灌木', '泻火除烦，清热利湿，凉血解毒。', '2025-07-07 20:12:56', '2025-07-07 20:12:56');
INSERT INTO `herb` VALUES (78, '熟地黄', 'Rehmannia glutinosa praeparata', '玄参科', '栽培', '多年生草本', '滋阴补血，益精填髓。', '2025-07-07 20:15:57', '2025-07-07 20:15:57');
INSERT INTO `herb` VALUES (79, '山茱萸', 'Cornus officinalis', '山茱萸科', '栽培', '落叶乔木或灌木', '补益肝肾，涩精固脱。', '2025-07-07 20:15:57', '2025-07-07 20:15:57');
INSERT INTO `herb` VALUES (80, '山药', 'Dioscorea opposita', '薯蓣科', '栽培', '多年生缠绕草本', '补脾养胃，生津益肺，补肾涩精。', '2025-07-07 20:15:57', '2025-07-07 20:15:57');
INSERT INTO `herb` VALUES (81, '泽泻', 'Alisma plantago-aquatica', '泽泻科', '栽培', '多年生水生或沼生草本', '利水渗湿，泄热。', '2025-07-07 20:15:57', '2025-07-07 20:15:57');
INSERT INTO `herb` VALUES (82, '牡丹皮', 'Paeonia suffruticosa', '毛茛科', '栽培', '落叶灌木', '清热凉血，活血化瘀。', '2025-07-07 20:15:57', '2025-07-07 20:15:57');
INSERT INTO `herb` VALUES (83, '柴胡', 'Bupleurum chinense', '伞形科', '栽培', '多年生草本', '疏散退热，疏肝解郁，升举阳气。', '2025-07-07 20:17:08', '2025-07-07 20:17:35');
INSERT INTO `herb` VALUES (84, '白芍', 'Paeonia lactiflora', '毛茛科', '栽培', '多年生草本', '养血柔肝，缓中止痛，敛阴收汗。', '2025-07-07 20:17:08', '2025-07-07 20:17:38');
INSERT INTO `herb` VALUES (85, '半夏', 'Pinellia ternata', '天南星科', '栽培', '多年生草本', '燥湿化痰，降逆止呕，消痞散结。', '2025-07-07 20:34:01', '2025-07-07 20:34:20');
INSERT INTO `herb` VALUES (96, '麦冬', 'Ophiopogon japonicus', '百合科', '栽培', '多年生草本', '养阴生津，润肺清心。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (97, '五味子', 'Schisandra chinensis', '木兰科', '栽培', '藤本', '收敛固涩，益气生津，补肾宁心。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (98, '知母', 'Anemarrhena asphodeloides', '百合科', '野生', '多年生草本', '清热泻火，生津润燥。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (99, '粳米', 'Oryza sativa L.', '禾本科', '栽培', '一年生草本', '补中益气，健脾和胃，除烦渴。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (100, '黄芪', 'Astragalus mongholicus', '豆科', '栽培', '多年生草本', '补气升阳，固表止汗，利水消肿。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (101, '陈皮', 'Citrus reticulata', '芸香科', '栽培', '乔木', '理气健脾，燥湿化痰。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (102, '升麻', 'Cimicifuga foetida', '毛茛科', '野生', '多年生草本', '发表透疹，清热解毒，升举阳气。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (103, '龙眼肉', 'Dimocarpus longan', '无患子科', '栽培', '乔木', '补益心脾，养血安神。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (104, '酸枣仁', 'Ziziphus jujuba var. spinosa', '鼠李科', '野生', '灌木或小乔木', '养心补肝，宁心安神，敛汗，生津。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (105, '远志', 'Polygala tenuifolia', '远志科', '野生', '多年生草本', '安神益智，祛痰，消肿。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (106, '木香', 'Aucklandia lappa', '菊科', '栽培', '多年生草本', '行气止痛，健脾消食。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (107, '龙胆', 'Gentiana scabra', '龙胆科', '野生', '多年生草本', '清热燥湿，泻肝胆火。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (108, '车前子', 'Plantago asiatica', '车前科', '野生', '多年生草本', '清热利尿通淋，渗湿止泻，明目，祛痰。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (109, '木通', 'Akebia trifoliata', '木通科', '野生', '藤本', '利尿通淋，清心火，通经下乳。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (110, '苍术', 'Atractylodes lancea', '菊科', '野生', '多年生草本', '燥湿健脾，祛风散寒，明目。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (111, '厚朴', 'Magnolia officinalis', '木兰科', '野生', '乔木', '燥湿消痰，下气除满。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (112, '山楂', 'Crataegus pinnatifida', '蔷薇科', '栽培', '乔木', '消食健胃，行气散瘀，化浊降脂。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (113, '神曲', 'Massa Medicata Fermentata', '多种中药材混合发酵', '栽培', '药曲', '健脾和胃，消食化积。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (114, '莱菔子', 'Raphanus sativus', '十字花科', '栽培', '一年或二年生草本', '消食除胀，降气化痰。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (115, '独活', 'Angelica pubescens', '伞形科', '野生', '多年生草本', '祛风除湿，通痹止痛。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (116, '桑寄生', 'Taxillus chinensis', '桑寄生科', '野生', '灌木', '补肝肾，强筋骨，祛风湿，安胎元。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (117, '秦艽', 'Gentiana macrophylla', '龙胆科', '野生', '多年生草本', '祛风湿，清湿热，止痹痛。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (118, '防风', 'Saposhnikovia divaricata', '伞形科', '栽培', '多年生草本', '解表祛风，胜湿，止痉。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (119, '细辛', 'Asarum sieboldii', '马兜铃科', '野生', '多年生草本', '祛风散寒，通窍止痛，温肺化饮。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (120, '牛膝', 'Achyranthes bidentata', '苋科', '栽培', '多年生草本', '逐瘀通经，补肝肾，强筋骨，利尿通淋，引血下行。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (121, '杜仲', 'Eucommia ulmoides', '杜仲科', '栽培', '乔木', '补肝肾，强筋骨，安胎。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (122, '石膏', 'Gypsum Fibrosum', '硫酸盐类矿物', '野生', '矿物', '清热泻火，除烦止渴。', '2025-07-08 16:00:00', '2025-07-08 16:00:00');
INSERT INTO `herb` VALUES (123, '大黄', 'Rheum palmatum', '蓼科', '栽培', '多年生草本', '泻下攻积，清热泻火，凉血解毒，逐瘀通经。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (124, '芒硝', 'Natrii Sulfas', '硫酸盐类矿物', '野生', '矿物', '泻下攻积，润燥软坚，清火消肿。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (125, '枳实', 'Citrus aurantium', '芸香科', '栽培', '乔木', '破气消积，化痰散痞。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (126, '竹茹', 'Bambusa tuldoides', '禾本科', '野生', '竹茎内层', '清热化痰，除烦止呕。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (127, '香附', 'Cyperus rotundus', '莎草科', '野生', '多年生草本', '疏肝理气，调经止痛。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (128, '干姜', 'Zingiber officinale', '姜科', '栽培', '多年生草本', '温中散寒，回阳通脉，燥湿消痰。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (129, '丹参', 'Salvia miltiorrhiza', '唇形科', '栽培', '多年生草本', '活血祛瘀，通经止痛，清心除烦，凉血消痈。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (130, '砂仁', 'Amomum villosum', '姜科', '栽培', '多年生草本', '化湿开胃，温脾止泻，理气安胎。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (131, '附子', 'Aconitum carmichaelii', '毛茛科', '栽培', '多年生草本', '回阳救逆，补火助阳，散寒止痛。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (133, '桔梗', 'Platycodon grandiflorus', '桔梗科', '栽培', '多年生草本', '宣肺，利咽，祛痰，排脓。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (134, '薏苡仁', 'Coix lacryma-jobi', '禾本科', '栽培', '一年生草本', '健脾渗湿，除痹止泻，清热排脓。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');
INSERT INTO `herb` VALUES (136, '吴茱萸', 'Tetradium ruticarpum', '芸香科', '栽培', '灌木或小乔木', '散寒止痛，降逆止呕，助阳止泻。', '2025-07-08 17:00:00', '2025-07-08 17:00:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生长/统计数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_growth_data
-- ----------------------------
INSERT INTO `herb_growth_data` VALUES (6, 114, '平均株高', '31', 'cm', '2025-07-08 00:25:00');
INSERT INTO `herb_growth_data` VALUES (7, 116, '平均株高', '21', 'cm', '2025-07-08 00:26:00');
INSERT INTO `herb_growth_data` VALUES (8, 115, '平均株高', '21', 'cm', '2025-07-08 00:26:00');
INSERT INTO `herb_growth_data` VALUES (9, 117, '产量', '34', 'kg', '2025-07-08 00:27:00');
INSERT INTO `herb_growth_data` VALUES (10, 118, '产量', '56', 'kg', '2025-07-08 00:28:00');
INSERT INTO `herb_growth_data` VALUES (11, 119, '产量', '43', 'kg', '2025-07-08 00:32:00');
INSERT INTO `herb_growth_data` VALUES (12, 120, '产量', '21', 'kg', '2025-07-08 00:33:00');
INSERT INTO `herb_growth_data` VALUES (13, 121, '产量', '43', 'kg', '2025-07-08 00:34:00');
INSERT INTO `herb_growth_data` VALUES (14, 122, '产量', '31', 'kg', '2025-07-08 00:34:00');
INSERT INTO `herb_growth_data` VALUES (15, 123, '产量', '64', 'kg', '2025-07-08 00:35:00');
INSERT INTO `herb_growth_data` VALUES (16, 124, '叶片面积', '10', 'cm²', '2025-07-08 00:36:00');
INSERT INTO `herb_growth_data` VALUES (17, 125, '叶片面积', '12', 'cm²', '2025-07-08 00:37:00');
INSERT INTO `herb_growth_data` VALUES (18, 126, '叶片面积', '11', 'cm²', '2025-07-08 00:38:00');
INSERT INTO `herb_growth_data` VALUES (19, 127, '叶片面积', '13', 'cm²', '2025-07-08 00:39:00');
INSERT INTO `herb_growth_data` VALUES (20, 128, '叶片面积', '15', 'cm²', '2025-07-08 00:39:00');
INSERT INTO `herb_growth_data` VALUES (21, 129, '叶片面积', '21', 'cm²', '2025-07-08 00:40:00');
INSERT INTO `herb_growth_data` VALUES (22, 130, '根茎长度', '10', 'cm', '2025-07-08 00:41:00');
INSERT INTO `herb_growth_data` VALUES (23, 131, '根茎长度', '10', 'cm', '2025-07-08 00:41:00');
INSERT INTO `herb_growth_data` VALUES (24, 132, '根茎长度', '11', 'cm', '2025-07-08 00:42:00');
INSERT INTO `herb_growth_data` VALUES (25, 133, '产量', '12', 'kg', '2025-07-08 00:42:00');
INSERT INTO `herb_growth_data` VALUES (26, 134, '根茎长度', '12', 'cm', '2025-07-08 00:43:00');
INSERT INTO `herb_growth_data` VALUES (27, 135, '根茎长度', '12', 'cm', '2025-07-08 00:44:00');
INSERT INTO `herb_growth_data` VALUES (28, 136, '根茎长度', '21', 'cm', '2025-07-08 00:45:00');
INSERT INTO `herb_growth_data` VALUES (29, 137, '平均株高', '120', 'cm', '2025-07-08 00:46:00');
INSERT INTO `herb_growth_data` VALUES (30, 138, '产量', '21', 'kg', '2025-07-08 00:47:00');
INSERT INTO `herb_growth_data` VALUES (31, 139, '平均株高', '16', 'cm', '2025-07-08 00:47:00');
INSERT INTO `herb_growth_data` VALUES (32, 140, '土壤PH值', '7', '无', '2025-07-08 00:48:00');
INSERT INTO `herb_growth_data` VALUES (33, 141, '平均株高', '12', 'cm', '2025-07-08 00:49:00');
INSERT INTO `herb_growth_data` VALUES (34, 142, '平均株高', '21', 'cm', '2025-07-08 00:49:00');
INSERT INTO `herb_growth_data` VALUES (35, 143, '产量', '12', 'kg', '2025-07-08 00:50:00');
INSERT INTO `herb_growth_data` VALUES (36, 144, '平均株高', '19', 'cm', '2025-07-08 00:51:00');
INSERT INTO `herb_growth_data` VALUES (37, 145, '平均株高', '21', 'cm', '2025-07-08 00:51:00');
INSERT INTO `herb_growth_data` VALUES (38, 146, '产量', '32', 'kg', '2025-07-08 00:52:00');
INSERT INTO `herb_growth_data` VALUES (39, 147, '平均株高', '21', 'cm', '2025-07-08 00:53:00');
INSERT INTO `herb_growth_data` VALUES (40, 148, '平均株高', '21', 'cm', '2025-07-08 00:53:00');
INSERT INTO `herb_growth_data` VALUES (41, 149, '产量', '21', 'kg', '2025-07-08 00:55:00');
INSERT INTO `herb_growth_data` VALUES (42, 150, '平均株高', '21', 'cm', '2025-07-08 00:55:00');
INSERT INTO `herb_growth_data` VALUES (43, 151, '平均株高', '21', 'cm', '2025-07-08 00:56:00');
INSERT INTO `herb_growth_data` VALUES (44, 152, '叶片面积', '21', 'cm²', '2025-07-08 00:57:00');
INSERT INTO `herb_growth_data` VALUES (45, 153, '产量', '56', 'kg', '2025-07-08 00:58:00');
INSERT INTO `herb_growth_data` VALUES (46, 154, '平均株高', '21', 'cm', '2025-07-08 00:58:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生长/统计数据变更历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_growth_data_history
-- ----------------------------
INSERT INTO `herb_growth_data_history` VALUES (1, 3, 2, '预估产量', '800', '850', 'UPDATE', 'admin', '2025-06-27 13:42:19', '根据最新航拍数据修正');
INSERT INTO `herb_growth_data_history` VALUES (2, 3, 14, '预估产量', '400', '850', 'UPDATE', 'system', '2025-06-30 10:26:15', '最新修正');
INSERT INTO `herb_growth_data_history` VALUES (3, 3, 12, '土壤PH', '7', '9', 'UPDATE', 'Lu', '2025-07-02 19:53:10', '最新观测修正');
INSERT INTO `herb_growth_data_history` VALUES (4, 3, 14, '含糖量', '45', '46', 'UPDATE', 'system', '2025-07-02 20:09:39', '最新修正');
INSERT INTO `herb_growth_data_history` VALUES (5, 6, 114, '平均株高', NULL, '31 cm', 'CREATE', 'luyue', '2025-07-08 16:26:11', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (6, 7, 116, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:27:41', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (7, 8, 115, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:27:43', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (8, 9, 117, '产量', NULL, '34 kg', 'CREATE', 'luyue', '2025-07-08 16:28:47', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (9, 10, 118, '产量', NULL, '56 kg', 'CREATE', 'luyue', '2025-07-08 16:32:33', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (10, 11, 119, '产量', NULL, '43 kg', 'CREATE', 'luyue', '2025-07-08 16:33:31', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (11, 12, 120, '产量', NULL, '21 kg', 'CREATE', 'luyue', '2025-07-08 16:34:13', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (12, 13, 121, '产量', NULL, '43 kg', 'CREATE', 'luyue', '2025-07-08 16:34:50', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (13, 14, 122, '产量', NULL, '31 kg', 'CREATE', 'luyue', '2025-07-08 16:35:53', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (14, 15, 123, '产量', NULL, '64 kg', 'CREATE', 'luyue', '2025-07-08 16:36:56', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (15, 16, 124, '叶片面积', NULL, '10 cm²', 'CREATE', 'luyue', '2025-07-08 16:37:45', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (16, 17, 125, '叶片面积', NULL, '12 cm²', 'CREATE', 'luyue', '2025-07-08 16:38:32', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (17, 18, 126, '叶片面积', NULL, '11 cm²', 'CREATE', 'luyue', '2025-07-08 16:39:13', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (18, 19, 127, '叶片面积', NULL, '13 cm²', 'CREATE', 'luyue', '2025-07-08 16:39:54', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (19, 20, 128, '叶片面积', NULL, '15 cm²', 'CREATE', 'luyue', '2025-07-08 16:40:41', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (20, 21, 129, '叶片面积', NULL, '21 cm²', 'CREATE', 'luyue', '2025-07-08 16:41:21', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (21, 22, 130, '根茎长度', NULL, '10 cm', 'CREATE', 'luyue', '2025-07-08 16:42:05', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (22, 23, 131, '根茎长度', NULL, '10 cm', 'CREATE', 'luyue', '2025-07-08 16:42:19', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (23, 24, 132, '根茎长度', NULL, '11 cm', 'CREATE', 'luyue', '2025-07-08 16:42:54', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (24, 25, 133, '产量', NULL, '12 kg', 'CREATE', 'luyue', '2025-07-08 16:43:54', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (25, 26, 134, '根茎长度', NULL, '12 cm', 'CREATE', 'luyue', '2025-07-08 16:44:58', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (26, 27, 135, '根茎长度', NULL, '12 cm', 'CREATE', 'luyue', '2025-07-08 16:45:54', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (27, 28, 136, '根茎长度', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:46:33', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (28, 29, 137, '平均株高', NULL, '120 cm', 'CREATE', 'luyue', '2025-07-08 16:47:05', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (29, 30, 138, '产量', NULL, '21 kg', 'CREATE', 'luyue', '2025-07-08 16:47:43', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (30, 31, 139, '平均株高', NULL, '16 cm', 'CREATE', 'luyue', '2025-07-08 16:48:20', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (31, 32, 140, '土壤PH值', NULL, '7 无', 'CREATE', 'luyue', '2025-07-08 16:49:03', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (32, 33, 141, '平均株高', NULL, '12 cm', 'CREATE', 'luyue', '2025-07-08 16:49:38', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (33, 34, 142, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:50:20', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (34, 35, 143, '产量', NULL, '12 kg', 'CREATE', 'luyue', '2025-07-08 16:51:05', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (35, 36, 144, '平均株高', NULL, '19 cm', 'CREATE', 'luyue', '2025-07-08 16:51:40', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (36, 37, 145, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:52:12', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (37, 38, 146, '产量', NULL, '32 kg', 'CREATE', 'luyue', '2025-07-08 16:53:04', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (38, 39, 147, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:53:37', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (39, 40, 148, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:55:09', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (40, 41, 149, '产量', NULL, '21 kg', 'CREATE', 'luyue', '2025-07-08 16:55:49', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (41, 42, 150, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:56:42', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (42, 43, 151, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:57:20', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (43, 44, 152, '叶片面积', NULL, '21 cm²', 'CREATE', 'luyue', '2025-07-08 16:58:08', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (44, 45, 153, '产量', NULL, '56 kg', 'CREATE', 'luyue', '2025-07-08 16:58:43', '用户初次上传数据');
INSERT INTO `herb_growth_data_history` VALUES (45, 46, 154, '平均株高', NULL, '21 cm', 'CREATE', 'luyue', '2025-07-08 16:59:10', '用户初次上传数据');

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
) ENGINE = InnoDB AUTO_INCREMENT = 149 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材图片表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `herb_image` VALUES (84, 60, 86, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751887926110_麻黄.webp', 0, '主图: 麻黄.webp', '2025-07-07 19:32:08');
INSERT INTO `herb_image` VALUES (85, 61, 87, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888139443_桂枝.webp', 0, '主图: 桂枝.webp', '2025-07-07 19:35:40');
INSERT INTO `herb_image` VALUES (86, 62, 88, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888261625_杏仁.webp', 0, '主图: 杏仁.webp', '2025-07-07 19:37:43');
INSERT INTO `herb_image` VALUES (87, 63, 89, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888373661_甘草.webp', 0, '主图: 甘草.webp', '2025-07-07 19:39:35');
INSERT INTO `herb_image` VALUES (88, 64, 90, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888469740_白术.webp', 0, '主图: 白术.webp', '2025-07-07 19:41:11');
INSERT INTO `herb_image` VALUES (89, 65, 91, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888580140_茯苓.webp', 0, '主图: 茯苓.webp', '2025-07-07 19:43:00');
INSERT INTO `herb_image` VALUES (90, 66, 92, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888677643_炙甘草.webp', 0, '主图: 炙甘草.webp', '2025-07-07 19:44:38');
INSERT INTO `herb_image` VALUES (91, 67, 93, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888797923_金银花.webp', 0, '主图: 金银花.webp', '2025-07-07 19:46:39');
INSERT INTO `herb_image` VALUES (92, 68, 94, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888885420_连翘.webp', 0, '主图: 连翘.webp', '2025-07-07 19:48:06');
INSERT INTO `herb_image` VALUES (93, 69, 95, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751888993463_苦桔梗.webp', 0, '主图: 苦桔梗.webp', '2025-07-07 19:49:54');
INSERT INTO `herb_image` VALUES (94, 70, 96, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751889119810_生甘草.webp', 0, '主图: 生甘草.webp', '2025-07-07 19:52:00');
INSERT INTO `herb_image` VALUES (95, 71, 97, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751889233388_荆芥穗.webp', 0, '主图: 荆芥穗.webp', '2025-07-07 19:53:54');
INSERT INTO `herb_image` VALUES (96, 72, 98, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751889353077_淡豆豉.webp', 0, '主图: 淡豆豉.webp', '2025-07-07 19:55:54');
INSERT INTO `herb_image` VALUES (97, 73, 99, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751889463751_牛蒡子.webp', 0, '主图: 牛蒡子.webp', '2025-07-07 19:57:44');
INSERT INTO `herb_image` VALUES (98, 79, 100, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751892794535_山茱萸.webp', 0, '附加图片: 山茱萸.webp', '2025-07-07 20:53:15');
INSERT INTO `herb_image` VALUES (99, 80, 101, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751892861987_山药.webp', 0, '附加图片: 山药.webp', '2025-07-07 20:54:23');
INSERT INTO `herb_image` VALUES (100, 85, 102, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751892925865_半夏.webp', 0, '附加图片: 半夏.webp', '2025-07-07 20:55:27');
INSERT INTO `herb_image` VALUES (101, 83, 103, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893055892_柴胡.webp', 0, '附加图片: 柴胡.webp', '2025-07-07 20:57:37');
INSERT INTO `herb_image` VALUES (102, 77, 104, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893120421_栀子.webp', 0, '附加图片: 栀子.webp', '2025-07-07 20:58:41');
INSERT INTO `herb_image` VALUES (103, 81, 105, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893198517_泽泻.webp', 0, '附加图片: 泽泻.webp', '2025-07-07 20:59:59');
INSERT INTO `herb_image` VALUES (104, 78, 106, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893259895_熟地黄.webp', 0, '附加图片: 熟地黄.webp', '2025-07-07 21:01:00');
INSERT INTO `herb_image` VALUES (105, 82, 107, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893352093_牡丹皮.webp', 0, '附加图片: 牡丹皮.webp', '2025-07-07 21:02:32');
INSERT INTO `herb_image` VALUES (106, 84, 108, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893417669_白芍.webp', 0, '附加图片: 白芍.webp', '2025-07-07 21:03:38');
INSERT INTO `herb_image` VALUES (107, 76, 109, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893474163_黄柏.webp', 0, '附加图片: 黄柏.webp', '2025-07-07 21:04:35');
INSERT INTO `herb_image` VALUES (108, 75, 110, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893522743_黄芩.webp', 0, '附加图片: 黄芩.webp', '2025-07-07 21:05:23');
INSERT INTO `herb_image` VALUES (109, 74, 111, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751893616008_黄连.webp', 0, '附加图片: 黄连.webp', '2025-07-07 21:06:56');
INSERT INTO `herb_image` VALUES (110, 129, 114, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963171283_丹参.webp', 0, '附加图片: 丹参.webp', '2025-07-08 16:26:12');
INSERT INTO `herb_image` VALUES (111, 97, 116, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963261351_五味子.webp', 0, '附加图片: 五味子.webp', '2025-07-08 16:27:43');
INSERT INTO `herb_image` VALUES (112, 102, 117, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963326964_升麻.webp', 0, '附加图片: 升麻.webp', '2025-07-08 16:28:48');
INSERT INTO `herb_image` VALUES (113, 111, 118, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963553654_厚朴.webp', 0, '附加图片: 厚朴.webp', '2025-07-08 16:32:34');
INSERT INTO `herb_image` VALUES (114, 136, 119, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963611524_吴茱萸.webp', 0, '附加图片: 吴茱萸.webp', '2025-07-08 16:33:32');
INSERT INTO `herb_image` VALUES (115, 123, 120, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963653725_大黄.webp', 0, '附加图片: 大黄.webp', '2025-07-08 16:34:14');
INSERT INTO `herb_image` VALUES (116, 112, 121, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963690387_山楂.webp', 0, '附加图片: 山楂.webp', '2025-07-08 16:34:51');
INSERT INTO `herb_image` VALUES (117, 128, 122, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963753071_干姜.webp', 0, '附加图片: 干姜.webp', '2025-07-08 16:35:54');
INSERT INTO `herb_image` VALUES (118, 109, 123, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963816356_木通.webp', 0, '附加图片: 木通.webp', '2025-07-08 16:36:58');
INSERT INTO `herb_image` VALUES (119, 106, 124, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963865731_木香.webp', 0, '附加图片: 木香.webp', '2025-07-08 16:37:47');
INSERT INTO `herb_image` VALUES (120, 121, 125, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963911882_杜仲.webp', 0, '附加图片: 杜仲.webp', '2025-07-08 16:38:32');
INSERT INTO `herb_image` VALUES (121, 125, 126, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963953963_枳实.webp', 0, '附加图片: 枳实.webp', '2025-07-08 16:39:14');
INSERT INTO `herb_image` VALUES (122, 116, 127, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751963994693_桑寄生.webp', 0, '附加图片: 桑寄生.webp', '2025-07-08 16:39:55');
INSERT INTO `herb_image` VALUES (123, 133, 128, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964041060_桔梗.webp', 0, '附加图片: 桔梗.webp', '2025-07-08 16:40:41');
INSERT INTO `herb_image` VALUES (124, 120, 129, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964081933_牛膝.webp', 0, '附加图片: 牛膝.webp', '2025-07-08 16:41:22');
INSERT INTO `herb_image` VALUES (125, 115, 131, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964139337_独活.webp', 0, '附加图片: 独活.webp', '2025-07-08 16:42:20');
INSERT INTO `herb_image` VALUES (126, 98, 132, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964174744_知母.webp', 0, '附加图片: 知母.webp', '2025-07-08 16:42:55');
INSERT INTO `herb_image` VALUES (127, 122, 133, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964233793_石膏.webp', 0, '附加图片: 石膏.webp', '2025-07-08 16:43:54');
INSERT INTO `herb_image` VALUES (128, 130, 134, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964298159_砂仁.webp', 0, '附加图片: 砂仁.webp', '2025-07-08 16:44:59');
INSERT INTO `herb_image` VALUES (129, 113, 135, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964354872_神曲.webp', 0, '附加图片: 神曲.webp', '2025-07-08 16:45:55');
INSERT INTO `herb_image` VALUES (130, 117, 136, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964393288_秦艽.webp', 0, '附加图片: 秦艽.webp', '2025-07-08 16:46:34');
INSERT INTO `herb_image` VALUES (131, 126, 137, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964425167_竹茹.webp', 0, '附加图片: 竹茹.webp', '2025-07-08 16:47:05');
INSERT INTO `herb_image` VALUES (132, 99, 138, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964462791_粳米.webp', 0, '附加图片: 粳米.webp', '2025-07-08 16:47:43');
INSERT INTO `herb_image` VALUES (133, 119, 139, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964499798_细辛.webp', 0, '附加图片: 细辛.webp', '2025-07-08 16:48:20');
INSERT INTO `herb_image` VALUES (134, 124, 140, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964543684_芒硝.webp', 0, '附加图片: 芒硝.webp', '2025-07-08 16:49:04');
INSERT INTO `herb_image` VALUES (135, 110, 141, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964578383_苍术.webp', 0, '附加图片: 苍术.webp', '2025-07-08 16:49:39');
INSERT INTO `herb_image` VALUES (136, 114, 142, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964620288_莱菔子.webp', 0, '附加图片: 莱菔子.webp', '2025-07-08 16:50:21');
INSERT INTO `herb_image` VALUES (137, 134, 143, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964665680_薏苡仁.webp', 0, '附加图片: 薏苡仁.webp', '2025-07-08 16:51:06');
INSERT INTO `herb_image` VALUES (138, 108, 144, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964699873_车前子.webp', 0, '附加图片: 车前子.webp', '2025-07-08 16:51:40');
INSERT INTO `herb_image` VALUES (139, 105, 145, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964732225_远志.webp', 0, '附加图片: 远志.webp', '2025-07-08 16:52:13');
INSERT INTO `herb_image` VALUES (140, 104, 146, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964784061_酸枣仁.webp', 0, '附加图片: 酸枣仁.webp', '2025-07-08 16:53:04');
INSERT INTO `herb_image` VALUES (141, 118, 147, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964817273_防风.webp', 0, '附加图片: 防风.webp', '2025-07-08 16:53:38');
INSERT INTO `herb_image` VALUES (142, 131, 148, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964909455_香附.webp', 0, '附加图片: 香附.webp', '2025-07-08 16:55:10');
INSERT INTO `herb_image` VALUES (143, 101, 149, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751964949465_陈皮.webp', 0, '附加图片: 陈皮.webp', '2025-07-08 16:55:50');
INSERT INTO `herb_image` VALUES (144, 127, 150, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751965002277_香附.webp', 0, '附加图片: 香附.webp', '2025-07-08 16:56:43');
INSERT INTO `herb_image` VALUES (145, 96, 151, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751965039904_麦冬.webp', 0, '附加图片: 麦冬.webp', '2025-07-08 16:57:20');
INSERT INTO `herb_image` VALUES (146, 100, 152, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751965088802_黄芪.webp', 0, '附加图片: 黄芪.webp', '2025-07-08 16:58:10');
INSERT INTO `herb_image` VALUES (147, 103, 153, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751965123619_龙眼肉.webp', 0, '附加图片: 龙眼肉.webp', '2025-07-08 16:58:44');
INSERT INTO `herb_image` VALUES (148, 107, 154, 'https://biomedinfo.oss-cn-beijing.aliyuncs.com/user-uploads/1751965149982_龙胆.webp', 0, '附加图片: 龙胆.webp', '2025-07-08 16:59:10');

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
) ENGINE = InnoDB AUTO_INCREMENT = 155 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材地理分布(观测点)表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `herb_location` VALUES (86, 60, 112.7526330, 37.6880060, '山西省', '晋中市', '晋中市', 2025, '2025-07-07 19:32:05');
INSERT INTO `herb_location` VALUES (87, 61, 110.1797520, 25.2356150, '广西壮族自治区', '桂林市', '桂林市', 2025, '2025-07-07 19:35:39');
INSERT INTO `herb_location` VALUES (88, 62, 114.5391500, 36.6258490, '河北省', '邯郸市', '邯郸市', 2025, '2025-07-07 19:37:41');
INSERT INTO `herb_location` VALUES (89, 63, 124.3505990, 43.1667640, '吉林省', '四平市', '四平市', 2025, '2025-07-07 19:39:33');
INSERT INTO `herb_location` VALUES (90, 64, 120.6992790, 27.9938490, '浙江省', '温州市', '温州市', 2025, '2025-07-07 19:41:10');
INSERT INTO `herb_location` VALUES (91, 65, 117.1153490, 30.5318280, '安徽省', '安庆市', '安庆市', 2025, '2025-07-07 19:43:00');
INSERT INTO `herb_location` VALUES (92, 66, 102.1879720, 38.5214680, '甘肃省', '金昌市', '金昌市', 2025, '2025-07-07 19:44:37');
INSERT INTO `herb_location` VALUES (93, 67, 117.2015090, 39.0853180, '天津市', '天津市', '天津市', 2025, '2025-07-07 19:46:38');
INSERT INTO `herb_location` VALUES (94, 68, 108.7088370, 34.3298960, '陕西省', '咸阳市', '咸阳市', 2025, '2025-07-07 19:48:05');
INSERT INTO `herb_location` VALUES (95, 69, 130.9693850, 45.2950870, '黑龙江省', '鸡西市', '鸡西市', 2025, '2025-07-07 19:49:53');
INSERT INTO `herb_location` VALUES (96, 70, 102.4106400, 36.4734480, '青海省', '海东市', '海东市', 2025, '2025-07-07 19:52:00');
INSERT INTO `herb_location` VALUES (97, 71, 119.2214870, 34.5966390, '江苏省', '连云港市', '连云港市', 2025, '2025-07-07 19:53:53');
INSERT INTO `herb_location` VALUES (98, 72, 117.2272670, 31.8205670, '安徽省', '合肥市', '合肥市', 2025, '2025-07-07 19:55:53');
INSERT INTO `herb_location` VALUES (99, 73, 116.6581110, 34.6972320, '江苏省', '徐州市', '丰县', 2025, '2025-07-07 19:57:44');
INSERT INTO `herb_location` VALUES (100, 79, 112.7526330, 37.6880060, '山西省', '晋中市', '晋中市', 2025, '2025-07-07 20:53:14');
INSERT INTO `herb_location` VALUES (101, 80, 126.4142740, 41.9441320, '吉林省', '白山市', '白山市', 2025, '2025-07-07 20:54:22');
INSERT INTO `herb_location` VALUES (102, 85, 119.5202200, 39.8882430, '河北省', '秦皇岛市', '秦皇岛市', 2025, '2025-07-07 20:55:26');
INSERT INTO `herb_location` VALUES (103, 83, 106.4400560, 30.5386560, '四川省', '广安市', '岳池县', 2025, '2025-07-07 20:57:36');
INSERT INTO `herb_location` VALUES (104, 77, 105.9476000, 26.2531030, '贵州省', '安顺市', '安顺市', 2025, '2025-07-07 20:58:40');
INSERT INTO `herb_location` VALUES (105, 81, 99.1614890, 25.1120180, '云南省', '保山市', '保山市', 2025, '2025-07-07 20:59:58');
INSERT INTO `herb_location` VALUES (106, 78, 117.1506380, 39.1385510, '天津市', '天津市', '南开', 2025, '2025-07-07 21:01:00');
INSERT INTO `herb_location` VALUES (107, 82, 107.0317980, 33.0336110, '陕西省', '汉中市', '南郑区龙岗大道九龙府龙岗中学', 2025, '2025-07-07 21:02:32');
INSERT INTO `herb_location` VALUES (108, 84, 120.7378980, 30.7882860, '浙江省', '嘉兴市', '嘉兴市', 2025, '2025-07-07 21:03:37');
INSERT INTO `herb_location` VALUES (109, 76, 115.0389990, 30.2010820, '湖北省', '黄石市', '黄石市', 2025, '2025-07-07 21:04:34');
INSERT INTO `herb_location` VALUES (110, 75, 117.3237590, 34.8108580, '山东省', '枣庄市', '枣庄市', 2025, '2025-07-07 21:05:22');
INSERT INTO `herb_location` VALUES (111, 74, 112.9291030, 28.1697990, '湖南省', '长沙市', '岳麓区麓山南路中南大学校本部', 2025, '2025-07-07 21:06:56');
INSERT INTO `herb_location` VALUES (112, 129, 118.4330650, 31.3526140, '安徽省', '芜湖市', '芜湖市', 2025, '2025-07-08 16:13:44');
INSERT INTO `herb_location` VALUES (113, 129, 111.5193100, 36.0885810, '山西省', '临汾市', '临汾市', 2025, '2025-07-08 16:18:34');
INSERT INTO `herb_location` VALUES (114, 129, 112.7526330, 37.6880060, '山西省', '晋中市', '晋中市', 2025, '2025-07-08 16:26:10');
INSERT INTO `herb_location` VALUES (115, 97, 121.4477550, 37.4645510, '山东省', '烟台市', '烟台市', 2025, '2025-07-08 16:27:23');
INSERT INTO `herb_location` VALUES (116, 97, 121.4477550, 37.4645510, '山东省', '烟台市', '烟台市', 2025, '2025-07-08 16:27:40');
INSERT INTO `herb_location` VALUES (117, 102, 102.6739560, 24.9738690, '云南省', '昆明市', '云南大学', 2025, '2025-07-08 16:28:46');
INSERT INTO `herb_location` VALUES (118, 111, 109.3018590, 34.5022520, '陕西省', '西安市', '西安交通大学', 2025, '2025-07-08 16:32:33');
INSERT INTO `herb_location` VALUES (119, 136, 101.7184600, 26.5824170, '四川省', '攀枝花市', '攀枝花市', 2025, '2025-07-08 16:33:31');
INSERT INTO `herb_location` VALUES (120, 123, 103.8565730, 36.0474560, '甘肃省', '兰州市', '兰州大学', 2025, '2025-07-08 16:34:13');
INSERT INTO `herb_location` VALUES (121, 112, 131.0030150, 45.7711780, '黑龙江省', '七台河市', '七台河市', 2025, '2025-07-08 16:34:49');
INSERT INTO `herb_location` VALUES (122, 128, 103.8484170, 30.0771130, '四川省', '眉山市', '眉山市', 2025, '2025-07-08 16:35:51');
INSERT INTO `herb_location` VALUES (123, 109, 120.3118890, 31.4910640, '江苏省', '无锡市', '无锡市', 2025, '2025-07-08 16:36:54');
INSERT INTO `herb_location` VALUES (124, 106, 91.7714260, 29.2377220, '西藏自治区', '山南市', '山南市', 2025, '2025-07-08 16:37:44');
INSERT INTO `herb_location` VALUES (125, 121, 113.5768920, 22.2716440, '广东省', '珠海市', '珠海市', 2025, '2025-07-08 16:38:31');
INSERT INTO `herb_location` VALUES (126, 125, 111.2869620, 30.6921700, '湖北省', '宜昌市', '宜昌市', 2025, '2025-07-08 16:39:13');
INSERT INTO `herb_location` VALUES (127, 116, 118.5865200, 24.9081330, '福建省', '泉州市', '鲤城区', 2025, '2025-07-08 16:39:54');
INSERT INTO `herb_location` VALUES (128, 133, 125.2799580, 43.8262490, '吉林省', '长春市', '吉林大学', 2025, '2025-07-08 16:40:40');
INSERT INTO `herb_location` VALUES (129, 120, 112.5848280, 37.8321690, '山西省', '太原市', '太原理工学院', 2025, '2025-07-08 16:41:20');
INSERT INTO `herb_location` VALUES (130, 115, 117.3885660, 32.9168200, '安徽省', '蚌埠市', '蚌埠市', 2025, '2025-07-08 16:42:05');
INSERT INTO `herb_location` VALUES (131, 115, 117.3885660, 32.9168200, '安徽省', '蚌埠市', '蚌埠市', 2025, '2025-07-08 16:42:18');
INSERT INTO `herb_location` VALUES (132, 98, 115.4645230, 38.8744760, '河北省', '保定市', '保定市', 2025, '2025-07-08 16:42:54');
INSERT INTO `herb_location` VALUES (133, 122, 115.9535600, 29.6611600, '江西省', '九江市', '九江市', 2025, '2025-07-08 16:43:53');
INSERT INTO `herb_location` VALUES (134, 130, 100.9660110, 22.8252290, '云南省', '普洱市', '普洱市', 2025, '2025-07-08 16:44:58');
INSERT INTO `herb_location` VALUES (135, 113, 131.0030150, 45.7711780, '黑龙江省', '七台河市', '七台河市', 2025, '2025-07-08 16:45:54');
INSERT INTO `herb_location` VALUES (136, 117, 106.1986130, 37.9977550, '宁夏回族自治区', '吴忠市', '吴忠市', 2025, '2025-07-08 16:46:33');
INSERT INTO `herb_location` VALUES (137, 126, 120.5852940, 31.2997580, '江苏省', '苏州市', '苏州市', 2025, '2025-07-08 16:47:04');
INSERT INTO `herb_location` VALUES (138, 99, 121.4477550, 37.4645510, '山东省', '烟台市', '烟台市', 2025, '2025-07-08 16:47:42');
INSERT INTO `herb_location` VALUES (139, 119, 123.2396690, 41.2673960, '辽宁省', '辽阳市', '辽阳市', 2025, '2025-07-08 16:48:19');
INSERT INTO `herb_location` VALUES (140, 124, 113.2419020, 35.2157260, '河南省', '焦作市', '焦作市', 2025, '2025-07-08 16:49:02');
INSERT INTO `herb_location` VALUES (141, 110, 119.7092210, 49.4617530, '内蒙古自治区', '呼伦贝尔市', '呼伦贝尔大草原', 2025, '2025-07-08 16:49:38');
INSERT INTO `herb_location` VALUES (142, 114, 120.4888010, 41.6018550, '辽宁省', '朝阳市', '朝阳市', 2025, '2025-07-08 16:50:19');
INSERT INTO `herb_location` VALUES (143, 134, 117.6389190, 26.2634550, '福建省', '三明市', '三明市', 2025, '2025-07-08 16:51:05');
INSERT INTO `herb_location` VALUES (144, 108, 109.9531500, 40.6213270, '内蒙古自治区', '包头市', '包头市', 2025, '2025-07-08 16:51:39');
INSERT INTO `herb_location` VALUES (145, 105, 105.8440040, 32.4357740, '四川省', '广元市', '广元市', 2025, '2025-07-08 16:52:12');
INSERT INTO `herb_location` VALUES (146, 104, 106.4726040, 29.5638150, '重庆市', '重庆市', '重庆大学', 2025, '2025-07-08 16:53:03');
INSERT INTO `herb_location` VALUES (147, 118, 125.1446760, 42.8879610, '吉林省', '辽源市', '辽源市', 2025, '2025-07-08 16:53:37');
INSERT INTO `herb_location` VALUES (148, 131, 109.4280710, 24.3264420, '广西壮族自治区', '柳州市', '柳州市', 2025, '2025-07-08 16:55:09');
INSERT INTO `herb_location` VALUES (149, 101, 117.6472980, 24.5152970, '福建省', '漳州市', '漳州市', 2025, '2025-07-08 16:55:49');
INSERT INTO `herb_location` VALUES (150, 127, 113.1289220, 29.3564800, '湖南省', '岳阳市', '岳阳市', 2025, '2025-07-08 16:56:41');
INSERT INTO `herb_location` VALUES (151, 96, 121.5090620, 25.0443320, '台湾省', '台南市', '台南市', 2025, '2025-07-08 16:57:19');
INSERT INTO `herb_location` VALUES (152, 100, 104.3977950, 31.1274490, '四川省', '德阳市', '德阳市', 2025, '2025-07-08 16:58:06');
INSERT INTO `herb_location` VALUES (153, 103, 117.6389190, 26.2634550, '福建省', '三明市', '三明市', 2025, '2025-07-08 16:58:43');
INSERT INTO `herb_location` VALUES (154, 107, 113.5973240, 24.8109770, '广东省', '韶关市', '韶关市', 2025, '2025-07-08 16:59:09');

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '指标得分详情表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库条目表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文献资料表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of literature
-- ----------------------------
INSERT INTO `literature` VALUES (1, 'Traditional Chinese Medicine in the treatment of COVID-19: a systematic review', 'Zhang Y, Li M, Wang H', 'Nature Medicine', 2023, NULL, 'This systematic review evaluates the efficacy of Traditional Chinese Medicine...', 'TCM, COVID-19, systematic review, herbal medicine', '中医药临床研究', 87.241, 0, NULL, 'PubMed', '2025-07-06 11:02:16');
INSERT INTO `literature` VALUES (2, 'Artificial intelligence applications in Traditional Chinese Medicine diagnosis', 'Chen L, Wu X, Liu J', 'Computers in Biology and Medicine', 2024, NULL, 'Recent advances in AI technology have opened new possibilities for TCM diagnosis...', 'AI, TCM diagnosis, machine learning, digital health', '中医信息学', 7.700, 0, NULL, 'ScienceDirect', '2025-07-06 11:02:16');
INSERT INTO `literature` VALUES (3, '中药网络药理学研究方法与应用进展', '李明,王华,陈静', '中国中药杂志', 2024, NULL, '网络药理学为中药复方作用机制研究提供了新的思路和方法...', '网络药理学,中药,作用机制,系统生物学', '中药药理学', 2.890, 0, NULL, 'CNKI', '2025-07-06 11:02:16');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sender_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `receiver_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `send_time` datetime NOT NULL,
  `read_status` tinyint NULL DEFAULT 0 COMMENT '0-未读，1-已读',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1942494057406201858 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '业绩数据表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目参与人员表' ROW_FORMAT = DYNAMIC;

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
  `achievement_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '成果类型',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '成果标题',
  `authors` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `publication` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发表期刊/出版社',
  `publish_date` date NULL DEFAULT NULL COMMENT '发表日期',
  `impact_factor` decimal(5, 3) NULL DEFAULT NULL COMMENT '影响因子',
  `citation_count` int NULL DEFAULT 0 COMMENT '引用次数',
  `doi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'DOI',
  `abstract_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '摘要',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关键词',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件地址',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_achievement_type`(`achievement_type` ASC) USING BTREE,
  INDEX `idx_publish_date`(`publish_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '科研成果表(论文、专利等)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of research_achievement
-- ----------------------------
INSERT INTO `research_achievement` VALUES (1, 1, '论文', '小青龙汤治疗过敏性鼻炎的临床研究', '张三, 李四', '中华中医药杂志', '2023-05-10', 2.150, 15, '10.1000/xyz123', '目的：探讨小青龙汤治疗过敏性鼻炎的临床疗效。方法：选取100例过敏性鼻炎患者随机分为治疗组和对照组...', '小青龙汤, 过敏性鼻炎, 临床研究', 'http://example.com/paper1.pdf', 'approved', 1, '2025-07-07 19:10:32');
INSERT INTO `research_achievement` VALUES (2, 1, '论文', '桂枝汤加减治疗体虚感冒的系统评价', '王五, 赵六', '中国中药杂志', '2022-11-20', 3.450, 45, '10.1000/abc789', '目的：系统评价桂枝汤加减治疗体虚感冒的有效性及安全性。方法：检索多个数据库，收集相关随机对照试验进行Meta分析...', '桂枝汤, 体虚感冒, Meta分析', 'http://example.com/paper2.pdf', 'approved', 1, '2025-07-07 19:10:32');
INSERT INTO `research_achievement` VALUES (3, 2, '专利', '一种从黄芪中提取多糖的新工艺', '钱七', NULL, '2024-01-15', NULL, NULL, 'CN12345678A', '本发明公开了一种从黄芪中高效提取黄芪多糖的工艺方法，包括超声辅助提取、双水相萃取纯化等步骤...', '黄芪多糖, 提取工艺, 专利', 'http://example.com/patent1.pdf', 'approved', 2, '2025-07-07 19:10:32');

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
  `abstract_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目摘要',
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关键词',
  `research_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '研究领域',
  `achievements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目成果',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pi`(`principal_investigator` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_type`(`project_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '科研项目表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学习记录表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户评价记录表' ROW_FORMAT = DYNAMIC;

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

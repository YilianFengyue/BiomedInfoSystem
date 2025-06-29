/*
 Navicat Premium Data Transfer

 Source Server         : 6
 Source Server Type    : MySQL
 Source Server Version : 80011 (8.0.11)
 Source Host           : localhost:3306
 Source Schema         : biomed_info_system

 Target Server Type    : MySQL
 Target Server Version : 80011 (8.0.11)
 File Encoding         : 65001

 Date: 29/06/2025 14:04:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for edu_categories
-- ----------------------------
DROP TABLE IF EXISTS `edu_categories`;
CREATE TABLE `edu_categories`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类主键ID',
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
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联主键ID',
  `resource_id` bigint(20) NOT NULL COMMENT '外键：教学资源ID',
  `video_id` bigint(20) NOT NULL COMMENT '外键：教学视频ID',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT '显示顺序 (用于课程章节排序)',
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
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资源主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源标题',
  `category_id` int(11) NOT NULL COMMENT '外键：关联的分类ID',
  `author_id` bigint(20) NOT NULL COMMENT '外键：作者的用户ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学资源主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_resources
-- ----------------------------
INSERT INTO `edu_resources` VALUES (2, '关于特定环境下当归成分变化的初步研究', 2, 2, NULL, '<h2>研究背景</h2><p>本研究旨在探讨不同海拔高度对当归主要有效成分含量的影响...</p>', 'draft', '2025-06-27 14:13:48', '2025-06-27 14:13:48', NULL);

-- ----------------------------
-- Table structure for edu_videos
-- ----------------------------
DROP TABLE IF EXISTS `edu_videos`;
CREATE TABLE `edu_videos`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '视频主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '视频简介',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频文件URL (来自OSS)',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频封面URL (可选)',
  `duration` int(11) NULL DEFAULT 0 COMMENT '视频时长 (单位: 秒)',
  `uploader_id` bigint(20) NOT NULL COMMENT '外键：上传者的用户ID',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uploader_id`(`uploader_id` ASC) USING BTREE,
  CONSTRAINT `fk_video_uploader_id` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学视频库' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edu_videos
-- ----------------------------

-- ----------------------------
-- Table structure for herb
-- ----------------------------
DROP TABLE IF EXISTS `herb`;
CREATE TABLE `herb`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材主信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb
-- ----------------------------
INSERT INTO `herb` VALUES (1, '人参', 'Panax ginseng', '五加科', '栽培', '多年生草本', '补气固脱，健脾益肺，宁心益智，养血生津。', '2025-06-27 13:42:19', '2025-06-28 10:16:32');
INSERT INTO `herb` VALUES (2, '枸杞', 'Lycium barbarum', '茄科', '栽培', '灌木', '滋补肝肾，益精明目。用于虚劳精亏，腰膝酸痛，眩晕耳鸣，内热消渴，血虚萎黄，目昏不明。', '2025-06-27 13:42:19', '2025-06-28 10:16:32');
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
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `location_id` bigint(20) NOT NULL COMMENT '外键：关联的观测点ID',
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
INSERT INTO `herb_growth_data` VALUES (1, 1, '预估产量', '500', '公斤', '2025-06-27 13:42:19');
INSERT INTO `herb_growth_data` VALUES (2, 1, '土壤PH值', '6.5', '', '2025-06-27 13:42:19');
INSERT INTO `herb_growth_data` VALUES (3, 2, '预估产量', '850', '公斤', '2025-06-27 13:42:19');
INSERT INTO `herb_growth_data` VALUES (4, 3, '预估产量', '12000', '公斤', '2025-06-27 13:42:19');
INSERT INTO `herb_growth_data` VALUES (5, 3, '含糖量', '22', '%', '2025-06-27 13:42:19');

-- ----------------------------
-- Table structure for herb_growth_data_history
-- ----------------------------
DROP TABLE IF EXISTS `herb_growth_data_history`;
CREATE TABLE `herb_growth_data_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '历史记录主键ID',
  `origin_id` bigint(20) NOT NULL COMMENT '原数据表的主键ID',
  `location_id` bigint(20) NOT NULL COMMENT '关联的观测点ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '生长/统计数据变更历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_growth_data_history
-- ----------------------------
INSERT INTO `herb_growth_data_history` VALUES (1, 3, 2, '预估产量', '800', '850', 'UPDATE', 'admin', '2025-06-27 13:42:19', '根据最新航拍数据修正');

-- ----------------------------
-- Table structure for herb_image
-- ----------------------------
DROP TABLE IF EXISTS `herb_image`;
CREATE TABLE `herb_image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `herb_id` bigint(20) NOT NULL COMMENT '外键：关联的药材ID',
  `location_id` bigint(20) NULL DEFAULT NULL COMMENT '【可选】外键：关联的观测点ID，用于现场实拍图',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片地址URL',
  `is_primary` tinyint(1) NULL DEFAULT 0 COMMENT '是否为主图 (0-否, 1-是)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片描述',
  `uploaded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_herb_id_image`(`herb_id` ASC) USING BTREE,
  INDEX `idx_location_id_image`(`location_id` ASC) USING BTREE,
  CONSTRAINT `fk_image_herb_id` FOREIGN KEY (`herb_id`) REFERENCES `herb` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_image_location_id` FOREIGN KEY (`location_id`) REFERENCES `herb_location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材图片表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_image
-- ----------------------------
INSERT INTO `herb_image` VALUES (1, 1, NULL, 'https://placehold.co/400x300/A8D8B9/333?text=人参标准图', 1, '人参标准形态参考图', '2025-06-27 13:42:19');
INSERT INTO `herb_image` VALUES (2, 1, NULL, 'https://placehold.co/400x300/C1E1C1/333?text=人参果实', 0, '人参的红色果实', '2025-06-27 13:42:19');
INSERT INTO `herb_image` VALUES (3, 2, NULL, 'https://placehold.co/400x300/FF7F7F/333?text=枸杞标准图', 1, '宁夏枸杞标准图', '2025-06-27 13:42:19');
INSERT INTO `herb_image` VALUES (4, 3, NULL, 'https://placehold.co/400x300/D2B48C/333?text=当归标准图', 1, '当归药材切片', '2025-06-27 13:42:19');

-- ----------------------------
-- Table structure for herb_location
-- ----------------------------
DROP TABLE IF EXISTS `herb_location`;
CREATE TABLE `herb_location`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID, 代表一次唯一的观测记录',
  `herb_id` bigint(20) NOT NULL COMMENT '外键：关联的药材ID',
  `longitude` decimal(10, 7) NOT NULL COMMENT '经度 (e.g., 116.404269)',
  `latitude` decimal(10, 7) NOT NULL COMMENT '纬度 (e.g., 39.913169)',
  `province` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址/地名',
  `observation_year` int(11) NOT NULL COMMENT '观测/采集年份',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_herb_id`(`herb_id` ASC) USING BTREE,
  INDEX `idx_province_city`(`province` ASC, `city` ASC) USING BTREE,
  CONSTRAINT `fk_location_herb_id` FOREIGN KEY (`herb_id`) REFERENCES `herb` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '药材地理分布(观测点)表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of herb_location
-- ----------------------------
INSERT INTO `herb_location` VALUES (1, 1, 126.6333300, 45.7500000, '黑龙江省', '哈尔滨市', '长白山脉周边', 2022, '2025-06-27 13:42:19');
INSERT INTO `herb_location` VALUES (2, 1, 127.9833300, 43.8833300, '吉林省', '吉林市', '集安市山区', 2023, '2025-06-27 13:42:19');
INSERT INTO `herb_location` VALUES (3, 2, 106.2781800, 38.4681400, '宁夏回族自治区', '银川市', '中宁县枸杞种植基地', 2023, '2025-06-27 13:42:19');
INSERT INTO `herb_location` VALUES (4, 2, 104.0666700, 30.6666700, '四川省', '成都市', '成都中医药大学植物园', 2022, '2025-06-27 13:42:19');
INSERT INTO `herb_location` VALUES (5, 3, 94.7662000, 31.4988000, '西藏自治区', '昌都市', '类乌齐县', 2023, '2025-06-27 13:42:19');

-- ----------------------------
-- Table structure for user_profiles
-- ----------------------------
DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID, 外键关联users.id',
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
INSERT INTO `user_profiles` VALUES (101, '王老师', 'https://placehold.co/100x100/A8D8B9/333?text=W', 'unknown', '资深中医药学教师');
INSERT INTO `user_profiles` VALUES (105, 'testuser03', 'https://pixabay.com/zh/photos/mountain-mountian-climbing-sunrise-7704817', 'male', NULL);
INSERT INTO `user_profiles` VALUES (106, 'testuser04', 'https://pixabay.com/zh/photos/mountain-mountian-climbing-sunrise-7704819', 'unknown', NULL);
INSERT INTO `user_profiles` VALUES (107, NULL, NULL, 'male', NULL);
INSERT INTO `user_profiles` VALUES (108, 'testuser07', NULL, 'unknown', NULL);

-- ----------------------------
-- Table structure for user_third_party_auths
-- ----------------------------
DROP TABLE IF EXISTS `user_third_party_auths`;
CREATE TABLE `user_third_party_auths`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'github',
  `provider_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `1`(`user_id` ASC) USING BTREE,
  CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_third_party_auths
-- ----------------------------
INSERT INTO `user_third_party_auths` VALUES (1, 107, 'github', '150018177');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户主键ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `role` tinyint(1) NOT NULL DEFAULT 1 COMMENT '角色 (e.g., student 1, teacher 2, admin 0 )',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '加盐哈希后的密码',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '账户状态 (1-正常, 2-禁用)',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表 (简化版)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 0, '2025-06-27 14:30:15', '...hashed_password_for_admin...', 1, '2025-06-28 15:28:02');
INSERT INTO `users` VALUES (2, '李同学', 1, '2025-06-27 14:13:48', '', 1, '2025-06-28 15:28:03');
INSERT INTO `users` VALUES (101, '王老师', 2, '2025-06-27 14:28:30', '...hashed_password_for_teacher...', 1, '2025-06-28 15:28:05');
INSERT INTO `users` VALUES (103, 'testuser01', 1, '2025-06-28 20:51:08', '$2a$12$FrToJZ51IdXJL5JSVm6ulOCZfaNcmknRC58VXsOlrdq7jGaINUrs2', 1, '2025-06-28 20:51:08');
INSERT INTO `users` VALUES (105, 'testuser03', 1, '2025-06-28 21:24:41', '$2a$12$zyxYOHg0x.VwkxOZP2P8jOaS5mFDgfq9wKP3oZiJ/F4vjU/TmF10S', 1, '2025-06-28 22:47:58');
INSERT INTO `users` VALUES (106, 'testuser04', 1, '2025-06-29 09:51:43', '$2a$10$lSdAYcYuKA0HlzAYK2565Olu8PBGFcTV3NDqEc8rcGH4O8NrzRtua', 1, '2025-06-29 09:51:43');
INSERT INTO `users` VALUES (107, 'github_ewewrttt', 1, '2025-06-29 09:59:11', '$2a$10$SBPmHsNN82RjQiSYdjfTfu4PCUQnKXgueJDj5vUR4da2390bjHMCS', 1, '2025-06-29 11:09:56');
INSERT INTO `users` VALUES (108, 'testuser07', 1, '2025-06-29 13:39:47', '$2a$10$yzXgHiWeastVASI5sKvc7.MxwlA7E7l6Sa1iUo7rMNst1bceHIoP2', 1, '2025-06-29 13:39:47');

SET FOREIGN_KEY_CHECKS = 1;

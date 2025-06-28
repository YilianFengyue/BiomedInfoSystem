package org.csu.dao;

import org.csu.domain.UserProfiles;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 用户信息表 Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface UserProfilesDao extends BaseMapper<UserProfiles> {

}


package org.csu.dao;

import org.csu.domain.Users;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 用户表 (简化版) Mapper 接口
 * </p>
 *
 * @author YinBo
 * @since 2025-06-28
 */
@Mapper
public interface UsersDao extends BaseMapper<Users> {

}


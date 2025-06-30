package org.csu.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.csu.domain.EduResources;
import org.csu.domain.UserProfiles;
import org.csu.dto.EduResourcesDto;
import org.csu.service.IEduResourcesService;
import org.csu.service.IUserProfilesService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 教学资源控制器
 * @author Gemini
 */
@RestController
@RequestMapping("/edu")
@CrossOrigin(origins = "*") // 允许跨域请求
public class EduController {

    @Autowired
    private IEduResourcesService eduResourcesService;

    // 新增：注入UserProfilesService以获取作者信息
    @Autowired
    private IUserProfilesService userProfilesService;

    /**
     * 获取所有教学资源列表
     * @return 包含所有教学资源的列表
     */
    @GetMapping("/resources")
    public Result<List<EduResources>> getAllResources() {
        List<EduResources> resources = eduResourcesService.list();
        return Result.success(resources);
    }

    /**
     * 分页查询教学资源列表（包含作者姓名）
     * @param pageNum  当前页码，默认为1
     * @param pageSize 每页数量，默认为10
     * @return 分页的教学资源列表
     */
    @GetMapping("/resources/page")
    public Result<IPage<EduResourcesDto>> getResourcesByPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        // 1. 创建DTO的分页对象
        Page<EduResourcesDto> page = new Page<>(pageNum, pageSize);

        // 2. 执行自定义的分页查询
        IPage<EduResourcesDto> resourcePage = eduResourcesService.getResourcesWithAuthorByPage(page);

        // 3. 返回结果
        return Result.success(resourcePage);
    }

    /**
     * ↓↓↓↓ 新增的方法 ↓↓↓↓
     * 根据ID获取单个教学资源详情（包含作者姓名）
     * @param id 资源ID
     * @return 包含详细信息和作者姓名的资源对象
     */
    @GetMapping("/resources/{id}")
    public Result<EduResourcesDto> getResourceById(@PathVariable Long id) {
        // 1. 获取主资源信息
        EduResources resource = eduResourcesService.getById(id);
        if (resource == null) {
            return Result.error(Code.GET_ERR, "未找到ID为 " + id + " 的教学资源");
        }

        // 2. 创建DTO并复制基础属性
        EduResourcesDto dto = new EduResourcesDto();
        BeanUtils.copyProperties(resource, dto);

        // 3. 查询并设置作者姓名
        if (resource.getAuthorId() != null) {
            UserProfiles authorProfile = userProfilesService.getById(resource.getAuthorId());
            if (authorProfile != null && authorProfile.getNickname() != null) {
                dto.setAuthorName(authorProfile.getNickname());
            } else {
                dto.setAuthorName("匿名作者"); // 如果找不到作者信息，提供一个默认值
            }
        }

        // 4. 返回成功的响应
        return Result.success(dto);
    }
}
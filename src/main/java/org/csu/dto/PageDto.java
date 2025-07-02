package org.csu.dto;

import lombok.Data;
import org.springframework.data.domain.Page;
import java.util.List;

/**
 * 自定义的分页数据传输对象 (DTO)，用于提供稳定的JSON结构
 * @param <T> 分页内容的类型
 */
@Data
public class PageDto<T> {
    private List<T> content;      // 当前页的数据列表
    private int pageNumber;       // 当前页码 (从0开始)
    private int pageSize;         // 每页大小
    private long totalElements;   // 总记录数
    private int totalPages;       // 总页数
    private boolean last;         // 是否为最后一页
    private boolean first;        // 是否为第一页

    /**
     * 用于从Spring Data的Page对象转换的构造函数
     * @param springPage Spring Data的Page对象
     */
    public PageDto(Page<T> springPage) {
        this.content = springPage.getContent();
        this.pageNumber = springPage.getNumber();
        this.pageSize = springPage.getSize();
        this.totalElements = springPage.getTotalElements();
        this.totalPages = springPage.getTotalPages();
        this.last = springPage.isLast();
        this.first = springPage.isFirst();
    }

    // 为JSON序列化提供默认构造函数
    public PageDto() {}
}
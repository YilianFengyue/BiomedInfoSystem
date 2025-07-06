package org.csu.domain.node;


import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;

@Node("Acupoint")
@Setter
@Getter
public class AcupointNode {
    @Id @GeneratedValue
    private Long id;
    private String name;     // 穴位名称 (如：中府)
    private String code;     // 穴位代码 (如：LU1)
    private String location; // 定位
    private String function; // 主治功能
}

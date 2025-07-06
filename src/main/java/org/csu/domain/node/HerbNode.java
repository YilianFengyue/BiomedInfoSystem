package org.csu.domain.node;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Relationship;
import java.util.Set;

@Node("Herb")
@Setter
@Getter
public class HerbNode {
    @Id @GeneratedValue
    private Long id;
    private String name;        // 药材名称
    private String pinyin;      // 拼音
    private String alias;       // 别名
    private String nature;      // 性味
    private String effect;      // 功效
    private String usage;       // 用法用量
    private String taboo;       // 禁忌

    // 关系：药材 -> 治疗 -> 疾病
    @Relationship(type = "TREATS", direction = Relationship.Direction.OUTGOING)
    private Set<DiseaseNode> treatedDiseases;

    // 关系：药材 -> 归经于 -> 经络 (优化点)
    @Relationship(type = "BELONGS_TO_MERIDIAN", direction = Relationship.Direction.OUTGOING)
    private Set<MeridianNode> meridians;
}
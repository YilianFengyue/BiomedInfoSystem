package org.csu.domain.node;

import lombok.Getter;
import lombok.Setter;
import org.csu.domain.relationship.HerbComponent;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Relationship;
import java.util.Set;

@Node("Formula")
@Setter
@Getter
public class FormulaNode {
    @Id @GeneratedValue
    private Long id;
    private String name;        // 方剂名称
    private String source;      // 出处
    private String composition; // 组成原文
    private String usage;       // 用法
    private String function;    // 功用
    private String indication;  // 主治

    // 关系：方剂 -> 包含 -> 药材 (通过关系实体HerbComponent)
    @Relationship(type = "CONTAINS", direction = Relationship.Direction.OUTGOING)
    private Set<HerbComponent> herbComponents;

    // 关系：方剂 -> 治疗 -> 疾病
    @Relationship(type = "TREATS_DISEASE", direction = Relationship.Direction.OUTGOING)
    private Set<DiseaseNode> treatedDiseases;

    // 关系：方剂 -> 治疗 -> 证候
    @Relationship(type = "TREATS_SYNDROME", direction = Relationship.Direction.OUTGOING)
    private Set<SyndromeNode> treatedSyndromes;
}

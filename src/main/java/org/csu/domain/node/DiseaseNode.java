package org.csu.domain.node;


import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Relationship;
import java.util.Set;

@Node("Disease")
@Setter
@Getter
public class DiseaseNode {
    @Id @GeneratedValue
    private Long id;
    private String name;        // 疾病名称
    private String description; // 描述

    // 关系：疾病 -> 表现为 -> 症状
    @Relationship(type = "HAS_SYMPTOM", direction = Relationship.Direction.OUTGOING)
    private Set<SymptomNode> symptoms;

    // 关系：疾病 -> 包含 -> 证候
    @Relationship(type = "HAS_SYNDROME", direction = Relationship.Direction.OUTGOING)
    private Set<SyndromeNode> syndromes;
}

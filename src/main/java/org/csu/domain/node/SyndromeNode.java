package org.csu.domain.node;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Relationship;
import java.util.Set;

@Node("Syndrome")
@Setter
@Getter
public class SyndromeNode {
    @Id @GeneratedValue
    private Long id;
    private String name;        // 证候名称
    private String analysis;    // 证候分析
    private String description;

    // 关系：证候 -> 表现为 -> 症状
    @Relationship(type = "HAS_SYMPTOM", direction = Relationship.Direction.OUTGOING)
    private Set<SymptomNode> symptoms;
}

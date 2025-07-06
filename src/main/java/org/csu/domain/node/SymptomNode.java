package org.csu.domain.node;


import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;

@Node("Symptom")
@Setter
@Getter
public class SymptomNode {
    @Id @GeneratedValue
    private Long id;
    private String name;        // 症状名称
    private String description; // 症状描述
}

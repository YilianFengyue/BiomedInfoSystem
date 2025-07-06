package org.csu.domain.relationship;

import lombok.Getter;
import org.csu.domain.node.HerbNode;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.RelationshipProperties;
import org.springframework.data.neo4j.core.schema.TargetNode;

@Getter
@RelationshipProperties
public class HerbComponent {
    // Getters
    @Id @GeneratedValue
    private Long id;

    private String dosage; // 用量 (e.g., "9g")
    private String role;   // 角色 (e.g., "君药")

    @TargetNode
    private final HerbNode herb; // 关系指向的药材节点

    public HerbComponent(HerbNode herb, String dosage, String role) {
        this.herb = herb;
        this.dosage = dosage;
        this.role = role;
    }

}
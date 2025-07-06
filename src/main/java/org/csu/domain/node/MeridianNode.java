package org.csu.domain.node;


import lombok.Getter;
import lombok.Setter;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Relationship;
import java.util.Set;

@Node("Meridian")
@Setter
@Getter
public class MeridianNode {
    @Id @GeneratedValue
    private Long id;
    private String name; // 经络名称 (如：手太阴肺经)

    // 关系：经络 -> 包含 -> 穴位
    @Relationship(type = "HAS_ACUPOINT", direction = Relationship.Direction.OUTGOING)
    private Set<AcupointNode> acupoints;
}

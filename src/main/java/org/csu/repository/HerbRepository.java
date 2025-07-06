package org.csu.repository;

import org.csu.domain.node.HerbNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;

import java.util.Optional;

public interface HerbRepository extends Neo4jRepository<HerbNode, Long> {
    // Spring Data会根据方法名自动生成查询
    Optional<HerbNode> findByName(String name);
}

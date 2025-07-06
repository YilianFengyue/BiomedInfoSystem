package org.csu.repository;

import org.csu.domain.node.SymptomNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 症状实体的Neo4j仓库接口
 */
@Repository
public interface SymptomRepository extends Neo4jRepository<SymptomNode, Long> {

    /**
     * 根据名称精确查找症状
     *
     * @param name 症状名称
     * @return 包含症状实体的Optional
     */
    Optional<SymptomNode> findByName(String name);
}
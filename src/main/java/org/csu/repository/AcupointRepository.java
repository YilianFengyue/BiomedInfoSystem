package org.csu.repository;

import org.csu.domain.node.AcupointNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 穴位实体的Neo4j仓库接口
 */
@Repository
public interface AcupointRepository extends Neo4jRepository<AcupointNode, Long> {

    /**
     * 根据名称精确查找穴位
     *
     * @param name 穴位名称
     * @return 包含穴位实体的Optional
     */
    Optional<AcupointNode> findByName(String name);

    /**
     * 根据国际代码精确查找穴位
     *
     * @param code 穴位代码 (如: LU1)
     * @return 包含穴位实体的Optional
     */
    Optional<AcupointNode> findByCode(String code);
}
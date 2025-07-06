package org.csu.repository;

import org.csu.domain.node.SyndromeNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 证候实体的Neo4j仓库接口
 */
@Repository
public interface SyndromeRepository extends Neo4jRepository<SyndromeNode, Long> {

    Optional<SyndromeNode> findByName(String name);
    List<SyndromeNode> findBySymptomsName(String symptomName);
}
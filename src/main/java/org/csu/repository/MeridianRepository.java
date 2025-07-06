package org.csu.repository;

import org.csu.domain.node.MeridianNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 经络实体的Neo4j仓库接口
 */
@Repository
public interface MeridianRepository extends Neo4jRepository<MeridianNode, Long> {

    Optional<MeridianNode> findByName(String name);
    List<MeridianNode> findByAcupointsName(String acupointName);
}
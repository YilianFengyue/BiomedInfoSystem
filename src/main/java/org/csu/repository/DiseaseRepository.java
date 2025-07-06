package org.csu.repository;

import org.csu.domain.node.DiseaseNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface DiseaseRepository extends Neo4jRepository<DiseaseNode, Long> {
    Optional<DiseaseNode> findByName(String name);
    List<DiseaseNode> findBySymptomsName(String symptomName);
    List<DiseaseNode> findBySyndromesName(String syndromeName);
}
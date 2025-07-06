package org.csu.repository;

import org.csu.domain.node.FormulaNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;

import java.util.List;
import java.util.Optional;

public interface FormulaRepository extends Neo4jRepository<FormulaNode, Long> {
    Optional<FormulaNode> findByName(String name);
    List<FormulaNode> findByTreatedDiseasesName(String diseaseName);
    List<FormulaNode> findByTreatedSyndromesName(String syndromeName);
    @Query("MATCH (f:Formula)-[:CONTAINS]->(hc:HerbComponent) WHERE hc.herb.name = $herbName RETURN f")
    List<FormulaNode> findByHerbComponentsHerbName(String herbName);
}

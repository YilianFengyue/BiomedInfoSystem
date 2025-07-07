package org.csu.repository;

import org.csu.domain.node.FormulaNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FormulaRepository extends Neo4jRepository<FormulaNode, Long> {

    /**
     * 深度获取：根据名称查找方剂及其所有一级关联
     */
    @Query("MATCH (f:Formula {name: $name}) " +
            "OPTIONAL MATCH (f)-[r_c:CONTAINS]->(h:Herb) " +
            "OPTIONAL MATCH (f)-[r_d:TREATS_DISEASE]->(d:Disease) " +
            "OPTIONAL MATCH (f)-[r_s:TREATS_SYNDROME]->(s:Syndrome) " +
            "RETURN f, collect(r_c), collect(h), collect(r_d), collect(d), collect(r_s), collect(s)")
    Optional<FormulaNode> findByName(String name);

    /**
     * 深度获取：根据治疗的疾病名称，查找所有相关方剂
     */
    @Query("MATCH (d:Disease {name: $diseaseName})<-[:TREATS_DISEASE]-(f:Formula) " +
            "OPTIONAL MATCH (f)-[r_c:CONTAINS]->(h:Herb) " +
            "OPTIONAL MATCH (f)-[r_d:TREATS_DISEASE]->(d2:Disease) " +
            "OPTIONAL MATCH (f)-[r_s:TREATS_SYNDROME]->(s:Syndrome) " +
            "RETURN f, collect(r_c), collect(h), collect(r_d), collect(d2), collect(r_s), collect(s)")
    List<FormulaNode> findByTreatedDiseasesName(String diseaseName);

    /**
     * 深度获取：根据治疗的证候名称，查找所有相关方剂
     */
    @Query("MATCH (s:Syndrome {name: $syndromeName})<-[:TREATS_SYNDROME]-(f:Formula) " +
            "OPTIONAL MATCH (f)-[r_c:CONTAINS]->(h:Herb) " +
            "OPTIONAL MATCH (f)-[r_d:TREATS_DISEASE]->(d:Disease) " +
            "OPTIONAL MATCH (f)-[r_s:TREATS_SYNDROME]->(s2:Syndrome) " +
            "RETURN f, collect(r_c), collect(h), collect(r_d), collect(d), collect(r_s), collect(s2)")
    List<FormulaNode> findByTreatedSyndromesName(String syndromeName);

    /**
     * 深度获取：根据包含的药材名称，查找所有相关方剂
     */
    @Query("MATCH (h:Herb {name: $herbName})<-[:CONTAINS]-(f:Formula) " +
            "OPTIONAL MATCH (f)-[r_c:CONTAINS]->(h2:Herb) " +
            "OPTIONAL MATCH (f)-[r_d:TREATS_DISEASE]->(d:Disease) " +
            "OPTIONAL MATCH (f)-[r_s:TREATS_SYNDROME]->(s:Syndrome) " +
            "RETURN f, collect(r_c), collect(h2), collect(r_d), collect(d), collect(r_s), collect(s)")
    List<FormulaNode> findByHerbName(String herbName);
}
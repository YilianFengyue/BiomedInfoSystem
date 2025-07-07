package org.csu.repository;

import org.csu.domain.node.DiseaseNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DiseaseRepository extends Neo4jRepository<DiseaseNode, Long> {

    @Query("MATCH (d:Disease {name: $name}) " +
            "OPTIONAL MATCH (d)-[r_s:HAS_SYMPTOM]->(s:Symptom) " +
            "OPTIONAL MATCH (d)-[r_sy:HAS_SYNDROME]->(sy:Syndrome) " +
            "RETURN d, collect(r_s), collect(s), collect(r_sy), collect(sy)")
    Optional<DiseaseNode> findByName(String name);

    @Query("MATCH (s:Symptom {name: $symptomName})<-[:HAS_SYMPTOM]-(d:Disease) " +
            "OPTIONAL MATCH (d)-[r_s:HAS_SYMPTOM]->(s2:Symptom) " +
            "OPTIONAL MATCH (d)-[r_sy:HAS_SYNDROME]->(sy:Syndrome) " +
            "RETURN d, collect(r_s), collect(s2), collect(r_sy), collect(sy)")
    List<DiseaseNode> findBySymptomsName(String symptomName);

    @Query("MATCH (sy:Syndrome {name: $syndromeName})<-[:HAS_SYNDROME]-(d:Disease) " +
            "OPTIONAL MATCH (d)-[r_s:HAS_SYMPTOM]->(s:Symptom) " +
            "OPTIONAL MATCH (d)-[r_sy:HAS_SYNDROME]->(sy2:Syndrome) " +
            "RETURN d, collect(r_s), collect(s), collect(r_sy), collect(sy2)")
    List<DiseaseNode> findBySyndromesName(String syndromeName);
}
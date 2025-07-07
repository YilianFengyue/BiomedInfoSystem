package org.csu.repository;

import org.csu.domain.node.SyndromeNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SyndromeRepository extends Neo4jRepository<SyndromeNode, Long> {

    @Query("MATCH (sy:Syndrome {name: $name}) " +
            "OPTIONAL MATCH (sy)-[r_s:HAS_SYMPTOM]->(s:Symptom) " +
            "RETURN sy, collect(r_s), collect(s)")
    Optional<SyndromeNode> findByName(String name);

    @Query("MATCH (s:Symptom {name: $symptomName})<-[:HAS_SYMPTOM]-(sy:Syndrome) " +
            "OPTIONAL MATCH (sy)-[r_s:HAS_SYMPTOM]->(s2:Symptom) " +
            "RETURN sy, collect(r_s), collect(s2)")
    List<SyndromeNode> findBySymptomsName(String symptomName);
}
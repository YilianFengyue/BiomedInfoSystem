package org.csu.repository;

import org.csu.domain.node.HerbNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface HerbRepository extends Neo4jRepository<HerbNode, Long> {

    @Query("MATCH (h:Herb {name: $name}) " +
            "OPTIONAL MATCH (h)-[r_d:TREATS]->(d:Disease) " +
            "OPTIONAL MATCH (h)-[r_m:BELONGS_TO_MERIDIAN]->(m:Meridian) " +
            "RETURN h, collect(r_d), collect(d), collect(r_m), collect(m)")
    Optional<HerbNode> findByName(String name);

    @Query("MATCH (m:Meridian {name: $meridianName})<-[:BELONGS_TO_MERIDIAN]-(h:Herb) " +
            "OPTIONAL MATCH (h)-[r_d:TREATS]->(d:Disease) " +
            "OPTIONAL MATCH (h)-[r_m:BELONGS_TO_MERIDIAN]->(m2:Meridian) " +
            "RETURN h, collect(r_d), collect(d), collect(r_m), collect(m2)")
    List<HerbNode> findByMeridiansName(String meridianName);
}
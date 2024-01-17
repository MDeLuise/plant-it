package com.github.mdeluise.plantit.botanicalinfo;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BotanicalInfoRepository extends JpaRepository<BotanicalInfo, Long> {

    List<BotanicalInfo> findByScientificNameContainsIgnoreCase(String partialScientificName);

    @Query("SELECT b FROM BotanicalInfo b JOIN b.synonyms s WHERE LOWER(s) LIKE LOWER(:synonym)")
    List<BotanicalInfo> findBySynonymsContainsIgnoreCase(@Param("synonym") String synonym);

    default List<BotanicalInfo> getByScientificNameOrSynonym(String search) {
        final Set<BotanicalInfo> result = new HashSet<>();
        result.addAll(findByScientificNameContainsIgnoreCase(search));
        result.addAll(findBySynonymsContainsIgnoreCase(search));
        return result.stream().toList();
    }

    List<BotanicalInfo> findAll();

    List<BotanicalInfo> findAllBySpecies(String species);

    List<BotanicalInfo> findAllByCreatorAndExternalId(BotanicalInfoCreator creator, String externalId);
}

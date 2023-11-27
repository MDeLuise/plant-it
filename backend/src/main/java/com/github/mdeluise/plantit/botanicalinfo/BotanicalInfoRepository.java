package com.github.mdeluise.plantit.botanicalinfo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface BotanicalInfoRepository extends JpaRepository<BotanicalInfo, Long> {

    List<BotanicalInfo> findByScientificNameContainsIgnoreCase(String partialScientificName);

    List<BotanicalInfo> findAll();

    List<BotanicalInfo> findAllBySpecies(String species);

    List<BotanicalInfo> findAllByCreatorAndExternalId(BotanicalInfoCreator creator, String externalId);
}

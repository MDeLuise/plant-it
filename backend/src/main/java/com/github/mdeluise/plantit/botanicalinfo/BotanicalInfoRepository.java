package com.github.mdeluise.plantit.botanicalinfo;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BotanicalInfoRepository extends JpaRepository<BotanicalInfo, Long> {
    Optional<BotanicalInfo> findByScientificName(String scientificName);

    List<BotanicalInfo> findByScientificNameContainsIgnoreCase(String partialScientificName);

    List<BotanicalInfo> findAll();
}

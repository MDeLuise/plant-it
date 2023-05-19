package com.github.mdeluise.plantit.botanicalinfo;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BotanicalInfoRepository extends JpaRepository<BotanicalInfo, Long> {
    Optional<BotanicalInfo> findByScientificName(String scientificName);

    Page<BotanicalInfo> findByScientificNameContainsIgnoreCase(String partialScientificName, Pageable pageable);
}

package com.github.mdeluise.plantit.botanicalinfo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface BotanicalInfoRepository extends JpaRepository<BotanicalInfo, Long> {

    List<BotanicalInfo> findByScientificNameContainsIgnoreCase(String partialScientificName);

    List<BotanicalInfo> findAll();

    Optional<BotanicalInfo> findByScientificNameAndFamilyAndGenusAndSpecies(String scientificName, String family,
                                                                            String genus, String species);

    List<BotanicalInfo> findAllBySpecies(String species);
}

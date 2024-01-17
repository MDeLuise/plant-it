package com.github.mdeluise.plantit.plantinfo.trafle;

import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoRepository;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * This class is used to add new info in the existing species on system version update.
 * v0.1.0: Botanical Info object has new `external_id` field.
 * v0.2.0: Botanical Info object has new `PlantCareInfo` field.
 * v0.2.0: Botanical Info object has new `synonyms` field.
 */
@Service
public class TrefleMigrator {
    private final TrefleRequestMaker trefleRequestMaker;
    private final BotanicalInfoRepository botanicalInfoRepository;
    private final Logger logger = LoggerFactory.getLogger(TrefleMigrator.class);


    @Autowired
    public TrefleMigrator(TrefleRequestMaker trefleRequestMaker, BotanicalInfoRepository botanicalInfoRepository) {
        this.trefleRequestMaker = trefleRequestMaker;
        this.botanicalInfoRepository = botanicalInfoRepository;
    }


    public void fillMissingExternalInfo() {
        botanicalInfoRepository.findAll().forEach(botanicalInfo -> {
            logger.info(String.format("Checking update for species %s (id %s, creator: %s, external_id: %s)...",
                                      botanicalInfo.getSpecies(), botanicalInfo.getId(), botanicalInfo.getCreator(),
                                      botanicalInfo.getExternalId()
            ));
            if (botanicalInfo.getCreator() != BotanicalInfoCreator.TREFLE) {
                logger.info("Species already updated since it's a user created one.");
                return;
            }
            if (botanicalInfo.getExternalId() == null) {
                logger.info("external_id field not present, updating it...");
                fillMissingExternalId(botanicalInfo);
            }
            if (botanicalInfo.getExternalId() != null && botanicalInfo.isPlantCareEmpty()) {
                logger.info("external_id field found, updating care info...");
                fillMissingExternalCareInfo(botanicalInfo);
            } else if (botanicalInfo.getExternalId() != null && botanicalInfo.getSynonyms().isEmpty()) {
                logger.info("external_id field found, updating synonyms...");
                fillMissingExternalSynonyms(botanicalInfo);
            } else if (botanicalInfo.getExternalId() == null) {
                logger.info("external_id field not found.");
            } else {
                logger.info("external_id field found, care info already updated.");
            }
            botanicalInfoRepository.save(botanicalInfo);
        });
    }


    private void fillMissingExternalId(BotanicalInfo toUpdate) {
        final String externalId = trefleRequestMaker.getExternalId(toUpdate.getSpecies());
        if (externalId == null) {
            return;
        }
        logger.info(String.format("Found external_id %s for species %s (id: %s). Update...", externalId,
                                  toUpdate.getSpecies(), toUpdate.getId()
        ));
        toUpdate.setExternalId(externalId);
    }

    private void fillMissingExternalCareInfo(BotanicalInfo toUpdate) {
        if (toUpdate.getExternalId() == null) {
            return;
        }
        final PlantCareInfo plantCareInfo = trefleRequestMaker.getPlantCare(toUpdate);
        toUpdate.setPlantCareInfo(plantCareInfo);
    }


    private void fillMissingExternalSynonyms(BotanicalInfo toUpdate) {
        if (toUpdate.getExternalId() == null) {
            return;
        }
        final Set<String> synonyms = trefleRequestMaker.getSynonyms(toUpdate);
        toUpdate.setSynonyms(synonyms);
    }
}

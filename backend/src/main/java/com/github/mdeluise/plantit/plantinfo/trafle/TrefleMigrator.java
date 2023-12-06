package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * This class is used only in the version 0.1.0 of the system, and can be removed after that.
 * Botanical Info object from the version 0.1.0 has a new `external_id` field. This field is the
 * `id` of the species in the Trefle REST API.
 * This class is used to fill that field in the already saved species.
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


    public void fillMissingExternalIds() {
        botanicalInfoRepository.findAll().forEach(botanicalInfo -> {
            if (botanicalInfo.getCreator() != BotanicalInfoCreator.TREFLE || botanicalInfo.getExternalId() != null) {
                logger.info(String.format("Species %s (id: %s) already updated (creator: %s, external_id: %s)",
                                          botanicalInfo.getSpecies(), botanicalInfo.getId(), botanicalInfo.getCreator(),
                                          botanicalInfo.getExternalId()));
                return;
            }
            logger.info(String.format("Species %s (id: %s) to update (creator: %s, external_id: %s)",
                                      botanicalInfo.getSpecies(), botanicalInfo.getId(), botanicalInfo.getCreator(),
                                      botanicalInfo.getExternalId()
            ));
            fillMissingExternalId(botanicalInfo);
        });
    }


    private void fillMissingExternalId(BotanicalInfo botanicalInfo) {
        final String externalId = trefleRequestMaker.getExternalId(botanicalInfo.getSpecies());
        if (externalId == null) {
            return;
        }
        logger.info(String.format("Found external_id %s for species %s (id: %s). Update...", externalId,
                                  botanicalInfo.getSpecies(), botanicalInfo.getId()
        ));
        botanicalInfo.setExternalId(externalId);
        botanicalInfoRepository.save(botanicalInfo);
    }
}

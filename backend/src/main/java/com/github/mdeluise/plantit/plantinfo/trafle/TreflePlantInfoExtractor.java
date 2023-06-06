package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.Optional;

// TODO cached all?
@Component
public class TreflePlantInfoExtractor implements PlantInfoExtractor {
    private final TrefleRequestMaker trefleRequestMaker;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public TreflePlantInfoExtractor(TrefleRequestMaker trefleRequestMaker, BotanicalInfoService botanicalInfoService) {
        this.trefleRequestMaker = trefleRequestMaker;
        this.botanicalInfoService = botanicalInfoService;
    }


    @Override
    @Cacheable(value = "info", key = "#plantScientificName")
    public Optional<BotanicalInfo> extractInfo(String plantScientificName) {
        final Optional<BotanicalInfo> existingInfo = botanicalInfoService.getByScientificName(plantScientificName);
        if (existingInfo.isPresent()) {
            return existingInfo;
        } else {
            return trefleRequestMaker.fetchInfo(plantScientificName);
        }
    }


    @Override
    public Page<BotanicalInfo> extractPlants(String partialPlantScientificName, Pageable pageable) {
        final Page<BotanicalInfo> existingInfo =
            botanicalInfoService.getByPartialScientificName(partialPlantScientificName, pageable);
        if (existingInfo.hasContent()) {
            return existingInfo;
        }

        final Page<BotanicalInfo> fetchedInfo =
            trefleRequestMaker.fetchInfoFromPartial(partialPlantScientificName, pageable);
        return fetchedInfo;
    }


    @Override
    public Page<BotanicalInfo> getAll(Pageable pageable) {
        return trefleRequestMaker.fetchAll(pageable);
    }
}

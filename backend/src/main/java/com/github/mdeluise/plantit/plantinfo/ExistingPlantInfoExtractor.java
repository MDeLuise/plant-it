package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class ExistingPlantInfoExtractor implements PlantInfoExtractor {
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public ExistingPlantInfoExtractor(BotanicalInfoService botanicalInfoService) {
        this.botanicalInfoService = botanicalInfoService;
    }


    @Override
    public Optional<BotanicalInfo> extractInfo(String plantScientificName) {
        return botanicalInfoService.getByScientificName(plantScientificName);
    }


    @Override
    public Page<BotanicalInfo> extractPlants(String partialPlantScientificName, Pageable pageable) {
        return botanicalInfoService.getByPartialScientificName(partialPlantScientificName, pageable);
    }


    @Override
    public Page<BotanicalInfo> getAll(Pageable pageable) {
        return botanicalInfoService.getAll(pageable);
    }
}

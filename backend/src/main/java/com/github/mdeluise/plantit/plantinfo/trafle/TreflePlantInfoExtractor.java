package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class TreflePlantInfoExtractor implements PlantInfoExtractor {
    private final TrefleRequestMaker trefleRequestMaker;


    @Autowired
    public TreflePlantInfoExtractor(TrefleRequestMaker trefleRequestMaker) {
        this.trefleRequestMaker = trefleRequestMaker;
    }


    @Override
    @Cacheable(value = "info", key = "#plantScientificName")
    public Optional<BotanicalInfo> extractInfo(String plantScientificName) {
        return trefleRequestMaker.fetchInfo(plantScientificName);
    }


    @Override
    @Cacheable(value = "info", key = "{#partialPlantScientificName, #pageable}")
    public Page<BotanicalInfo> extractPlants(String partialPlantScientificName, Pageable pageable) {
        return trefleRequestMaker.fetchInfoFromPartial(partialPlantScientificName, pageable);
    }


    @Override
    @Cacheable(value = "info", key = "#pageable")
    public Page<BotanicalInfo> getAll(Pageable pageable) {
        return trefleRequestMaker.fetchAll(pageable);
    }
}

package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.tracked.plant.Plant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PlantInfoFiller {
    private final PlantInfoExtractor plantInfoExtractor;


    @Autowired
    public PlantInfoFiller(PlantInfoExtractor plantInfoExtractor) {
        this.plantInfoExtractor = plantInfoExtractor;
    }


    public Plant fillInfo(Plant toFill) {
        toFill.setBotanicalInfo(plantInfoExtractor.extractInfo(toFill.getPersonalName())
                                                  .orElse(toFill.getBotanicalInfo()));
        return toFill;
    }
}

package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.plantinfo.local.LocalPlantInfoExtractor;
import com.github.mdeluise.plantit.plantinfo.trafle.TreflePlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class PlantInfoExtractorFactory {
    private final LocalPlantInfoExtractor localPlantInfoExtractor;


    @Autowired
    public PlantInfoExtractorFactory(@Value("${trefle.key}") String trefleKey,
                                     TreflePlantInfoExtractor treflePlantInfoExtractor,
                                     LocalPlantInfoExtractor localPlantInfoExtractor) {
        this.localPlantInfoExtractor = localPlantInfoExtractor;
        if (trefleKey != null) {
            localPlantInfoExtractor.setNext(treflePlantInfoExtractor);
        }
    }


    public AbstractPlantInfoExtractor getPlantInfoExtractor() {
        return localPlantInfoExtractor;
    }
}

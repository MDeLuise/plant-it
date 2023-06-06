package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.plantinfo.trafle.TreflePlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class PlantInfoExtractorFactory {
    private final String trefleKey;
    private final TreflePlantInfoExtractor treflePlantInfoExtractor;
    private final ExistingPlantInfoExtractor existingPlantInfoExtractor;


    @Autowired
    public PlantInfoExtractorFactory(@Value("${trefle.key}") String trefleKey,
                                     TreflePlantInfoExtractor treflePlantInfoExtractor,
                                     ExistingPlantInfoExtractor existingPlantInfoExtractor) {
        this.trefleKey = trefleKey;
        this.treflePlantInfoExtractor = treflePlantInfoExtractor;
        this.existingPlantInfoExtractor = existingPlantInfoExtractor;
    }


    public PlantInfoExtractor getPlantInfoExtractor() {
        return trefleKey == null || trefleKey.isBlank() ? existingPlantInfoExtractor : treflePlantInfoExtractor;
    }
}

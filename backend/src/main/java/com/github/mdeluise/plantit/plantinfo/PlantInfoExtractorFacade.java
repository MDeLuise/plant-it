package com.github.mdeluise.plantit.plantinfo;

import java.util.List;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.plantinfo.trafle.TreflePlantInfoExtractorStep;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class PlantInfoExtractorFacade {
    private final PlantInfoExtractorStep chainHead;
    private final AuthenticatedUserService authenticatedUserService;


    @Autowired
    public PlantInfoExtractorFacade(@Value("${trefle.key}") String trefleKey, List<PlantInfoExtractorStep> steps,
                                    AuthenticatedUserService authenticatedUserService) {
        this.authenticatedUserService = authenticatedUserService;
        List<PlantInfoExtractorStep> stepsToUse = steps.stream().toList();
        if (trefleKey == null || trefleKey.isBlank()) {
            stepsToUse = stepsToUse.stream().filter(step -> !(step instanceof TreflePlantInfoExtractorStep)).toList();
        }
        this.chainHead = ChainElement.buildChain(stepsToUse, new NoOpPlantInfoExtractor());
    }


    @Cacheable(value = "botanical-info", key = "{#size, @authenticatedUserService.getAuthenticatedUser().id}")
    public List<BotanicalInfo> getAll(int size) {
        return chainHead.getAll(size);
    }


    @Cacheable(
        value = "botanical-info",
        key = "{#partialPlantScientificName, #size, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        return chainHead.extractPlants(partialPlantScientificName, size);
    }
}

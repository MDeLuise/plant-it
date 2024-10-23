package com.github.mdeluise.plantit.plantinfo;

import java.util.List;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.plantinfo.floracodex.FloraCodexPlantInfoExtractorStep;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class PlantInfoExtractorFacade {
    private final PlantInfoExtractorStep chainHead;
    private final AuthenticatedUserService authenticatedUserService;
    private final Logger logger = LoggerFactory.getLogger(PlantInfoExtractorFacade.class);


    @Autowired
    public PlantInfoExtractorFacade(@Value("${floracodex.key}") String floraCodexKey,
                                    List<PlantInfoExtractorStep> steps,
                                    AuthenticatedUserService authenticatedUserService) {
        this.authenticatedUserService = authenticatedUserService;
        List<PlantInfoExtractorStep> stepsToUse = steps.stream().toList();
        if (floraCodexKey == null || floraCodexKey.isBlank()) {
            logger.debug("FloraCodex service not used");
            stepsToUse = stepsToUse.stream().filter(step -> !(step instanceof FloraCodexPlantInfoExtractorStep)).toList();
        } else {
            logger.debug("FloraCodex service used");
        }
        this.chainHead = ChainElement.buildChain(stepsToUse, new NoOpPlantInfoExtractor());
    }


    @Cacheable(value = "botanical-info", key = "{#size, @authenticatedUserService.getAuthenticatedUser().id}")
    public List<BotanicalInfo> getAll(int size) {
        logger.debug("Search all botanical info");
        return chainHead.getAll(size);
    }


    @Cacheable(
        value = "botanical-info",
        key = "{#partialPlantScientificName, #size, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        final String searchTerm = partialPlantScientificName.isBlank() ? "*" : partialPlantScientificName.trim();
        logger.debug(String.format("Extract botanical info matching %s (size %s)", searchTerm, size));
        return chainHead.extractPlants(searchTerm, size);
    }
}

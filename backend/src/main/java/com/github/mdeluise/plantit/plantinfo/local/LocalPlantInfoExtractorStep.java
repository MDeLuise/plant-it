package com.github.mdeluise.plantit.plantinfo.local;

import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractorStep;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;

@Service
@Order(1)
public class LocalPlantInfoExtractorStep extends AbstractPlantInfoExtractorStep {
    private final BotanicalInfoService botanicalInfoService;


    public LocalPlantInfoExtractorStep(BotanicalInfoService botanicalInfoService) {
        super();
        this.botanicalInfoService = botanicalInfoService;
    }


    @Override
    protected Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        return botanicalInfoService.getByPartialScientificName(partialPlantScientificName, size);
    }


    @Override
    protected Set<BotanicalInfo> getAllInternal(int size) {
        return botanicalInfoService.getAll(size);
    }
}

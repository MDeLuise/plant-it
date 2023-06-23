package com.github.mdeluise.plantit.plantinfo.local;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Set;

@Component
public class LocalPlantInfoExtractor extends AbstractPlantInfoExtractor {
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public LocalPlantInfoExtractor(AuthenticatedUserService authenticatedUserService,
                                   BotanicalInfoService botanicalInfoService) {
        super(authenticatedUserService);
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

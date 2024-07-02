package com.github.mdeluise.plantit.plantinfo.floracodex;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractorStep;
import org.springframework.core.annotation.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@Order(2)
public class FloraCodexPlantInfoExtractorStep extends AbstractPlantInfoExtractorStep {
    private final FloraCodexRequestMaker floraCodexRequestMaker;
    private final BotanicalInfoService botanicalInfoService;


    public FloraCodexPlantInfoExtractorStep(FloraCodexRequestMaker floraCodexRequestMaker,
                                            BotanicalInfoService botanicalInfoService) {
        super();
        this.floraCodexRequestMaker = floraCodexRequestMaker;
        this.botanicalInfoService = botanicalInfoService;
    }


    @Override
    protected Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        final Page<BotanicalInfo> result =
            floraCodexRequestMaker.fetchInfoFromPartial(partialPlantScientificName, Pageable.ofSize(size));
        final List<BotanicalInfo> filteredResult = result.stream()
                                                         .filter(botanicalInfo -> !existAlreadyALocalVersion(botanicalInfo))
                                                         .toList();
        return new HashSet<>(filteredResult);
    }


    @Override
    protected Set<BotanicalInfo> getAllInternal(int size) {
        final Page<BotanicalInfo> result = floraCodexRequestMaker.fetchAll(Pageable.ofSize(size));
        final List<BotanicalInfo> filteredResult = result.stream()
                                                         .filter(botanicalInfo -> !existAlreadyALocalVersion(botanicalInfo))
                                                         .toList();
        return new HashSet<>(filteredResult);
    }


    private boolean existAlreadyALocalVersion(BotanicalInfo botanicalInfo) {
        return botanicalInfoService.existsExternalId(BotanicalInfoCreator.FLORA_CODEX, botanicalInfo.getExternalId()) ||
                   botanicalInfoService.existsSpecies(botanicalInfo.getSpecies());
    }
}

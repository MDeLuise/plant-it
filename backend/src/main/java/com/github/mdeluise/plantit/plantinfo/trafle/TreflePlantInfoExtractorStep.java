package com.github.mdeluise.plantit.plantinfo.trafle;

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
public class TreflePlantInfoExtractorStep extends AbstractPlantInfoExtractorStep {
    private final TrefleRequestMaker trefleRequestMaker;
    private final BotanicalInfoService botanicalInfoService;


    public TreflePlantInfoExtractorStep(TrefleRequestMaker trefleRequestMaker,
                                        BotanicalInfoService botanicalInfoService) {
        super();
        this.trefleRequestMaker = trefleRequestMaker;
        this.botanicalInfoService = botanicalInfoService;
    }


    @Override
    protected Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        final Page<BotanicalInfo> result =
            trefleRequestMaker.fetchInfoFromPartial(partialPlantScientificName, Pageable.ofSize(size));
        final List<BotanicalInfo> filteredResult = result.stream()
                                                         .filter(botanicalInfo -> !existAlreadyALocalVersion(botanicalInfo))
                                                         .toList();
        return new HashSet<>(filteredResult);
    }


    @Override
    protected Set<BotanicalInfo> getAllInternal(int size) {
        final Page<BotanicalInfo> result = trefleRequestMaker.fetchAll(Pageable.ofSize(size));
        final List<BotanicalInfo> filteredResult = result.stream()
                                                         .filter(botanicalInfo -> !existAlreadyALocalVersion(botanicalInfo))
                                                         .toList();
        return new HashSet<>(filteredResult);
    }


    private boolean existAlreadyALocalVersion(BotanicalInfo botanicalInfo) {
        return botanicalInfoService.existsExternalId(BotanicalInfoCreator.TREFLE, botanicalInfo.getExternalId()) ||
                   botanicalInfoService.existsSpecies(botanicalInfo.getSpecies());
    }
}

package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
public class TreflePlantInfoExtractor extends AbstractPlantInfoExtractor {
    private final TrefleRequestMaker trefleRequestMaker;


    @Autowired
    public TreflePlantInfoExtractor(AuthenticatedUserService authenticatedUserService,
                                    TrefleRequestMaker trefleRequestMaker) {
        super(authenticatedUserService);
        this.trefleRequestMaker = trefleRequestMaker;
    }


    @Override
    protected Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        final Page<BotanicalInfo> result =
            trefleRequestMaker.fetchInfoFromPartial(partialPlantScientificName, Pageable.ofSize(size));
        return new HashSet<>(result.getContent());
    }


    @Override
    protected Set<BotanicalInfo> getAllInternal(int size) {
        final Page<BotanicalInfo> result = trefleRequestMaker.fetchAll(Pageable.ofSize(size));
        return new HashSet<>(result.getContent());
    }
}

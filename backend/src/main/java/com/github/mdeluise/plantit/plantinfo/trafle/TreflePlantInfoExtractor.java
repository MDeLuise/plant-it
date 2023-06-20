package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TreflePlantInfoExtractor extends AbstractPlantInfoExtractor {
    private final TrefleRequestMaker trefleRequestMaker;


    @Autowired
    public TreflePlantInfoExtractor(TrefleRequestMaker trefleRequestMaker) {
        this.trefleRequestMaker = trefleRequestMaker;
    }


    @Override
    protected List<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        final Page<BotanicalInfo> result =
            trefleRequestMaker.fetchInfoFromPartial(partialPlantScientificName, Pageable.ofSize(size));
        return result.getContent();
    }


    @Override
    protected List<BotanicalInfo> getAllInternal(int size) {
        final Page<BotanicalInfo> result = trefleRequestMaker.fetchAll(Pageable.ofSize(size));
        return result.getContent();
    }
}

package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import org.springframework.cache.annotation.Cacheable;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractPlantInfoExtractor {
    private AbstractPlantInfoExtractor next;


    public void setNext(AbstractPlantInfoExtractor next) {
        this.next = next;
    }


    @Cacheable(value = "info", key = "{#partialPlantScientificName, #size}")
    public List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        return extractPlants(partialPlantScientificName, size, new ArrayList<>());
    }


    // FIXME problem of duplicated BotanicalInfo from different sources
    private List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size,
                                              List<BotanicalInfo> chainResult) {
        final List<BotanicalInfo> personalResult = extractPlantsInternal(partialPlantScientificName, size);
        chainResult.addAll(personalResult);
        if (chainResult.size() >= size || next == null) {
            return chainResult.subList(0, size);
        }
        return next.extractPlants(partialPlantScientificName, size, chainResult);
    }


    protected abstract List<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size);


    @Cacheable(value = "info", key = "#size")
    public List<BotanicalInfo> getAll(int size) {
        return getAll(size, new ArrayList<>());
    }


    // FIXME problem of duplicated BotanicalInfo from different sources
    public List<BotanicalInfo> getAll(int size, List<BotanicalInfo> chainResult) {
        final List<BotanicalInfo> personalResult = getAllInternal(size);
        chainResult.addAll(personalResult);
        if (chainResult.size() >= size || next == null) {
            return chainResult.subList(0, size);
        }
        return next.getAll(size, chainResult);
    }


    protected abstract List<BotanicalInfo> getAllInternal(int size);
}

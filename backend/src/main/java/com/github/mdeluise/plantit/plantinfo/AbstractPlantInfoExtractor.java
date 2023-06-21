package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import org.springframework.cache.annotation.Cacheable;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public abstract class AbstractPlantInfoExtractor {
    private AbstractPlantInfoExtractor next;


    public void setNext(AbstractPlantInfoExtractor next) {
        this.next = next;
    }


    @Cacheable(value = "info", key = "{#partialPlantScientificName, #size}")
    public Set<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        return extractPlants(partialPlantScientificName, size, new HashSet<>());
    }


    private Set<BotanicalInfo> extractPlants(String partialPlantScientificName, int size,
                                              Set<BotanicalInfo> chainResult) {
        final Set<BotanicalInfo> personalResult = extractPlantsInternal(partialPlantScientificName, size);
        chainResult.addAll(personalResult);
        if (chainResult.size() >= size || next == null) {
            return new HashSet<>(new ArrayList<>(chainResult).subList(0, Math.min(size, chainResult.size())));
        }
        return next.extractPlants(partialPlantScientificName, size, chainResult);
    }


    protected abstract Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size);


    @Cacheable(value = "info", key = "#size")
    public Set<BotanicalInfo> getAll(int size) {
        return getAll(size, new HashSet<>());
    }


    public Set<BotanicalInfo> getAll(int size, Set<BotanicalInfo> chainResult) {
        final Set<BotanicalInfo> personalResult = getAllInternal(size);
        chainResult.addAll(personalResult);
        if (chainResult.size() >= size || next == null) {
            return new HashSet<>(new ArrayList<>(chainResult).subList(0, Math.min(size, chainResult.size())));
        }
        return next.getAll(size, chainResult);
    }


    protected abstract Set<BotanicalInfo> getAllInternal(int size);
}

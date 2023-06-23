package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
public abstract class AbstractPlantInfoExtractor {
    private final AuthenticatedUserService authenticatedUserService;
    private AbstractPlantInfoExtractor next;


    protected AbstractPlantInfoExtractor(AuthenticatedUserService authenticatedUserService) {
        this.authenticatedUserService = authenticatedUserService;
    }


    public void setNext(AbstractPlantInfoExtractor next) {
        this.next = next;
    }


    @Cacheable(
        value = "botanical-info",
        key = "{#partialPlantScientificName, #size, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        return new ArrayList<>(extractPlants(partialPlantScientificName, size, new HashSet<>()));
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


    @Cacheable(value = "botanical-info", key = "{#size, @authenticatedUserService.getAuthenticatedUser().id}")
    public List<BotanicalInfo> getAll(int size) {
        return new ArrayList<>(getAll(size, new HashSet<>()));
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

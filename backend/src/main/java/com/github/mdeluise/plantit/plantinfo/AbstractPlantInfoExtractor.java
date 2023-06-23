package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import org.springframework.cache.annotation.Cacheable;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public abstract class AbstractPlantInfoExtractor extends AbstractAuthenticatedService {
    private AbstractPlantInfoExtractor next;


    protected AbstractPlantInfoExtractor(UserService userService) {
        super(userService);
    }


    public void setNext(AbstractPlantInfoExtractor next) {
        this.next = next;
    }


    @Cacheable(value = "botanical-info", key = "{#partialPlantScientificName, #size, '#{this.getAuthenticatedUser().id}'}")
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


    @Cacheable(value = "botanical-info", key = "{#size, '#{this.getAuthenticatedUser().id}'}")
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

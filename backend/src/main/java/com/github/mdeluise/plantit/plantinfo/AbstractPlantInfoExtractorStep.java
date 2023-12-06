package com.github.mdeluise.plantit.plantinfo;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import org.springframework.stereotype.Component;

@Component
public abstract class AbstractPlantInfoExtractorStep implements PlantInfoExtractorStep {
    private PlantInfoExtractorStep next;

    @Override
    public void setNext(PlantInfoExtractorStep next) {
        this.next = next;
    }


    public List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size) {
        final Set<BotanicalInfo> result = extractPlantsInternal(partialPlantScientificName, size);
        if (result.size() < size && next != null) {
            result.addAll(next.extractPlants(partialPlantScientificName, size));
        }
        return new ArrayList<>(new ArrayList<>(result).subList(0, Math.min(size, result.size())));
    }


    protected abstract Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size);


    public List<BotanicalInfo> getAll(int size) {
        final ArrayList<BotanicalInfo> result = new ArrayList<>(getAllInternal(size));
        if (result.size() < size && next != null) {
            result.addAll(next.getAll(size));
        }
        return new ArrayList<>(new ArrayList<>(result).subList(0, Math.min(size, result.size())));
    }


    protected abstract Set<BotanicalInfo> getAllInternal(int size);
}

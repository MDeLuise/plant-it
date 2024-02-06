package com.github.mdeluise.plantit.plant;

import java.util.Comparator;
import java.util.List;
import java.util.Random;

import com.github.mdeluise.plantit.image.EntityImageImpl;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PlantAvatarGetter {
    private final ImageStorageService imageStorageService;


    @Autowired
    public PlantAvatarGetter(ImageStorageService imageStorageService) {
        this.imageStorageService = imageStorageService;
    }


    public EntityImageImpl getPlantAvatar(Plant plant) {
        final List<PlantImage> plantImages = imageStorageService.getAllIds(plant).stream()
                                                                .map(imageStorageService::get)
                                                                .map(x -> (PlantImage) x)
                                                                .sorted(Comparator.comparing(EntityImageImpl::getCreateOn))
                                                                .toList();
        return switch (plant.getAvatarMode()) {
            case SPECIFIED -> plant.getAvatarImage();
            case LAST -> {
                if (plantImages.isEmpty()) {
                    yield null; // or plant.getBotanicalInfo().getImage();
                }
                yield plantImages.get(plantImages.size() - 1);
            }
            case RANDOM -> {
                if (plantImages.isEmpty()) {
                    yield null; // or plant.getBotanicalInfo().getImage();
                }
                final int randomIndex = (new Random()).nextInt(plantImages.size());
                yield plantImages.get(randomIndex);
            }
            case NONE -> plant.getBotanicalInfo().getImage();
        };
    }
}

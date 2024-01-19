package com.github.mdeluise.plantit.stats;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StatsService {
    private final PlantService plantService;
    private final ImageStorageService imageStorageService;
    private final DiaryEntryService diaryEntryService;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public StatsService(PlantService plantService, ImageStorageService imageStorageService,
                        DiaryEntryService diaryEntryService, BotanicalInfoService botanicalInfoService) {
        this.plantService = plantService;
        this.imageStorageService = imageStorageService;
        this.diaryEntryService = diaryEntryService;
        this.botanicalInfoService = botanicalInfoService;
    }


    public UserStats getStats() {
        final UserStats result = new UserStats();
        result.setImageCount(imageStorageService.count());
        result.setDiaryEntryCount(diaryEntryService.count());
        result.setPlantCount(plantService.count());
        result.setBotanicalInfoCount(botanicalInfoService.count());
        return result;
    }
}

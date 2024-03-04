package com.github.mdeluise.plantit.unit.service;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.stats.StatsService;
import com.github.mdeluise.plantit.stats.UserStats;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for StatsService")
class StatsServiceUnitTests {
    @Mock
    private PlantService plantService;
    @Mock
    private ImageStorageService imageStorageService;
    @Mock
    private DiaryEntryService diaryEntryService;
    @Mock
    private BotanicalInfoService botanicalInfoService;
    @InjectMocks
    private StatsService statsService;


    @Test
    @DisplayName("Should return user stats")
    void shouldReturnUserStats() {
        final long plantCount = 10;
        final int imageCount = 5;
        final long diaryEntryCount = 15;
        final long botanicalInfoCount = 8;
        Mockito.when(plantService.count()).thenReturn(plantCount);
        Mockito.when(imageStorageService.count()).thenReturn(imageCount);
        Mockito.when(diaryEntryService.count()).thenReturn(diaryEntryCount);
        Mockito.when(botanicalInfoService.count()).thenReturn(botanicalInfoCount);

        final UserStats result = statsService.getStats();

        Assertions.assertThat(result.getPlantCount()).isEqualTo(plantCount);
        Assertions.assertThat(result.getImageCount()).isEqualTo(imageCount);
        Assertions.assertThat(result.getDiaryEntryCount()).isEqualTo(diaryEntryCount);
        Assertions.assertThat(result.getBotanicalInfoCount()).isEqualTo(botanicalInfoCount);
    }
}

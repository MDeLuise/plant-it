package com.github.mdeluise.plantit.unit.controller;

import com.github.mdeluise.plantit.stats.StatsController;
import com.github.mdeluise.plantit.stats.StatsService;
import com.github.mdeluise.plantit.stats.UserStats;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for StatsController")
class StatsControllerUnitTests {
    @Mock
    private StatsService statsService;
    @InjectMocks
    private StatsController statsController;


    @Test
    @DisplayName("Test get stats")
    void testGetStats() {
        final long plantCount = 10;
        final int imageCount = 5;
        final long diaryEntryCount = 15;
        final long botanicalInfoCount = 8;
        final UserStats userStats = new UserStats();
        userStats.setBotanicalInfoCount(botanicalInfoCount);
        userStats.setDiaryEntryCount(diaryEntryCount);
        userStats.setPlantCount(plantCount);
        userStats.setImageCount(imageCount);
        Mockito.when(statsService.getStats()).thenReturn(userStats);

        final ResponseEntity<UserStats> responseEntity = statsController.getStats();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(userStats, responseEntity.getBody());
    }

}
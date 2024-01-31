package com.github.mdeluise.plantit.unit.service;

import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryRepository;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for DiaryService")
class DiaryServiceUnitTests {
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @Mock
    private DiaryRepository diaryRepository;
    @Mock
    private PlantService plantService;
    @InjectMocks
    private DiaryService diaryService;


    @Test
    @DisplayName("Should get all diaries")
    void shouldGetAllDiaries() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Pageable pageable = Pageable.unpaged();
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        final Diary diary1 = new Diary();
        diary1.setId(1L);
        diary1.setOwner(authenticated);
        diary1.setTarget(plant1);
        final Diary diary2 = new Diary();
        diary2.setId(2L);
        diary2.setOwner(authenticated);
        diary2.setTarget(plant2);
        final Page<Diary> diaries = new PageImpl<>(List.of(diary1, diary2));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryRepository.findAllByOwner(authenticated, pageable)).thenReturn(diaries);

        final Page<Diary> result = diaryService.getAll(pageable);

        Assertions.assertThat(result).hasSameElementsAs(diaries);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryRepository, Mockito.times(1)).findAllByOwner(authenticated, pageable);
    }


    @Test
    @DisplayName("Should get diary by target ID")
    void shouldGetDiaryByTargetId() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long targetId = 1L;
        final Plant plant = new Plant();
        plant.setId(targetId);
        final Diary diary = new Diary();
        diary.setId(1L);
        diary.setOwner(authenticated);
        diary.setTarget(plant);
        Mockito.when(plantService.get(targetId)).thenReturn(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryRepository.findByOwnerAndTarget(authenticated, plant)).thenReturn(Optional.of(diary));

        final Diary result = diaryService.get(targetId);

        Assertions.assertThat(result).isEqualTo(diary);
        Mockito.verify(plantService, Mockito.times(1)).get(targetId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryRepository, Mockito.times(1))
               .findByOwnerAndTarget(authenticatedUserService.getAuthenticatedUser(), plant);
    }


    @Test
    @DisplayName("Should throw error when getting non-existing diary by target ID")
    void shouldThrowResourceNotFoundExceptionWhenGettingNonExistingDiaryByTargetId() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long nonExistingTargetId = 99L;
        final Plant nonExistingPlant = new Plant();
        nonExistingPlant.setId(nonExistingTargetId);
        Mockito.when(plantService.get(nonExistingTargetId)).thenReturn(nonExistingPlant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryRepository.findByOwnerAndTarget(authenticated, nonExistingPlant))
               .thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> diaryService.get(nonExistingTargetId))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(plantService, Mockito.times(1)).get(nonExistingTargetId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryRepository, Mockito.times(1))
               .findByOwnerAndTarget(authenticated, nonExistingPlant);
    }


    @Test
    @DisplayName("Should throw error when getting diary owned by another user")
    void shouldThrowUnauthorizedExceptionWhenGettingDiaryOwnedByAnotherUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long targetId = 1L;
        final Diary diary = new Diary();
        diary.setId(1L);
        Mockito.when(plantService.get(targetId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> diaryService.get(targetId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(plantService, Mockito.times(1)).get(targetId);
    }
}

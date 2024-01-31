package com.github.mdeluise.plantit.unit.service;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryRepository;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryStats;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
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
@DisplayName("Unit tests for DiaryEntryService")
class DiaryEntryServiceUnitTests {
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @Mock
    private DiaryEntryRepository diaryEntryRepository;
    @Mock
    private DiaryService diaryService;
    @Mock
    private PlantService plantService;
    @InjectMocks
    private DiaryEntryService diaryEntryService;


    @Test
    @DisplayName("Should get all diary entries for a diary")
    void shouldGetAllDiaryEntriesForDiary() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryId = 1L;
        final Diary diary = new Diary();
        diary.setId(diaryId);
        final Pageable pageable = Pageable.unpaged();
        final DiaryEntry diaryEntry1 = new DiaryEntry();
        diaryEntry1.setId(1L);
        final DiaryEntry diaryEntry2 = new DiaryEntry();
        diaryEntry2.setId(2L);
        final Page<DiaryEntry> diaryEntryPage = new PageImpl<>(List.of(diaryEntry1, diaryEntry2));
        Mockito.when(diaryService.get(diaryId)).thenReturn(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwnerAndDiary(authenticated, diary, pageable))
               .thenReturn(diaryEntryPage);

        final Page<DiaryEntry> result = diaryEntryService.getAll(diaryId, pageable);

        Assertions.assertThat(result).isEqualTo(diaryEntryPage);
        Mockito.verify(diaryService, Mockito.times(1)).get(diaryId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1))
               .findAllByDiaryOwnerAndDiary(authenticated, diary, pageable);
    }


    @Test
    @DisplayName("Should throw error when getting diary entry owned by another user")
    void shouldThrowUnauthorizedExceptionWhenGettingDiaryEntryOwnedByAnotherUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(new User());
        diary.setId(2L);
        diaryEntry.setDiary(diary);

        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(diaryEntry));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);

        Assertions.assertThatThrownBy(() -> diaryEntryService.get(diaryEntryId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
    }


    @Test
    @DisplayName("Should throw error when updating diary entry owned by another user")
    void shouldThrowUnauthorizedExceptionWhenUpdatingDiaryEntryOwnedByAnotherUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry existingDiaryEntry = new DiaryEntry();
        existingDiaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(new User());
        diary.setId(2L);
        existingDiaryEntry.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(existingDiaryEntry));

        Assertions.assertThatThrownBy(() -> diaryEntryService.update(diaryEntryId, new DiaryEntry()))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
    }


    @Test
    @DisplayName("Should save diary entry successfully")
    void shouldSaveDiaryEntrySuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final DiaryEntry diaryEntryToSave = new DiaryEntry();
        final Diary diary = new Diary();
        diary.setOwner(authenticated);
        diary.setId(2L);
        diaryEntryToSave.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryService.get(diary.getId())).thenReturn(diary);
        Mockito.when(diaryEntryRepository.save(diaryEntryToSave)).thenReturn(diaryEntryToSave);

        final DiaryEntry result = diaryEntryService.save(diaryEntryToSave);

        Assertions.assertThat(result).isEqualTo(diaryEntryToSave);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryService, Mockito.times(1)).get(diary.getId());
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).save(diaryEntryToSave);
    }


    @Test
    @DisplayName("Should delete diary entry successfully")
    void shouldDeleteDiaryEntrySuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry existingDiaryEntry = new DiaryEntry();
        existingDiaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(authenticated);
        diary.setId(2L);
        existingDiaryEntry.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(existingDiaryEntry));

        diaryEntryService.delete(diaryEntryId);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).delete(existingDiaryEntry);
    }


    @Test
    @DisplayName("Should get all diary entry types")
    void shouldGetAllDiaryEntryTypes() {
        final Collection<DiaryEntryType> allTypes = List.of(DiaryEntryType.values());

        final Collection<DiaryEntryType> result = diaryEntryService.getAllTypes();

        Assertions.assertThat(result).isEqualTo(allTypes);
    }


    @Test
    @DisplayName("Should throw error when saving diary entry for another user's diary")
    void shouldThrowUnauthorizedExceptionWhenSavingDiaryEntryForAnotherUsersDiary() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final DiaryEntry diaryEntryToSave = new DiaryEntry();
        final Diary diary = new Diary();
        diary.setOwner(new User());
        diary.setId(2L);
        diaryEntryToSave.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryService.get(diary.getId())).thenReturn(diary);

        Assertions.assertThatThrownBy(() -> diaryEntryService.save(diaryEntryToSave))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryService, Mockito.times(1)).get(diary.getId());
        Mockito.verify(diaryEntryRepository, Mockito.times(0)).save(diaryEntryToSave);
    }


    @Test
    @DisplayName("Should update diary entry successfully")
    void shouldUpdateDiaryEntrySuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry existingDiaryEntry = new DiaryEntry();
        existingDiaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(authenticated);
        diary.setId(2L);
        existingDiaryEntry.setDiary(diary);
        final DiaryEntry updatedDiaryEntry = new DiaryEntry();
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(existingDiaryEntry));
        Mockito.when(diaryService.get(existingDiaryEntry.getDiary().getId())).thenReturn(existingDiaryEntry.getDiary());
        Mockito.when(diaryEntryRepository.save(updatedDiaryEntry)).thenReturn(updatedDiaryEntry);

        final DiaryEntry result = diaryEntryService.update(diaryEntryId, updatedDiaryEntry);

        Assertions.assertThat(result).isEqualTo(updatedDiaryEntry);
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).save(updatedDiaryEntry);
    }


    @Test
    @DisplayName("Should get diary entry by ID successfully")
    void shouldGetDiaryEntryByIdSuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry existingDiaryEntry = new DiaryEntry();
        existingDiaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(authenticated);
        diary.setId(2L);
        existingDiaryEntry.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(existingDiaryEntry));

        final DiaryEntry result = diaryEntryService.get(diaryEntryId);

        Assertions.assertThat(result).isEqualTo(existingDiaryEntry);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
    }


    @Test
    @DisplayName("Should throw error when deleting diary entry of another user's diary")
    void shouldThrowUnauthorizedExceptionWhenDeletingDiaryEntryOfAnotherUsersDiary() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long diaryEntryId = 1L;
        final DiaryEntry existingDiaryEntry = new DiaryEntry();
        existingDiaryEntry.setId(diaryEntryId);
        final Diary diary = new Diary();
        diary.setOwner(new User());
        diary.setId(2L);
        existingDiaryEntry.setDiary(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(existingDiaryEntry));

        Assertions.assertThatThrownBy(() -> diaryEntryService.delete(diaryEntryId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).findById(diaryEntryId);
        Mockito.verify(diaryService, Mockito.times(0)).get(existingDiaryEntry.getDiary().getId());
    }


    @Test
    @DisplayName("Should get count of all diary entries for the authenticated user")
    void shouldGetCountOfAllDiaryEntriesForAuthenticatedUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryEntryRepository.countByDiaryOwner(authenticated)).thenReturn(10L);

        final Long result = diaryEntryService.count();

        Assertions.assertThat(result).isEqualTo(10L);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).countByDiaryOwner(authenticated);
    }


    @Test
    @DisplayName("Should get count of diary entries for a specific plant owned by the authenticated user")
    void shouldGetCountOfDiaryEntriesForSpecificPlant() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long plantId = 2L;
        final Diary diary = new Diary();
        diary.setOwner(authenticated);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryService.get(plantId)).thenReturn(diary);
        Mockito.when(diaryEntryRepository.countByDiaryOwnerAndDiaryTargetId(authenticated, plantId)).thenReturn(5L);

        final Long result = diaryEntryService.count(plantId);

        Assertions.assertThat(result).isEqualTo(5L);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryService, Mockito.times(1)).get(plantId);
        Mockito.verify(diaryEntryRepository, Mockito.times(1)).countByDiaryOwnerAndDiaryTargetId(authenticated, plantId);
    }


    @Test
    @DisplayName("Should return error when counting diary entries for a plant owned by another user")
    void shouldThrowUnauthorizedExceptionWhenCountingDiaryEntriesForPlantOfAnotherUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long plantId = 2L;
        final Diary targetDiary = new Diary();
        targetDiary.setId(plantId);
        targetDiary.setOwner(new User());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryService.get(plantId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> diaryEntryService.count(plantId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(diaryService, Mockito.times(1)).get(plantId);
    }

    @Test
    @DisplayName("Should get stats for diary entries of a specific plant owned by the authenticated user")
    void shouldGetStatsForDiaryEntriesOfSpecificPlant() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long plantId = 2L;
        final Diary diary = new Diary();
        diary.setId(plantId);
        diary.setOwner(authenticated);
        final DiaryEntry diaryEntry1 = new DiaryEntry();
        diaryEntry1.setId(1L);
        diaryEntry1.setType(DiaryEntryType.SEEDING);
        diaryEntry1.setDate(new Date(System.currentTimeMillis() - 86400000));
        final DiaryEntry diaryEntry2 = new DiaryEntry();
        diaryEntry2.setId(1L);
        diaryEntry2.setType(DiaryEntryType.WATERING);
        diaryEntry2.setDate(new Date(System.currentTimeMillis() - 172800000));
        final DiaryEntryStats stat1 = new DiaryEntryStats(diaryEntry1.getType(), diaryEntry1.getDate());
        final DiaryEntryStats stat2 = new DiaryEntryStats(diaryEntry2.getType(), diaryEntry2.getDate());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(diaryService.get(plantId)).thenReturn(diary);
        Mockito.when(diaryEntryRepository.findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(authenticated, plantId, DiaryEntryType.SEEDING))
               .thenReturn(Optional.of(diaryEntry1));
        Mockito.when(diaryEntryRepository.findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(authenticated, plantId, DiaryEntryType.WATERING))
               .thenReturn(Optional.of(diaryEntry2));

        final Collection<DiaryEntryStats> result = diaryEntryService.getStats(plantId);

        Assertions.assertThat(result).containsExactlyInAnyOrder(stat2, stat1);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(diaryService, Mockito.times(1)).get(plantId);
        Mockito.verify(diaryEntryRepository, Mockito.times(1))
               .findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(authenticated, plantId, DiaryEntryType.SEEDING);
        Mockito.verify(diaryEntryRepository, Mockito.times(1))
               .findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(authenticated, plantId, DiaryEntryType.WATERING);
    }
}


package com.github.mdeluise.plantit.diary.entry.service;

import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryRepository;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
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
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class DiaryEntryServiceTest {
    @Mock
    AuthenticatedUserService authenticatedUserService;
    @Mock
    DiaryEntryRepository diaryEntryRepository;
    @Mock
    PlantService plantService;
    @Mock
    DiaryService diaryService;
    @InjectMocks
    DiaryEntryService diaryEntryService;


    @Test
    @DisplayName("Should get all diary entries")
    void shouldGetAll() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Pageable pageable = PageRequest.of(0, 10, Sort.Direction.DESC, "id");
        final Diary diary = new Diary();
        diary.setId(1L);
        final DiaryEntry toGet1 = new DiaryEntry();
        toGet1.setId(1L);
        toGet1.setDiary(diary);
        final DiaryEntry toGet2 = new DiaryEntry();
        toGet2.setId(2L);
        toGet2.setDiary(diary);
        final Page<DiaryEntry> toGet = new PageImpl<>(List.of(toGet1, toGet2));

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwner(authenticatedUser, pageable)).thenReturn(toGet);

        Assertions.assertThat(diaryEntryService.getAll(pageable, List.of(), List.of())).as("diary entries are correct")
                  .hasSameElementsAs(toGet);
    }


    @Test
    @DisplayName("Should get all diary entries filtered by plantIds")
    void shouldGetAllFilteredByPlantIds() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        final Diary diary1 = new Diary();
        diary1.setId(1L);
        diary1.setTarget(plant1);
        final Diary diary2 = new Diary();
        diary2.setId(2L);
        diary2.setTarget(plant2);
        final DiaryEntry toGet1 = new DiaryEntry();
        toGet1.setId(1L);
        toGet1.setDiary(diary1);
        final DiaryEntry toGet2 = new DiaryEntry();
        toGet2.setId(2L);
        toGet2.setDiary(diary2);
        final Page<DiaryEntry> toGet = new PageImpl<>(List.of(toGet1, toGet2));
        final List<Long> filteredPlantIds = List.of(1L);
        final Pageable pageable = PageRequest.of(0, toGet.getSize(), Sort.Direction.DESC, "id");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwner(authenticatedUser, pageable)).thenReturn(toGet);
        Mockito.when(diaryEntryRepository.countByDiaryOwner(authenticatedUser)).thenReturn((long) toGet.getSize());

        Assertions.assertThat(diaryEntryService.getAll(pageable, filteredPlantIds, List.of()))
                  .as("filtered diary entries are correct").hasSameElementsAs(
                      toGet.filter(diaryEntry -> filteredPlantIds.contains(diaryEntry.getDiary().getTarget().getId())));
    }


    @Test
    @DisplayName("Should get all diary entries filtered by event type")
    void shouldGetAllFilteredByEventType() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        final Diary diary1 = new Diary();
        diary1.setId(1L);
        diary1.setTarget(plant1);
        final Diary diary2 = new Diary();
        diary2.setId(2L);
        diary2.setTarget(plant2);
        final DiaryEntry toGet1 = new DiaryEntry();
        toGet1.setId(1L);
        toGet1.setDiary(diary1);
        toGet1.setType(DiaryEntryType.WATERING);
        final DiaryEntry toGet2 = new DiaryEntry();
        toGet2.setId(2L);
        toGet2.setDiary(diary2);
        toGet2.setType(DiaryEntryType.WATER_CHANGING);
        final Page<DiaryEntry> toGet = new PageImpl<>(List.of(toGet1, toGet2));
        final List<String> filteredEventTypes = List.of(DiaryEntryType.WATERING.name());
        final Pageable pageable = PageRequest.of(0, toGet.getSize(), Sort.Direction.DESC, "id");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwner(authenticatedUser, pageable)).thenReturn(toGet);
        Mockito.when(diaryEntryRepository.countByDiaryOwner(authenticatedUser)).thenReturn((long) toGet.getSize());

        Assertions.assertThat(diaryEntryService.getAll(pageable, List.of(), filteredEventTypes))
                  .as("filtered diary entries are correct").hasSameElementsAs(
                      toGet.filter(diaryEntry -> filteredEventTypes.contains(diaryEntry.getType().name())));
    }


    @Test
    @DisplayName("Should get all diary entries filtered by plantIds and event type")
    void shouldGetAllFilteredByPlantIdsAndEventType() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        final Diary diary1 = new Diary();
        diary1.setId(1L);
        diary1.setTarget(plant1);
        final Diary diary2 = new Diary();
        diary2.setId(2L);
        diary2.setTarget(plant2);
        final DiaryEntry toGet1 = new DiaryEntry();
        toGet1.setId(1L);
        toGet1.setDiary(diary1);
        toGet1.setType(DiaryEntryType.WATERING);
        final DiaryEntry toGet2 = new DiaryEntry();
        toGet2.setId(2L);
        toGet2.setDiary(diary2);
        toGet2.setType(DiaryEntryType.WATER_CHANGING);
        final DiaryEntry toGet3 = new DiaryEntry();
        toGet3.setId(3L);
        toGet3.setDiary(diary1);
        toGet3.setType(DiaryEntryType.WATER_CHANGING);
        final Page<DiaryEntry> toGet = new PageImpl<>(List.of(toGet1, toGet2, toGet3));
        final List<String> filteredEventTypes = List.of(DiaryEntryType.WATERING.name());
        final List<Long> filteredPlantIds = List.of(1L);
        final Pageable pageable = PageRequest.of(0, toGet.getSize(), Sort.Direction.DESC, "id");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwner(authenticatedUser, pageable)).thenReturn(toGet);
        Mockito.when(diaryEntryRepository.countByDiaryOwner(authenticatedUser)).thenReturn((long) toGet.getSize());

        Assertions.assertThat(diaryEntryService.getAll(pageable, filteredPlantIds, filteredEventTypes))
                  .as("filtered diary entries are correct").hasSameElementsAs(toGet.filter(
                      diaryEntry -> filteredEventTypes.contains(diaryEntry.getType().name()) &&
                                        filteredPlantIds.contains(diaryEntry.getDiary().getTarget().getId())));
    }


    @Test
    @DisplayName("Should return error when get all diary entries filter by non existing plantId")
    void shouldReturnErrorWhenGetAllFilterWithNonExistingPlantId() {
        final long plantId = 1L;

        Mockito.when(plantService.get(plantId)).thenThrow(new ResourceNotFoundException(plantId));

        Assertions.assertThatThrownBy(
                      () -> diaryEntryService.getAll(Pageable.unpaged(), List.of(plantId, 2L), List.of()))
                  .as("exception in correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when get all diary entries filter by non existing event type")
    void shouldReturnErrorWhenGetAllFilterWithNonExistingEventType() {
        final String nonExistingEventType = "nonExistingEventType";

        Assertions.assertThatThrownBy(
                      () -> diaryEntryService.getAll(Pageable.unpaged(), List.of(), List.of(nonExistingEventType)))
                  .as("exception in correct").isInstanceOf(IllegalArgumentException.class);
    }


    @Test
    @DisplayName("Should get all diary entries given the diary id")
    void shouldGetAllByDiaryId() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long diaryId = 1;
        final Diary toGet = new Diary();
        toGet.setId(diaryId);
        final DiaryEntry diaryEntry1 = new DiaryEntry();
        diaryEntry1.setId(1L);
        diaryEntry1.setDiary(toGet);
        final DiaryEntry diaryEntry2 = new DiaryEntry();
        diaryEntry2.setId(2L);
        diaryEntry2.setDiary(toGet);
        final Page<DiaryEntry> diaryEntries = new PageImpl<>(List.of(diaryEntry1, diaryEntry2));
        toGet.setEntries(diaryEntries.toSet());
        final Pageable pageable = PageRequest.of(0, 2, Sort.Direction.DESC, "id");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(diaryId)).thenReturn(toGet);
        Mockito.when(diaryEntryRepository.findAllByDiaryOwnerAndDiary(authenticatedUser, toGet, pageable))
               .thenReturn(diaryEntries);

        Assertions.assertThat(diaryEntryService.getAll(diaryId, pageable)).as("diary entries are correct")
                  .hasSameElementsAs(diaryEntries);
    }


    @Test
    @DisplayName("Should return error when get all diary entries given a non existing diary id")
    void shouldReturnErrorWhenGetAllByNonExistingDiaryId() {
        final long diaryId = 1;
        final Pageable pageable = PageRequest.of(0, 2, Sort.Direction.DESC, "id");

        Mockito.when(diaryService.get(diaryId)).thenThrow(new ResourceNotFoundException(diaryId));

        Assertions.assertThatThrownBy(() -> diaryEntryService.getAll(diaryId, pageable)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when get all diary entries given a diary id of another user")
    void shouldReturnErrorWhenGetAllByDiaryIdOfAnotherUser() {
        final long diaryId = 1;
        final Pageable pageable = PageRequest.of(0, 2, Sort.Direction.DESC, "id");

        Mockito.when(diaryService.get(diaryId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> diaryEntryService.getAll(diaryId, pageable)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should return error when get diary entry given non existing diary id")
    void shouldReturnErrorWhenGetByNonExistingDiaryId() {
        final long nonExistingDiaryId = 1;

        Mockito.when(diaryService.get(nonExistingDiaryId)).thenThrow(new ResourceNotFoundException(nonExistingDiaryId));

        Assertions.assertThatThrownBy(() -> diaryEntryService.get(nonExistingDiaryId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when get diary entry given diary id of another user")
    void shouldReturnErrorWhenGetByDiaryIdOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final long diaryId = 1;
        final long diaryEntryId = 1;
        final Diary diary = new Diary();
        diary.setId(diaryId);
        diary.setOwner(owner);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDiary(diary);
        diaryEntry.setId(diaryEntryId);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(diaryId)).thenThrow(new UnauthorizedException());
        Mockito.when(diaryEntryRepository.findById(diaryEntryId)).thenReturn(Optional.of(diaryEntry));

        Assertions.assertThatThrownBy(() -> diaryEntryService.get(diaryEntryId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should get all diary entry types")
    void shouldGetAllDiaryEntryTypes() {
        Assertions.assertThat(diaryEntryService.getAllTypes())
                  .hasSameElementsAs(List.of(DiaryEntryType.class.getEnumConstants()));
    }


    @Test
    @DisplayName("Should save")
    void shouldSave() {
        final User authenticatedUser = new User();
        final long diaryId = 1;
        final Diary diary = new Diary();
        diary.setId(diaryId);
        diary.setOwner(authenticatedUser);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDiary(diary);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(diaryId)).thenReturn(diary);
        Mockito.when(diaryEntryRepository.save(diaryEntry)).thenReturn(diaryEntry);

        Assertions.assertThat(diaryEntryService.save(diaryEntry)).isEqualTo(diaryEntry);
    }


    @Test
    @DisplayName("Should return error when save diary entry to another user diary")
    void shouldReturnErrorWhenSaveToAnotherUserDiary() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final long diaryId = 1;
        final Diary diary = new Diary();
        diary.setId(diaryId);
        diary.setOwner(owner);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDiary(diary);

        Mockito.when(diaryService.get(diaryId)).thenReturn(diary);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        Assertions.assertThatThrownBy(() -> diaryEntryService.save(diaryEntry)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should delete")
    void shouldDelete() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long toDeleteId = 1;
        final Diary diary = new Diary();
        diary.setId(1L);
        diary.setOwner(authenticatedUser);
        final DiaryEntry toDelete = new DiaryEntry();
        toDelete.setId(toDeleteId);
        toDelete.setDiary(diary);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.existsById(toDeleteId)).thenReturn(true);
        Mockito.when(diaryEntryRepository.findById(toDeleteId)).thenReturn(Optional.of(toDelete));

        Assertions.assertThatNoException().isThrownBy(() -> diaryEntryService.delete(toDeleteId));
    }


    @Test
    @DisplayName("Should return error when delete non existing")
    void shouldReturnErrorWhenDeleteNonExisting() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long toDeleteId = 1;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.existsById(toDeleteId)).thenReturn(false);

        Assertions.assertThatThrownBy(() -> diaryEntryService.delete(toDeleteId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when delete of another user")
    void shouldReturnErrorWhenDeleteOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final long toDeleteId = 1;
        final Diary diary = new Diary();
        diary.setId(toDeleteId);
        diary.setOwner(owner);
        final DiaryEntry toDelete = new DiaryEntry();
        toDelete.setId(1L);
        toDelete.setDiary(diary);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.existsById(toDeleteId)).thenReturn(true);
        Mockito.when(diaryEntryRepository.findById(toDeleteId)).thenReturn(Optional.of(toDelete));

        Assertions.assertThatThrownBy(() -> diaryEntryService.delete(toDeleteId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should update")
    void shouldUpdate() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long toUpdateId = 1;
        final Diary diary = new Diary();
        diary.setId(1L);
        diary.setOwner(authenticatedUser);
        final DiaryEntry toUpdate = new DiaryEntry();
        toUpdate.setId(toUpdateId);
        toUpdate.setDiary(diary);
        final DiaryEntry updated = new DiaryEntry();
        updated.setDiary(diary);
        updated.setType(DiaryEntryType.TRANSPLANTING);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findById(toUpdateId)).thenReturn(Optional.of(toUpdate));
        Mockito.when(diaryEntryRepository.save(updated)).thenReturn(updated);

        Assertions.assertThat(diaryEntryService.update(toUpdateId, updated)).as("updated is correct")
                  .isEqualTo(updated);
    }


    @Test
    @DisplayName("Should return error when update non existing")
    void shouldReturnErrorWhenUpdateNonExisting() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long toUpdateId = 1;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findById(toUpdateId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> diaryEntryService.update(toUpdateId, new DiaryEntry()))
                  .as("exception is correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when update of another user")
    void shouldReturnErrorWhenUpdateOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final long toUpdateId = 1;
        final Diary diary = new Diary();
        diary.setId(1L);
        diary.setOwner(owner);
        final DiaryEntry toUpdate = new DiaryEntry();
        toUpdate.setId(toUpdateId);
        toUpdate.setDiary(diary);
        final DiaryEntry updated = new DiaryEntry();
        updated.setId(2L);
        updated.setDiary(diary);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.findById(toUpdateId)).thenReturn(Optional.of(toUpdate));

        Assertions.assertThatThrownBy(() -> diaryEntryService.update(toUpdateId, updated))
                  .as("exception is correct").isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should count")
    void shouldCount() {
        final long expectedCount = 42;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryEntryRepository.countByDiaryOwner(authenticatedUser)).thenReturn(expectedCount);

        Assertions.assertThat(diaryEntryService.count()).as("count is correct").isEqualTo(expectedCount);
    }


    @Test
    @DisplayName("Should count by plantId")
    void shouldCountByPlantId() {
        final long expectedCount = 42;
        final long plantId = 1;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Diary diary = new Diary();
        diary.setOwner(authenticatedUser);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(plantId)).thenReturn(diary);
        Mockito.when(diaryEntryRepository.countByDiaryOwnerAndDiaryTargetId(authenticatedUser, plantId)).thenReturn(expectedCount);

        Assertions.assertThat(diaryEntryService.count(plantId)).as("count is correct").isEqualTo(expectedCount);
    }


    @Test
    @DisplayName("Should return error when count by non existing plantId")
    void shouldReturnErrorWhenCountByNonExistingPlantId() {
        final long expectedCount = 42;
        final long nonExistingPlantId = 1;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(nonExistingPlantId)).thenThrow(new ResourceNotFoundException(nonExistingPlantId));
        Mockito.when(diaryEntryRepository.countByDiaryOwnerAndDiaryTargetId(authenticatedUser, nonExistingPlantId)).thenReturn(expectedCount);

        Assertions.assertThatThrownBy(() -> diaryEntryService.count(nonExistingPlantId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when count by plantId of another user")
    void shouldReturnErrorWhenCountByPlantIdOfAnotherUser() {
        final long expectedCount = 42;
        final long plantId = 1;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(plantId)).thenThrow(new UnauthorizedException());
        Mockito.when(diaryEntryRepository.countByDiaryOwnerAndDiaryTargetId(authenticatedUser, plantId)).thenReturn(expectedCount);

        Assertions.assertThatThrownBy(() -> diaryEntryService.count(plantId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should get stats")
    void shouldGetStats() {
        // TODO
    }


    @Test
    @DisplayName("Should return error when get stats of non existing plantId")
    void shouldReturnErrorWhenGetStatsNonExisting() {
        final long plantId = 41;

        Mockito.when(diaryService.get(plantId)).thenThrow(new ResourceNotFoundException(plantId));

        Assertions.assertThatThrownBy(() -> diaryEntryService.getStats(plantId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error when get stats of another user plantId")
    void shouldReturnErrorWhenGetStatsOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long plantId = 41;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryService.get(plantId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> diaryEntryService.getStats(plantId)).as("exception is correct")
            .isInstanceOf(UnauthorizedException.class);
    }
}
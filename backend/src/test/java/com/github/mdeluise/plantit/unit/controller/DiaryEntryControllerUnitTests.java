package com.github.mdeluise.plantit.unit.controller;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryController;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTO;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTOConverter;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryStats;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for DiaryEntryController")
class DiaryEntryControllerUnitTests {
    @Mock
    private DiaryEntryService diaryEntryService;
    @Mock
    private DiaryEntryDTOConverter diaryEntryDtoConverter;
    @InjectMocks
    private DiaryEntryController diaryEntryController;


    @Test
    @DisplayName("Test get all entries")
    void testGetAllEntries() {
        final Pageable pageable = PageRequest.of(0, 25, Sort.Direction.DESC, "date");
        final Page<DiaryEntry> page = new PageImpl<>(Collections.emptyList());
        Mockito.when(diaryEntryService.getAll(pageable, Collections.emptyList(), Collections.emptyList()))
               .thenReturn(page);

        final ResponseEntity<Page<DiaryEntryDTO>> responseEntity =
            diaryEntryController.getAllEntries(0, 25, "date", Sort.Direction.DESC, Collections.emptyList(),
                                               Collections.emptyList()
            );

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(page.map(diaryEntryDtoConverter::convertToDTO), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get entry by ID")
    void testGetEntryById() {
        final Long id = 1L;
        final DiaryEntry diaryEntry = new DiaryEntry();
        Mockito.when(diaryEntryService.get(id)).thenReturn(diaryEntry);
        final DiaryEntryDTO diaryEntryDTO = new DiaryEntryDTO();
        Mockito.when(diaryEntryDtoConverter.convertToDTO(diaryEntry)).thenReturn(diaryEntryDTO);

        final ResponseEntity<DiaryEntryDTO> responseEntity = diaryEntryController.get(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(diaryEntryDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get all entries by diary ID")
    void testGetEntriesByDiaryId() {
        final Long diaryId = 1L;
        final Pageable pageable = PageRequest.of(0, 25, Sort.Direction.DESC, "date");
        final Page<DiaryEntry> page = new PageImpl<>(Collections.emptyList());
        Mockito.when(diaryEntryService.getAll(diaryId, pageable)).thenReturn(page);

        final ResponseEntity<Page<DiaryEntryDTO>> responseEntity =
            diaryEntryController.getEntries(0, 25, "date", Sort.Direction.DESC, diaryId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(page.map(diaryEntryDtoConverter::convertToDTO), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get all entry types")
    void testGetEntryTypes() {
        final List<DiaryEntryType> types = Arrays.asList(DiaryEntryType.values());
        Mockito.when(diaryEntryService.getAllTypes()).thenReturn(types);

        final ResponseEntity<Collection<DiaryEntryType>> responseEntity = diaryEntryController.getEntryTypes();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(types, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test save diary entry")
    void testSaveDiaryEntry() {
        final DiaryEntryDTO diaryEntryDTO = new DiaryEntryDTO();
        final DiaryEntry diaryEntry = new DiaryEntry();
        Mockito.when(diaryEntryDtoConverter.convertFromDTO(diaryEntryDTO)).thenReturn(diaryEntry);
        Mockito.when(diaryEntryService.save(diaryEntry)).thenReturn(diaryEntry);
        Mockito.when(diaryEntryDtoConverter.convertToDTO(diaryEntry)).thenReturn(diaryEntryDTO);

        final ResponseEntity<DiaryEntryDTO> responseEntity = diaryEntryController.save(diaryEntryDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(diaryEntryDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test updateInternal diary entry")
    void testUpdateDiaryEntry() {
        final Long id = 1L;
        final DiaryEntryDTO updatedDTO = new DiaryEntryDTO();
        final DiaryEntry updatedEntry = new DiaryEntry();
        Mockito.when(diaryEntryDtoConverter.convertFromDTO(updatedDTO)).thenReturn(updatedEntry);
        Mockito.when(diaryEntryService.update(id, updatedEntry)).thenReturn(updatedEntry);
        Mockito.when(diaryEntryDtoConverter.convertToDTO(updatedEntry)).thenReturn(updatedDTO);

        final ResponseEntity<DiaryEntryDTO> responseEntity = diaryEntryController.save(id, updatedDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(updatedDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test delete diary entry by ID")
    void testDeleteDiaryEntry() {
        final Long id = 1L;

        final ResponseEntity<String> responseEntity = diaryEntryController.delete(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertTrue(responseEntity.getBody().contains("Success"));
    }


    @Test
    @DisplayName("Test count all diary entries")
    void testCountAllDiaryEntries() {
        final Long count = 10L;
        Mockito.when(diaryEntryService.count()).thenReturn(count);

        final ResponseEntity<Long> responseEntity = diaryEntryController.count();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(count, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test count diary entries by plant ID")
    void testCountDiaryEntriesByPlantId() {
        final Long plantId = 1L;
        final Long count = 5L;
        Mockito.when(diaryEntryService.count(plantId)).thenReturn(count);

        final ResponseEntity<Long> responseEntity = diaryEntryController.countByPlant(plantId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(count, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get diary entry stats by plant ID")
    void testGetDiaryEntryStatsByPlantId() {
        final Long plantId = 1L;
        final Collection<DiaryEntryStats> stats = Collections.emptyList();
        Mockito.when(diaryEntryService.getStats(plantId)).thenReturn(stats);

        final ResponseEntity<Collection<DiaryEntryStats>> responseEntity = diaryEntryController.getStats(plantId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(stats, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get entry by non-existing ID")
    void testGetEntryByNonExistentId() {
        final Long id = 1L;
        Mockito.when(diaryEntryService.get(id)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> diaryEntryController.get(id));
    }


    @Test
    @DisplayName("Test updateInternal non-existent diary entry")
    void testUpdateNonExistentDiaryEntry() {
        final Long id = 1L;
        final DiaryEntryDTO updatedDTO = new DiaryEntryDTO();
        final DiaryEntry diaryEntry = new DiaryEntry();
        Mockito.when(diaryEntryDtoConverter.convertFromDTO(updatedDTO)).thenReturn(diaryEntry);
        Mockito.when(diaryEntryService.update(id, diaryEntry)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> diaryEntryController.save(id, updatedDTO));
    }


    @Test
    @DisplayName("Test delete non-existent diary entry by ID")
    void testDeleteNonExistentDiaryEntry() {
        final Long id = 1L;
        Mockito.doThrow(ResourceNotFoundException.class).when(diaryEntryService).delete(id);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> diaryEntryController.delete(id));
    }


    @Test
    @DisplayName("Test get entry by invalid ID")
    void testGetEntryByInvalidId() {
        final Long id = 1L;
        Mockito.when(diaryEntryService.get(id)).thenThrow(UnauthorizedException.class);

        Assertions.assertThrows(UnauthorizedException.class, () -> diaryEntryController.get(id));
    }


    @Test
    @DisplayName("Test updateInternal invalid diary entry")
    void testUpdateInvalidDiaryEntry() {
        final Long id = 1L;
        final DiaryEntryDTO updatedDTO = new DiaryEntryDTO();
        final DiaryEntry diaryEntry = new DiaryEntry();
        Mockito.when(diaryEntryDtoConverter.convertFromDTO(updatedDTO)).thenReturn(diaryEntry);
        Mockito.when(diaryEntryService.update(id, diaryEntry)).thenThrow(UnauthorizedException.class);

        Assertions.assertThrows(UnauthorizedException.class, () -> diaryEntryController.save(id, updatedDTO));
    }


    @Test
    @DisplayName("Test delete invalid diary entry by ID")
    void testDeleteInvalidDiaryEntry() {
        final Long id = 1L;
        Mockito.doThrow(UnauthorizedException.class).when(diaryEntryService).delete(id);

        Assertions.assertThrows(UnauthorizedException.class, () -> diaryEntryController.delete(id));
    }
}

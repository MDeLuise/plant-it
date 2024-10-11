package com.github.mdeluise.plantit.unit.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.reminder.Reminder;
import com.github.mdeluise.plantit.reminder.ReminderController;
import com.github.mdeluise.plantit.reminder.ReminderDTO;
import com.github.mdeluise.plantit.reminder.ReminderDTOConverter;
import com.github.mdeluise.plantit.reminder.ReminderService;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrence;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrenceDTO;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrenceDTOConverter;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@ExtendWith(MockitoExtension.class)
@DisplayName("Unit tests for ReminderController")
class ReminderControllerUnitTests {
    @Mock
    private ReminderService reminderService;
    @Mock
    private ReminderDTOConverter reminderDTOConverter;
    @Mock
    private ReminderOccurrenceDTOConverter reminderOccurrenceDTOConverter;
    @InjectMocks
    private ReminderController reminderController;


    @Test
    @DisplayName("Test get all reminders")
    void testGetAllReminders() {
        final Reminder reminder = new Reminder();
        final ReminderDTO reminderDto = new ReminderDTO();
        Mockito.when(reminderService.getAll()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(reminderDTOConverter.convertToDTO(reminder)).thenReturn(reminderDto);
        final ResponseEntity<Collection<ReminderDTO>> responseEntity = reminderController.getAll();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(1, responseEntity.getBody().size());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get all reminders by plant ID")
    void testGetAllRemindersByPlantId() {
        final Reminder reminder = new Reminder();
        final ReminderDTO reminderDto = new ReminderDTO();
        Mockito.when(reminderService.getAll(Mockito.anyLong())).thenReturn(Collections.singletonList(reminder));
        Mockito.when(reminderDTOConverter.convertToDTO(reminder)).thenReturn(reminderDto);
        final ResponseEntity<Collection<ReminderDTO>> responseEntity = reminderController.getAll(1L);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(1, responseEntity.getBody().size());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test delete reminder by ID")
    void testDeleteReminderById() {
        reminderController.delete(1L);

        Mockito.verify(reminderService).remove(1L);
    }


    @Test
    @DisplayName("Test save reminder")
    void testSaveReminder() {
        final ReminderDTO reminderDTO = new ReminderDTO();
        final Reminder reminder = new Reminder();
        Mockito.when(reminderService.save(Mockito.any())).thenReturn(reminder);
        Mockito.when(reminderDTOConverter.convertToDTO(Mockito.any())).thenReturn(reminderDTO);
        final ResponseEntity<ReminderDTO> responseEntity = reminderController.save(reminderDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test updateInternal reminder by ID")
    void testUpdateReminderById() {
        final ReminderDTO reminderDTO = new ReminderDTO();
        final Reminder reminder = new Reminder();
        Mockito.when(reminderService.update(Mockito.anyLong(), Mockito.any())).thenReturn(reminder);
        Mockito.when(reminderDTOConverter.convertToDTO(Mockito.any())).thenReturn(reminderDTO);
        final ResponseEntity<ReminderDTO> responseEntity = reminderController.update(1L, reminderDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test delete non-existing reminder")
    void testDeleteNonExistingReminder() {
        final long id = 1;
        Mockito.doThrow(ResourceNotFoundException.class).when(reminderService).remove(id);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> reminderController.delete(id));
    }


    @Test
    @DisplayName("Test save reminder with invalid data")
    void testSaveInvalidReminder() {
        final ReminderDTO invalidReminderDTO = new ReminderDTO();
        Mockito.when(reminderService.save(Mockito.any())).thenThrow(UnauthorizedException.class);

        Assertions.assertThrows(UnauthorizedException.class, () -> reminderController.save(invalidReminderDTO));
    }


    @Test
    @DisplayName("Test updateInternal non-existing reminder")
    void testUpdateNonExistingReminder() {
        final long id = 1;
        final ReminderDTO reminderDTO = new ReminderDTO();
        Mockito.when(reminderService.update(id, reminderDTOConverter.convertFromDTO(reminderDTO)))
               .thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> reminderController.update(id, reminderDTO));
    }


    @Test
    @DisplayName("Test get occurrences")
    void testGetOccurrences() {
        final Date from  = new Date();
        final Date to  = new Date();
        final Pageable pageable = PageRequest.of(0, 25, Sort.by("id"));
        final List<ReminderOccurrence> pageContent = new ArrayList<>();
        final ReminderOccurrence reminderOccurrence = new ReminderOccurrence();
        final ReminderOccurrenceDTO reminderOccurrenceDTO = new ReminderOccurrenceDTO();
        pageContent.add(reminderOccurrence);
        final Page<ReminderOccurrence> occurrences = new PageImpl<>(pageContent);
        Mockito.when(reminderService.getAllOccurrences(null, null, from, to, pageable)).thenReturn(occurrences);
        Mockito.when(reminderOccurrenceDTOConverter.convertToDTO(reminderOccurrence)).thenReturn(reminderOccurrenceDTO);

        Assertions.assertEquals(reminderController.getOccurrences(null, null, from, to, pageable)
                                                  .getBody().getTotalElements(), 1);
    }
}
package com.github.mdeluise.plantit.unit.service;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.reminder.Reminder;
import com.github.mdeluise.plantit.reminder.ReminderRepository;
import com.github.mdeluise.plantit.reminder.ReminderService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for ReminderService")
class ReminderServiceUnitTests {
    @Mock
    private ReminderRepository reminderRepository;
    @Mock
    private PlantService plantService;
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @InjectMocks
    private ReminderService reminderService;


    @Test
    @DisplayName("Should get all reminders for a plant")
    void shouldGetAllRemindersForPlant() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long plantId = 1L;
        final Plant plant = new Plant();
        plant.setOwner(authenticated);
        final List<Reminder> reminders = Collections.singletonList(new Reminder());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantService.get(plantId)).thenReturn(plant);
        Mockito.when(reminderRepository.findAllByTargetAndTargetOwner(Mockito.any(), Mockito.any()))
               .thenReturn(reminders);

        final Collection<Reminder> result = reminderService.getAll(plantId);

        Assertions.assertThat(result).isEqualTo(reminders);
    }


    @Test
    @DisplayName("Should get all reminders")
    void shouldGetAllReminders() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Reminder reminder = new Reminder();
        final List<Reminder> reminders = Collections.singletonList(reminder);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findAllByTargetOwner(authenticated)).thenReturn(reminders);

        final Collection<Reminder> result = reminderService.getAll();

        Assertions.assertThat(result).isEqualTo(reminders);
    }


    @Test
    @DisplayName("Should remove expired reminders")
    void shouldRemoveExpiredReminders() {
        final Reminder reminder1 = new Reminder();
        reminder1.setEnd(new Date(System.currentTimeMillis() - 1000)); // Expired
        final Reminder reminder2 = new Reminder();
        reminder2.setEnd(new Date(System.currentTimeMillis() + 1000)); // Not expired
        Mockito.when(reminderRepository.findAll()).thenReturn(Arrays.asList(reminder1, reminder2));

        reminderService.removeExpired();

        Mockito.verify(reminderRepository, Mockito.times(1)).delete(reminder1);
        Mockito.verify(reminderRepository, Mockito.never()).delete(reminder2);
    }


    @Test
    @DisplayName("Should get reminder by ID")
    void shouldGetReminderById() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder reminder = new Reminder();
        final Plant plant = new Plant();
        plant.setOwner(authenticated);
        reminder.setTarget(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(reminder));

        final Reminder result = reminderService.get(reminderId);

        Assertions.assertThat(result).isEqualTo(reminder);
    }


    @Test
    @DisplayName("Should throw error when getting non-existing reminder by ID")
    void shouldThrowResourceNotFoundExceptionWhenGettingNonExistingReminderById() {
        final long reminderId = 1L;
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> reminderService.get(reminderId))
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should throw error when getting reminder not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenGettingReminderNotOwnedByAuthenticatedUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder reminder = new Reminder();
        final Plant plant = new Plant();
        plant.setOwner(new User());
        reminder.setTarget(plant);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(reminder));

        Assertions.assertThatThrownBy(() -> reminderService.get(reminderId)).isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should remove reminder by ID")
    void shouldRemoveReminderById() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder reminder = new Reminder();
        final Plant plant = new Plant();
        plant.setOwner(authenticated);
        reminder.setTarget(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(reminder));

        reminderService.remove(reminderId);

        Mockito.verify(reminderRepository, Mockito.times(1)).delete(reminder);
    }


    @Test
    @DisplayName("Should throw error when removing non-existing reminder by ID")
    void shouldThrowResourceNotFoundExceptionWhenRemovingNonExistingReminderById() {
        final long reminderId = 1L;
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> reminderService.remove(reminderId))
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should throw error when removing reminder not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenRemovingReminderNotOwnedByAuthenticatedUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder reminder = new Reminder();
        reminder.setTarget(new Plant());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(reminder));

        Assertions.assertThatThrownBy(() -> reminderService.remove(reminderId))
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should save reminder successfully")
    void shouldSaveReminderSuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Reminder reminderToSave = new Reminder();
        final Plant plant = new Plant();
        plant.setOwner(authenticated);
        reminderToSave.setTarget(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.save(reminderToSave)).thenReturn(reminderToSave);

        final Reminder result = reminderService.save(reminderToSave);

        Assertions.assertThat(result).isEqualTo(reminderToSave);
    }


    @Test
    @DisplayName("Should throw error when saving reminder for plant not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenSavingReminderForPlantNotOwnedByAuthenticatedUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long plantId = 1L;
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(new User());
        final Reminder reminderToSave = new Reminder();
        reminderToSave.setTarget(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantService.get(plantId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> reminderService.save(reminderToSave))
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should update reminder successfully")
    void shouldUpdateReminderSuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder existingReminder = new Reminder();
        final Reminder updatedReminder = new Reminder();
        final long plantId = 1L;
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(authenticated);
        existingReminder.setTarget(plant);
        existingReminder.setId(reminderId);
        updatedReminder.setId(reminderId);
        updatedReminder.setTarget(plant);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(existingReminder));
        Mockito.when(reminderRepository.save(updatedReminder)).thenReturn(updatedReminder);
        Mockito.when(plantService.get(plantId)).thenReturn(plant);

        final Reminder result = reminderService.update(reminderId, updatedReminder);

        Assertions.assertThat(result).isEqualTo(updatedReminder);
    }


    @Test
    @DisplayName("Should throw error when updating reminder not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenUpdatingReminderNotOwnedByAuthenticatedUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long reminderId = 1L;
        final Reminder existingReminder = new Reminder();
        final Reminder updatedReminder = new Reminder();
        final Plant plant = new Plant();
        plant.setOwner(new User());
        final Plant plant1 = new Plant();
        plant1.setOwner(new User());
        updatedReminder.setId(reminderId);
        updatedReminder.setTarget(plant);
        existingReminder.setTarget(plant1);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(reminderRepository.findById(reminderId)).thenReturn(Optional.of(existingReminder));

        Assertions.assertThatThrownBy(() -> reminderService.update(reminderId, updatedReminder))
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should throw error when updating non-existing reminder")
    void shouldThrowResourceNotFoundExceptionWhenUpdatingNonExistingReminder() {
        final long nonExistingReminderId = 1L;
        Mockito.when(reminderRepository.findById(nonExistingReminderId)).thenReturn(Optional.empty());
        final Reminder updatedReminder = new Reminder();

        Assertions.assertThatThrownBy(() -> reminderService.update(nonExistingReminderId, updatedReminder))
                  .isInstanceOf(ResourceNotFoundException.class);
    }
}

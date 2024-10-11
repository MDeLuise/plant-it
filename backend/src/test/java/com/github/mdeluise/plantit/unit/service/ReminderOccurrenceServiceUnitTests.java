package com.github.mdeluise.plantit.unit.service;

import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Optional;

import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.reminder.Reminder;
import com.github.mdeluise.plantit.reminder.frequency.Frequency;
import com.github.mdeluise.plantit.reminder.frequency.Unit;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrence;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrenceService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for ReminderOccurrenceService")
public class ReminderOccurrenceServiceUnitTests {
    @Mock
    private DiaryEntryService diaryEntryService;
    @InjectMocks
    private ReminderOccurrenceService service;


    @Test
    @DisplayName("Should get no occurrence if reminder starts after end date")
    void shouldGetNoOccurrenceIfReminderStartsAfterEndDate() {
        final Date start = new Date();
        final Date end = addToDate(new Date(), Calendar.SECOND, 1);
        final Reminder reminder = new Reminder();
        reminder.setStart(addToDate(new Date(), Calendar.SECOND, 2));
        reminder.setEnabled(true);

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).isEmpty();
    }


    @Test
    @DisplayName("Should get no occurrence if reminder end before start date")
    void shouldCreateReminderOccurrence() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.HOUR, -1);
        final Date reminderEndDate = addToDate(new Date(), Calendar.MINUTE, -1);
        final Date start = new Date();
        final Date end = addToDate(new Date(), Calendar.HOUR, 1);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setEnd(reminderEndDate);
        reminder.setEnabled(true);

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).isEmpty();
    }


    @Test
    @DisplayName("Should get no occurrence if reminder is disabled")
    void shouldGetNoOccurrenceIfReminderIsDisabled() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.DATE, -2);
        final Date start = addToDate(reminderStartDate, Calendar.DATE, 1);
        final Date end = addToDate(start, Calendar.DATE, 2);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final long plantId = 42;
        final DiaryEntryType type = DiaryEntryType.WATERING;
        final Plant target = new Plant();
        target.setId(plantId);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setFrequency(frequency);
        reminder.setEnabled(false);
        reminder.setAction(type);
        reminder.setTarget(target);
        Mockito.when(diaryEntryService.getLast(plantId, type)).thenReturn(Optional.empty());

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).isEmpty();
    }


    @Test
    @DisplayName("Should get the occurrences correctly when reminder has no end date")
    void shouldGetOccurrencesCorrectlyWhenReminderHasNoEndDate() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.DATE, -2);
        final Date start = addToDate(reminderStartDate, Calendar.DATE, 1);
        final Date end = addToDate(start, Calendar.DATE, 2);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final long plantId = 42;
        final DiaryEntryType type = DiaryEntryType.WATERING;
        final Plant target = new Plant();
        target.setId(plantId);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setFrequency(frequency);
        reminder.setEnabled(true);
        reminder.setAction(type);
        reminder.setTarget(target);
        Mockito.when(diaryEntryService.getLast(plantId, type)).thenReturn(Optional.empty());

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).hasSize(1);
    }


    @Test
    @DisplayName("Should get the occurrences correctly when reminder has end date")
    void shouldGetOccurrencesCorrectlyWhenReminderHasEndDate() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.DATE, -4);
        final Date reminderEndDate = addToDate(new Date(), Calendar.DATE, 2);
        final Date start = addToDate(reminderStartDate, Calendar.DATE, 1);
        final Date end = addToDate(start, Calendar.DATE, 2);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final long plantId = 42;
        final DiaryEntryType type = DiaryEntryType.WATERING;
        final Plant target = new Plant();
        target.setId(plantId);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setEnd(reminderEndDate);
        reminder.setFrequency(frequency);
        reminder.setEnabled(true);
        reminder.setAction(type);
        reminder.setTarget(target);
        Mockito.when(diaryEntryService.getLast(plantId, type)).thenReturn(Optional.empty());

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).hasSize(1);
    }


    @Test
    @DisplayName("Should get all the occurrences correctly")
    void shouldGetAllOccurrencesCorrectly() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.MONTH, -2);
        final Date start = addToDate(reminderStartDate, Calendar.MONTH, 2);
        final Date end = addToDate(start, Calendar.MONTH, 3);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.MONTHS);
        frequency.setQuantity(1);
        final long plantId = 42;
        final DiaryEntryType type = DiaryEntryType.WATERING;
        final Plant target = new Plant();
        target.setId(plantId);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setFrequency(frequency);
        reminder.setEnabled(true);
        reminder.setAction(type);
        reminder.setTarget(target);
        Mockito.when(diaryEntryService.getLast(plantId, type)).thenReturn(Optional.empty());

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).hasSize(2);
    }


    @Test
    @DisplayName("Should get all the occurrences correctly with different frequency amount")
    void shouldGetAllOccurrencesCorrectlyWithDifferentFrequencyAmount() {
        final Date reminderStartDate = addToDate(new Date(), Calendar.DATE, -2);
        final Date start = addToDate(reminderStartDate, Calendar.DATE, 2);
        final Date end = addToDate(start, Calendar.DATE, 3);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(2);
        final long plantId = 42;
        final DiaryEntryType type = DiaryEntryType.WATERING;
        final Plant target = new Plant();
        target.setId(plantId);
        final Reminder reminder = new Reminder();
        reminder.setStart(reminderStartDate);
        reminder.setFrequency(frequency);
        reminder.setEnabled(true);
        reminder.setAction(type);
        reminder.setTarget(target);
        Mockito.when(diaryEntryService.getLast(plantId, type)).thenReturn(Optional.empty());

        final Collection<ReminderOccurrence> occurrences = service.getOccurrences(reminder, start, end);

        Assertions.assertThat(occurrences).hasSize(1);
    }


    private Date addToDate(Date date, int unit, int amount) {
        final Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.add(unit, amount);
        return c.getTime();
    }
}

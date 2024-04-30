package com.github.mdeluise.plantit.unit.component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.console.ConsoleNotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.reminder.Reminder;
import com.github.mdeluise.plantit.reminder.ReminderDispatcher;
import com.github.mdeluise.plantit.reminder.ReminderRepository;
import com.github.mdeluise.plantit.reminder.frequency.Frequency;
import com.github.mdeluise.plantit.reminder.frequency.Unit;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.internal.util.collections.Sets;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for ReminderDispatcher")
public class ReminderDispatcherUnitTests {
    @Mock
    private ReminderRepository reminderRepository;
    @Mock
    private DiaryEntryService diaryEntryService;
    private ReminderDispatcher reminderDispatcher;


    @Test
    @DisplayName("Should not dispatch a reminder with a start date in future")
    void shouldNotDispatchFutureReminder() throws NotifyException {
        final Reminder reminder = new Reminder();
        reminder.setTarget(new Plant());
        reminder.setStart(new Date(System.currentTimeMillis() + 10000));
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.empty());

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.never()).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName("Should dispatch a reminder with a start date in past, no lastNotified, no last event")
    void shouldDispatchPastReminderWithNoLastNotified() throws NotifyException {
        final User user = new User();
        final Reminder reminder = new Reminder();
        final Plant plant = new Plant();
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        plant.setOwner(user);
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 10000));
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.empty());

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.times(1)).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName(
        "Should dispatch a reminder with start date in past, lastNotified according to frequency and repeatAfter"
    )
    void shouldDispatchPastReminderWithLastNotifiedAccordingToFrequencyAndRepeatAfter() throws NotifyException {
        final User user = new User();
        final Reminder reminder = new Reminder();
        final Plant plant = new Plant();
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(0);
        plant.setOwner(user);
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 10000));
        reminder.setFrequency(frequency);
        reminder.setRepeatAfter(frequency);
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.empty());

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.times(1)).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName(
        "Should not dispatch a reminder with start date in past, lastNotified according to frequency but no repeatAfter"
    )
    void shouldNotDispatchPastReminderWithLastNotifiedAccordingToFrequencyButNoRepeatAfter() throws NotifyException {
        final Plant plant = new Plant();
        final User user = new User();
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        plant.setOwner(user);
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(0);
        final Frequency repeatAfter = new Frequency();
        repeatAfter.setUnit(Unit.DAYS);
        repeatAfter.setQuantity(1);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDate(new Date(System.currentTimeMillis() - 5000));
        final Reminder reminder = new Reminder();
        reminder.setAction(DiaryEntryType.WATERING);
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 10000));
        reminder.setLastNotified(new Date(System.currentTimeMillis() - 10000));
        reminder.setFrequency(frequency);
        reminder.setRepeatAfter(repeatAfter);
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.of(diaryEntry));

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.never()).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName(
        "Should not dispatch a reminder with start date in past, lastNotified not according to frequency"
    )
    void shouldNotDispatchPastReminderWithLastNotifiedNotAccordingToFrequency() throws NotifyException {
        final Plant plant = new Plant();
        final User user = new User();
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        plant.setOwner(user);
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final Frequency repeatAfter = new Frequency();
        repeatAfter.setUnit(Unit.DAYS);
        repeatAfter.setQuantity(0);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDate(new Date(System.currentTimeMillis() - 5000));
        final Reminder reminder = new Reminder();
        reminder.setAction(DiaryEntryType.WATERING);
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 10000));
        reminder.setFrequency(frequency);
        reminder.setRepeatAfter(repeatAfter);
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.of(diaryEntry));

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.never()).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName(
        "Should dispatch a reminder with start date in past, lastNotified existing and according to frequency and repeatAfter"
    )
    void shouldDispatchPastReminderWithLastNotifiedExistingAndAccordingToFrequencyAndRepeatAfter() throws NotifyException {
        final Plant plant = new Plant();
        final User user = new User();
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        plant.setOwner(user);
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final Frequency repeatAfter = new Frequency();
        repeatAfter.setUnit(Unit.DAYS);
        repeatAfter.setQuantity(0);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDate(new Date(System.currentTimeMillis() - 302400000)); // 3,5 days ago
        final Reminder reminder = new Reminder();
        reminder.setAction(DiaryEntryType.WATERING);
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 345600000)); // 4 days ago
        reminder.setFrequency(frequency);
        reminder.setRepeatAfter(repeatAfter);
        reminder.setLastNotified(new Date(System.currentTimeMillis() - 172800000)); // 2 days ago
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.of(diaryEntry));

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.times(1)).notifyReminder(Mockito.any());
    }


    @Test
    @DisplayName(
        "Should not dispatch a reminder with start date in past, lastNotified existing but not according to frequency"
    )
    void shouldDispatchPastReminderWithLastNotifiedExistingButNotAccordingToFrequency() throws NotifyException {
        final Plant plant = new Plant();
        final User user = new User();
        user.setNotificationDispatchers(Sets.newSet(NotificationDispatcherName.CONSOLE));
        plant.setOwner(user);
        final NotificationDispatcher dispatcher = Mockito.mock(ConsoleNotificationDispatcher.class);
        final Frequency frequency = new Frequency();
        frequency.setUnit(Unit.DAYS);
        frequency.setQuantity(1);
        final Frequency repeatAfter = new Frequency();
        repeatAfter.setUnit(Unit.DAYS);
        repeatAfter.setQuantity(2);
        final DiaryEntry diaryEntry = new DiaryEntry();
        diaryEntry.setDate(new Date(System.currentTimeMillis() - 302400000)); // 3,5 days ago
        final Reminder reminder = new Reminder();
        reminder.setAction(DiaryEntryType.WATERING);
        reminder.setTarget(plant);
        reminder.setStart(new Date(System.currentTimeMillis() - 345600000)); // 4 days ago
        reminder.setFrequency(frequency);
        reminder.setRepeatAfter(repeatAfter);
        reminder.setLastNotified(new Date(System.currentTimeMillis() - 86400000)); // 1 day ago
        final List<NotificationDispatcher> dispatchers = new ArrayList<>(Collections.singleton(dispatcher));
        reminderDispatcher = new ReminderDispatcher(dispatchers, reminderRepository, diaryEntryService);
        Mockito.when(dispatcher.getName()).thenReturn(NotificationDispatcherName.CONSOLE);
        Mockito.when(dispatcher.isEnabled()).thenReturn(true);
        Mockito.when(reminderRepository.findAllByEnabledTrue()).thenReturn(Collections.singletonList(reminder));
        Mockito.when(diaryEntryService.getLast(Mockito.any(), Mockito.any())).thenReturn(Optional.of(diaryEntry));

        reminderDispatcher.dispatch();

        Mockito.verify(dispatcher, Mockito.never()).notifyReminder(Mockito.any());
    }
}

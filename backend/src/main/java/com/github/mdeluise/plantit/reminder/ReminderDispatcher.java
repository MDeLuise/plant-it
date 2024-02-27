package com.github.mdeluise.plantit.reminder;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.notification.NotifyException;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcher;
import com.github.mdeluise.plantit.notification.dispatcher.NotificationDispatcherName;
import com.github.mdeluise.plantit.reminder.frequency.Frequency;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ReminderDispatcher {
    private final List<NotificationDispatcher> notificationsDispatchers;
    private final ReminderRepository reminderRepository;
    private final DiaryEntryService diaryEntryService;
    private final Logger logger = LoggerFactory.getLogger(ReminderDispatcher.class);


    @Autowired
    public ReminderDispatcher(List<NotificationDispatcher> notificationsDispatchers,
                              ReminderRepository reminderRepository, DiaryEntryService diaryEntryService) {
        this.notificationsDispatchers = notificationsDispatchers;
        this.reminderRepository = reminderRepository;
        this.diaryEntryService = diaryEntryService;
    }


    @Transactional
    public void dispatch() {
        logger.info("Starting reminder dispatching...");
        reminderRepository.findAllByEnabledTrue().forEach(reminder -> {
            if (isToNotify(reminder)) {
                logger.debug("Reminder {} is to dispatch", reminder.getId());
                dispatchInternal(reminder);
            }
        });
    }


    @SuppressWarnings("ReturnCount") //FIXME
    private boolean isToNotify(Reminder reminder) {
        final Optional<DiaryEntry> lastEntry =
            diaryEntryService.getLast(reminder.getTarget().getId(), reminder.getAction());
        final Date now = new Date();
        if (reminder.getStart().after(now)) {
            return false;
        }

        // Case 1: No last entry, start date is before now, and no last notification
        if (lastEntry.isEmpty() && reminder.getStart().before(now) && reminder.getLastNotified() == null) {
            return true;
        }

        // Case 2: No last entry, start date is before now, and last notification is before repeatAfter time
        if (lastEntry.isEmpty() && reminder.getStart().before(now) && reminder.getLastNotified() != null && new Date(
            reminder.getLastNotified().getTime() + calculateMilliseconds(reminder.getRepeatAfter())).before(now)) {
            return true;
        }

        // Case 3: Last entry exists, but time since last entry is greater than frequency
        return lastEntry.map(entry -> {
            if (isEntryOlderThanFrequency(entry, reminder.getFrequency())) {
                // No last notification
                if (reminder.getLastNotified() == null) {
                    return true;
                }
                // Time since last notification is greater than frequency
                return new Date(
                    reminder.getLastNotified().getTime() + calculateMilliseconds(reminder.getRepeatAfter())).before(now);
            }
            return false;
        }).orElse(false);
    }


    private void dispatchInternal(Reminder reminder) {
        final Set<NotificationDispatcher> notificationDispatchersToUse = getUserNotificationDispatcher(reminder);
        notificationDispatchersToUse.forEach(dispatcher -> {
            try {
                dispatcher.notifyReminder(reminder);
            } catch (NotifyException e) {
                logger.error("Error while dispatch reminder {} using dispatcher {}", reminder.getId(),
                             dispatcher.getName(), e
                );
            }
        });
        reminder.setLastNotified(new Date());
        reminderRepository.save(reminder);
    }


    protected Set<NotificationDispatcher> getUserNotificationDispatcher(Reminder reminder) {
        final Set<NotificationDispatcherName> userNotificationDispatchers =
            reminder.getTarget().getOwner().getNotificationDispatchers();
        return notificationsDispatchers.stream().filter(NotificationDispatcher::isEnabled).filter(
                                           notificationDispatcher -> userNotificationDispatchers.contains(notificationDispatcher.getName()))
                                       .collect(Collectors.toSet());
    }


    private boolean isEntryOlderThanFrequency(DiaryEntry entry, Frequency frequency) {
        final Date now = new Date();
        final Date lastEntryDate = entry.getDate();
        final long millisSinceLastEntry = now.getTime() - lastEntryDate.getTime();
        final long millisInFrequency = calculateMilliseconds(frequency);
        return millisSinceLastEntry > millisInFrequency;
    }


    private long calculateMilliseconds(Frequency frequency) {
        long millisInUnit = switch (frequency.getUnit()) {
            case DAYS -> 24L * 60 * 60 * 1000;
            case WEEKS -> 7L * 24 * 60 * 60 * 1000;
            case MONTHS -> {
                final Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.MONTH, frequency.getQuantity());
                yield calendar.getTimeInMillis();
            }
            case YEARS -> {
                final Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, frequency.getQuantity());
                yield calendar.getTimeInMillis();
            }
        };
        return millisInUnit * frequency.getQuantity();
    }
}

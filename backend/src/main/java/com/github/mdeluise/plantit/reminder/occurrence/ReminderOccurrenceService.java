package com.github.mdeluise.plantit.reminder.occurrence;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.reminder.Reminder;
import com.github.mdeluise.plantit.reminder.frequency.Frequency;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReminderOccurrenceService {
    private final DiaryEntryService diaryEntryService;


    @Autowired
    public ReminderOccurrenceService(DiaryEntryService diaryEntryService) {
        this.diaryEntryService = diaryEntryService;
    }


    public Collection<ReminderOccurrence> getOccurrences(Reminder reminder, Date start, Date end) {
        if (!reminder.isEnabled() || reminder.getStart().after(end) ||
                reminder.getEnd() != null && reminder.getEnd().before(start)) {
            return List.of();
        }

        final List<ReminderOccurrence> occurrences = new ArrayList<>();
        final Optional<DiaryEntry> lastAction = diaryEntryService.getLast(
            reminder.getTarget().getId(), reminder.getAction());
        Date occurrenceDate;
        if (lastAction.isPresent()) {
            final Date lastActionDate = lastAction.get().getDate();
            occurrenceDate = addToDateOneStep(lastActionDate, reminder.getFrequency());
        } else {
            occurrenceDate = reminder.getStart();
        }
        while (occurrenceDate.before(end)) {
            if (occurrenceDate.after(start)) {
                final ReminderOccurrence occurrence = new ReminderOccurrence();
                occurrence.setDate(occurrenceDate);
                occurrence.setReminder(reminder);
                occurrences.add(occurrence);
            }
            occurrenceDate = addToDateOneStep(occurrenceDate, reminder.getFrequency());
        }
        return occurrences;
    }


    private Date addToDateOneStep(Date date, Frequency frequency) {
        final Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(frequency.getUnit().toCalendarField(), Math.max(1, frequency.getQuantity()));
        return calendar.getTime();
    }

}

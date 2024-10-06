package com.github.mdeluise.plantit.reminder;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrence;
import com.github.mdeluise.plantit.reminder.occurrence.ReminderOccurrenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ReminderService {
    private final ReminderRepository reminderRepository;
    private final PlantService plantService;
    private final AuthenticatedUserService authenticatedUserService;
    private final ReminderOccurrenceService reminderOccurrenceService;


    @Autowired
    public ReminderService(ReminderRepository reminderRepository, PlantService plantService,
                           AuthenticatedUserService authenticatedUserService,
                           ReminderOccurrenceService reminderOccurrenceService) {
        this.reminderRepository = reminderRepository;
        this.plantService = plantService;
        this.authenticatedUserService = authenticatedUserService;
        this.reminderOccurrenceService = reminderOccurrenceService;
    }


    public Collection<Reminder> getAll(long plantId) {
        final Plant plant = plantService.get(plantId);
        return reminderRepository.findAllByTargetAndTargetOwner(plant, authenticatedUserService.getAuthenticatedUser());
    }


    public Collection<Reminder> getAll() {
        return reminderRepository.findAllByTargetOwner(authenticatedUserService.getAuthenticatedUser());
    }


    public void removeExpired() {
        reminderRepository.findAll().forEach(reminder -> {
            if (reminder.getEnd() != null && reminder.getEnd().before(new Date())) {
                reminderRepository.delete(reminder);
            }
        });
    }


    public Reminder get(long id) {
        final Reminder result = reminderRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result.getTarget().getOwner() != authenticatedUserService.getAuthenticatedUser()) {
            throw new UnauthorizedException();
        }
        return result;
    }


    public void remove(long id) {
        final Reminder toDelete = get(id);
        reminderRepository.delete(toDelete);
    }


    public Reminder update(long id, Reminder updated) {
        final Reminder toUpdate = get(id);
        plantService.get(updated.getTarget().getId()); // check if authorized

        toUpdate.setAction(updated.getAction());
        toUpdate.setStart(updated.getStart());
        toUpdate.setEnd(updated.getEnd());
        toUpdate.setFrequency(updated.getFrequency());
        toUpdate.setEnabled(updated.isEnabled());
        toUpdate.setTarget(updated.getTarget());
        toUpdate.setRepeatAfter(updated.getRepeatAfter());
        toUpdate.setLastNotified(updated.getLastNotified());
        return reminderRepository.save(toUpdate);
    }


    public Reminder save(Reminder reminder) {
        plantService.get(reminder.getTarget().getId()); // check if authorized
        return reminderRepository.save(reminder);
    }


    public void deleteAll() {
        reminderRepository.findAll().forEach(reminder -> remove(reminder.getId()));
    }


    public Collection<Reminder> getAllFiltered(DiaryEntryType type, Long plantId) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        if (type == null && plantId == null) {
            return reminderRepository.findAllByTargetOwner(authenticatedUser);
        } else if (type == null) {
            final Plant plant = plantService.get(plantId);
            return reminderRepository.findAllByTargetAndTargetOwner(plant, authenticatedUser);
        } else {
            return reminderRepository.findAllByTargetOwnerAndAction(authenticatedUser, type);
        }
    }


    public Page<ReminderOccurrence> getAllOccurrences(DiaryEntryType type, Long plantId, Date from, Date to,
                                                      Pageable pageable) {
        final Collection<Reminder> allFiltered = getAllFiltered(type, plantId);
        final List<ReminderOccurrence> occurrences = new ArrayList<>();
        for (Reminder reminder : allFiltered) {
            occurrences.addAll(reminderOccurrenceService.getOccurrences(reminder, from, to));
        }
        final int start = Math.min((int) pageable.getOffset(), occurrences.size());
        final int end = Math.min(start + pageable.getPageSize(), occurrences.size());
        final List<ReminderOccurrence> pageContent = occurrences.subList(start, end);
        return new PageImpl<>(pageContent, pageable, occurrences.size());
    }
}

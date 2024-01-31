package com.github.mdeluise.plantit.diary.entry;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantRepository;
import com.github.mdeluise.plantit.plant.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class DiaryEntryService {
    private final AuthenticatedUserService authenticatedUserService;
    private final DiaryEntryRepository diaryEntryRepository;
    private final DiaryService diaryService;
    private final PlantService plantService;
    private final PlantRepository plantRepository;


    @Autowired
    public DiaryEntryService(AuthenticatedUserService authenticatedUserService,
                             DiaryEntryRepository diaryEntryRepository, DiaryService diaryService,
                             PlantService plantService, PlantRepository plantRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.diaryEntryRepository = diaryEntryRepository;
        this.diaryService = diaryService;
        this.plantService = plantService;
        this.plantRepository = plantRepository;
    }


    public Page<DiaryEntry> getAll(Pageable pageable, List<Long> plantIds, List<String> eventTypes) {
        checkPlantExistenceAndVisibility(plantIds);
        checkEventTypeExistence(eventTypes);

        if (plantIds.isEmpty() && eventTypes.isEmpty()) {
            return diaryEntryRepository.findAllByDiaryOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
        }

        final Pageable pageableToUse = PageRequest.of(0, Math.max(1, count().intValue()), pageable.getSort());
        final List<DiaryEntry> filteredResult =
            diaryEntryRepository.findAllByDiaryOwner(
                authenticatedUserService.getAuthenticatedUser(), pageableToUse).stream()
                .filter(entry -> plantIds.isEmpty() || plantIds.contains(entry.getDiary().getTarget().getId()))
                .filter(entry -> eventTypes.isEmpty() || eventTypes.contains(entry.getType().name()))
                .toList();

        final int start = (int) pageable.getOffset();
        final int end = Math.min(start + pageable.getPageSize(), filteredResult.size());
        return new PageImpl<>(filteredResult.subList(start, end), pageable, filteredResult.size());
    }


    private void checkEventTypeExistence(List<String> eventTypes) {
        eventTypes.forEach(DiaryEntryType::valueOf);
    }


    private void checkPlantExistenceAndVisibility(List<Long> plantIds) {
        plantIds.forEach(plantService::get);
    }


    public Page<DiaryEntry> getAll(Long diaryId, Pageable pageable) {
        final Diary diary = diaryService.get(diaryId);
        return diaryEntryRepository.findAllByDiaryOwnerAndDiary(
            authenticatedUserService.getAuthenticatedUser(), diary, pageable);
    }


    public Collection<DiaryEntryType> getAllTypes() {
        final DiaryEntryType[] result = DiaryEntryType.class.getEnumConstants();
        return List.of(result);
    }


    public DiaryEntry save(DiaryEntry diaryEntry) {
        final Diary diary = diaryService.get(diaryEntry.getDiary().getId());
        final User diaryOwner = diary.getOwner();
        if (!diaryOwner.equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        return diaryEntryRepository.save(diaryEntry);
    }


    public DiaryEntry get(Long id) {
        final DiaryEntry result =
            diaryEntryRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!result.getDiary().getOwner().equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        return result;
    }


    public void delete(Long diaryEntryId) {
        final DiaryEntry toDelete = get(diaryEntryId);
        diaryEntryRepository.delete(toDelete);
    }


    public DiaryEntry update(Long id, DiaryEntry updated) {
        final DiaryEntry toUpdate = get(id);
        if (updated.getDiary() == null) {
            updated.setDiary(toUpdate.getDiary());
        }
        updated.getDiary().setOwner(authenticatedUserService.getAuthenticatedUser());
        updated.setId(id);
        return diaryEntryRepository.save(updated);
    }


    public Long count() {
        return diaryEntryRepository.countByDiaryOwner(authenticatedUserService.getAuthenticatedUser());
    }


    public Long count(Long plantId) {
        diaryService.get(plantId);
        return diaryEntryRepository.countByDiaryOwnerAndDiaryTargetId(
            authenticatedUserService.getAuthenticatedUser(), plantId);
    }


    public Collection<DiaryEntryStats> getStats(Long plantId) {
        diaryService.get(plantId);
        final Collection<DiaryEntryStats> result = new HashSet<>();
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        for (DiaryEntryType type : getAllTypes()) {
            final Optional<DiaryEntry> lastEvent =
                diaryEntryRepository.findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(authenticatedUser, plantId,
                                                                                                 type
                );
            lastEvent.ifPresent(
                diaryEntry -> result.add(new DiaryEntryStats(diaryEntry.getType(), diaryEntry.getDate())));
        }
        final List<DiaryEntryStats> sortedResult = new ArrayList<>(result.stream().toList());
        sortedResult.sort(Comparator.comparing(DiaryEntryStats::date));
        Collections.reverse(sortedResult);
        return sortedResult;
    }


    public Optional<DiaryEntry> getLast(Long plantId, DiaryEntryType type) {
        final Plant plant = plantRepository.findById(plantId).orElseThrow(() -> new ResourceNotFoundException(plantId));
        return diaryEntryRepository.findFirstByDiaryTargetAndType(plant, type);
    }
}

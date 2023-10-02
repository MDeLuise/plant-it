package com.github.mdeluise.plantit.diary;

import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class DiaryService {
    private final AuthenticatedUserService authenticatedUserService;
    private final DiaryRepository diaryRepository;
    private final PlantService plantService;


    @Autowired
    protected DiaryService(AuthenticatedUserService authenticatedUserService, DiaryRepository diaryRepository,
                           PlantService plantService) {
        this.authenticatedUserService = authenticatedUserService;
        this.diaryRepository = diaryRepository;
        this.plantService = plantService;
    }


    public Page<Diary> getAll(Pageable pageable) {
        return diaryRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    public Diary get(Long targetId) {
        final Plant plant = plantService.get(targetId);
        return diaryRepository.findByOwnerAndTarget(authenticatedUserService.getAuthenticatedUser(), plant)
                              .orElseThrow(() -> new ResourceNotFoundException(targetId));
    }
}

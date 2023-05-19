package com.github.mdeluise.plantit.diary;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import com.github.mdeluise.plantit.tracked.TrackedEntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class DiaryService extends AbstractAuthenticatedService {
    private final DiaryRepository diaryRepository;
    private final TrackedEntityService trackedEntityService;


    @Autowired
    protected DiaryService(UserService userService, DiaryRepository diaryRepository,
                           TrackedEntityService trackedEntityService) {
        super(userService);
        this.diaryRepository = diaryRepository;
        this.trackedEntityService = trackedEntityService;
    }


    public Page<Diary> getAll(Pageable pageable) {
        return diaryRepository.findAllByOwner(getAuthenticatedUser(), pageable);
    }


    public Diary get(Long targetId) {
        AbstractTrackedEntity abstractTrackedEntity = trackedEntityService.get(targetId);
        return diaryRepository.findByOwnerAndTarget(getAuthenticatedUser(), abstractTrackedEntity)
                              .orElseThrow(() -> new ResourceNotFoundException(targetId));
    }
}

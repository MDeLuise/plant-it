package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class TrackedEntityService extends AbstractAuthenticatedService {
    private final TrackedEntityRepository trackedEntityRepository;


    @Autowired
    public TrackedEntityService(UserService userService, TrackedEntityRepository trackedEntityRepository) {
        super(userService);
        this.trackedEntityRepository = trackedEntityRepository;
    }


    public Page<AbstractTrackedEntity> getAll(Pageable pageable) {
        return trackedEntityRepository.findAllByOwner(getAuthenticatedUser(), pageable);
    }


    public AbstractTrackedEntity get(Long id) {
        return trackedEntityRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public Page<AbstractTrackedEntity> getAll(TrackedEntityType type, Pageable pageable) {
        return trackedEntityRepository.findAllByOwnerAndType(getAuthenticatedUser(), type, pageable);
    }


    public long count() {
        return trackedEntityRepository.count();
    }

}

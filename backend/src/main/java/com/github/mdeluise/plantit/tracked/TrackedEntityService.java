package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class TrackedEntityService extends AbstractAuthenticatedService {
    private final TrackedEntityRepository trackedEntityRepository;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public TrackedEntityService(UserService userService, TrackedEntityRepository trackedEntityRepository,
                                BotanicalInfoService botanicalInfoService) {
        super(userService);
        this.trackedEntityRepository = trackedEntityRepository;
        this.botanicalInfoService = botanicalInfoService;
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


    @Transactional
    // https://stackoverflow.com/questions/13370221/persistentobjectexception-detached-entity-passed-to-persist-thrown-by-jpa-and-h
    public AbstractTrackedEntity save(AbstractTrackedEntity toSave) {
        toSave.setOwner(getAuthenticatedUser());
        if (toSave.getDiary() == null) {
            final Diary diary = new Diary();
            diary.setTarget(toSave);
            toSave.setDiary(diary);
            toSave.getDiary().setOwner(getAuthenticatedUser());
        }
        if (toSave instanceof Plant p && p.getBotanicalInfo().getId() != null) {
            p.setBotanicalInfo(botanicalInfoService.get(p.getBotanicalInfo().getId()));
        }
        return trackedEntityRepository.save(toSave);
    }
}

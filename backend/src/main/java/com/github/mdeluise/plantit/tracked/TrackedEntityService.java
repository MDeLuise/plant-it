package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.tracked.plant.Plant;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class TrackedEntityService {
    private final AuthenticatedUserService authenticatedUserService;
    private final TrackedEntityRepository trackedEntityRepository;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public TrackedEntityService(AuthenticatedUserService authenticatedUserService,
                                TrackedEntityRepository trackedEntityRepository,
                                BotanicalInfoService botanicalInfoService) {
        this.authenticatedUserService = authenticatedUserService;
        this.trackedEntityRepository = trackedEntityRepository;
        this.botanicalInfoService = botanicalInfoService;
    }


    @Cacheable(value = "tracked-entities", key = "{#pageable, @authenticatedUserService.getAuthenticatedUser().id}")
    public Page<AbstractTrackedEntity> getAll(Pageable pageable) {
        return trackedEntityRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    @Cacheable(value = "tracked-entities", key = "{#id, @authenticatedUserService.getAuthenticatedUser().id}")
    public AbstractTrackedEntity get(Long id) {
        return trackedEntityRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public Page<AbstractTrackedEntity> getAll(TrackedEntityType type, Pageable pageable) {
        return trackedEntityRepository.findAllByOwnerAndType(
            authenticatedUserService.getAuthenticatedUser(), type, pageable);
    }


    public long count() {
        return trackedEntityRepository.count();
    }


    @Caching(
        evict = {
            @CacheEvict(value = "tracked-entities", allEntries = true), @CacheEvict(
            value = "botanical-info", allEntries = true,
            condition = "#toSave instanceof T(com.github.mdeluise.plantit.tracked.plant.Plant) &&" +
                            "#toSave.botanicalInfo instanceof T(com.github.mdeluise.plantit.botanicalinfo" +
                            ".UserCreatedBotanicalInfo)"
        )
        }
    )
    @Transactional
    // https://stackoverflow.com/questions/13370221/persistentobjectexception-detached-entity-passed-to-persist-thrown-by-jpa-and-h
    public AbstractTrackedEntity save(AbstractTrackedEntity toSave) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        toSave.setOwner(authenticatedUser);
        if (toSave.getDiary() == null) {
            final Diary diary = new Diary();
            diary.setTarget(toSave);
            toSave.setDiary(diary);
            toSave.getDiary().setOwner(authenticatedUser);
        }
        if (toSave instanceof Plant p && p.getBotanicalInfo().getId() != null) {
            p.setBotanicalInfo(botanicalInfoService.get(p.getBotanicalInfo().getId()));
        }
        if (toSave instanceof Plant p && p.getBotanicalInfo() instanceof UserCreatedBotanicalInfo u) {
            u.setCreator(authenticatedUser);
        }
        return trackedEntityRepository.save(toSave);
    }
}

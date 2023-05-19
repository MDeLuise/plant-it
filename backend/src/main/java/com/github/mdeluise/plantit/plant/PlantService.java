package com.github.mdeluise.plantit.plant;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
public class PlantService {
    private final AuthenticatedUserService authenticatedUserService;
    private final PlantRepository plantRepository;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public PlantService(AuthenticatedUserService authenticatedUserService, PlantRepository plantRepository,
                        BotanicalInfoService botanicalInfoService) {
        this.authenticatedUserService = authenticatedUserService;
        this.plantRepository = plantRepository;
        this.botanicalInfoService = botanicalInfoService;
    }


    @Cacheable(
        value = "plants",
        key = "{#pageable, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public Page<Plant> getAll(Pageable pageable) {
        return plantRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    @Cacheable(
        value = "plants",
        key = "{#id, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public Plant get(Long id) {
        return plantRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public long count() {
        return plantRepository.countByOwner(authenticatedUserService.getAuthenticatedUser());
    }


    @Caching(
        evict = {
            @CacheEvict(value = "plants", allEntries = true),
            @CacheEvict(
                value = "botanical-info", allEntries = true,
                condition = "#toSave.botanicalInfo instanceof T(com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo)"
            )
        }
    )
    @Transactional
    // https://stackoverflow.com/questions/13370221/persistentobjectexception-detached-entity-passed-to-persist-thrown-by-jpa-and-h
    public Plant save(Plant toSave) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        toSave.setOwner(authenticatedUser);
        if (toSave.getDiary() == null) {
            final Diary diary = new Diary();
            diary.setTarget(toSave);
            toSave.setDiary(diary);
            toSave.getDiary().setOwner(authenticatedUser);
        }
        if (toSave.getBotanicalInfo().getId() != null) {
            toSave.setBotanicalInfo(botanicalInfoService.get(toSave.getBotanicalInfo().getId()));
        } else if (toSave.getBotanicalInfo().getImage() != null) {
            toSave.getBotanicalInfo().getImage().setTarget(toSave.getBotanicalInfo());
        }
        if (toSave.getBotanicalInfo() instanceof UserCreatedBotanicalInfo u) {
            u.setCreator(authenticatedUser);
        }
        return plantRepository.save(toSave);
    }


    public long getNumberOfDistinctBotanicalInfo() {
        return getAll(Pageable.unpaged()).getContent().stream()
                                         .map(entity -> entity.getBotanicalInfo().getId())
                                         .collect(Collectors.toSet()).size();
    }
}

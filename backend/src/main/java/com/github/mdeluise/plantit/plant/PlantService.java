package com.github.mdeluise.plantit.plant;

import java.util.Optional;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class PlantService {
    private final AuthenticatedUserService authenticatedUserService;
    private final PlantRepository plantRepository;
    private final BotanicalInfoService botanicalInfoService;
    private final ImageStorageService imageStorageService;


    @Autowired
    public PlantService(AuthenticatedUserService authenticatedUserService, PlantRepository plantRepository,
                        BotanicalInfoService botanicalInfoService, ImageStorageService imageStorageService) {
        this.authenticatedUserService = authenticatedUserService;
        this.plantRepository = plantRepository;
        this.botanicalInfoService = botanicalInfoService;
        this.imageStorageService = imageStorageService;
    }


    @Cacheable(
        value = "plants", key = "{#pageable, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public Page<Plant> getAll(Pageable pageable) {
        return plantRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    @Cacheable(
        value = "plants", key = "{#id, @authenticatedUserService.getAuthenticatedUser().id}"
    )
    public Plant get(Long id) {
        return plantRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public long count() {
        return plantRepository.countByOwner(authenticatedUserService.getAuthenticatedUser());
    }


    @Caching(
        evict = {
            @CacheEvict(value = "plants", allEntries = true), @CacheEvict(
            value = "botanical-info", allEntries = true,
            condition = "#toSave.botanicalInfo instanceof T(com.github.mdeluise.plantit.botanicalinfo" +
                            ".UserCreatedBotanicalInfo)"
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
        return getAll(Pageable.unpaged()).getContent().stream().map(entity -> entity.getBotanicalInfo().getId())
                                         .collect(Collectors.toSet()).size();
    }


    public boolean isNameAlreadyExisting(String plantName) {
        return plantRepository.existsByOwnerAndPersonalName(authenticatedUserService.getAuthenticatedUser(), plantName);
    }


    @Caching(
        evict = {
            @CacheEvict(value = "plants", allEntries = true),
            @CacheEvict(value = "botanical-info", allEntries = true)
        }
    )
    @Transactional
    public void delete(Long plantId) {
        final Plant toDelete = get(plantId);
        if (!toDelete.getOwner().equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }

        final boolean isBotanicalInfoToDelete =
            botanicalInfoService.countPlants(toDelete.getBotanicalInfo().getId()) == 1;
        final Long deletedPlantBotanicalInfoId = toDelete.getBotanicalInfo().getId();

        toDelete.getImages().forEach(plantImage -> imageStorageService.remove(plantImage.getId()));

        plantRepository.delete(toDelete);

        if (isBotanicalInfoToDelete) {
            botanicalInfoService.delete(deletedPlantBotanicalInfoId);
        }
    }


    @Caching(
        evict = {
            @CacheEvict(value = "plants", allEntries = true),
            @CacheEvict(value = "botanical-info", allEntries = true)
        }
    )
    public Plant update(Plant updated) {
        final Plant toUpdate = get(updated.getId());
        if (!toUpdate.getOwner().equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        toUpdate.setPersonalName(updated.getPersonalName());
        toUpdate.setState(updated.getState());
        toUpdate.setNote(updated.getNote());
        toUpdate.setStartDate(updated.getStartDate());

        final boolean isThisTheOnlyPlantForTheBotanicalInfo =
            botanicalInfoService.countPlants(toUpdate.getBotanicalInfo().getId()) == 1;
        final BotanicalInfo toUpdateBotanicalInfo = toUpdate.getBotanicalInfo();
        final BotanicalInfo updatedBotanicalInfo = getOrCreateUpdatedBotanicalInfo(toUpdate, updated);
        toUpdate.setBotanicalInfo(updatedBotanicalInfo);
        if (!toUpdateBotanicalInfo.equals(updatedBotanicalInfo) && isThisTheOnlyPlantForTheBotanicalInfo) {
            botanicalInfoService.delete(toUpdateBotanicalInfo.getId());
        }

        return plantRepository.save(toUpdate);
    }


    private BotanicalInfo getOrCreateUpdatedBotanicalInfo(Plant toUpdate, Plant updated) {
        final BotanicalInfo botanicalInfoToUpdate = toUpdate.getBotanicalInfo();
        final BotanicalInfo botanicalInfoUpdated = updated.getBotanicalInfo();
        if (botanicalInfoToUpdate.equalsExceptForConcreteClass(botanicalInfoUpdated)) {
            return botanicalInfoToUpdate;
        }
        final Optional<BotanicalInfo> savedMatchingBotanicalInfo =
            botanicalInfoService.get(botanicalInfoUpdated.getScientificName(), botanicalInfoUpdated.getFamily(),
                                     botanicalInfoUpdated.getGenus(), botanicalInfoUpdated.getSpecies()
            );
        if (savedMatchingBotanicalInfo.isPresent()) {
            return savedMatchingBotanicalInfo.get();
        }
        botanicalInfoUpdated.setId(null);
        return botanicalInfoService.save(botanicalInfoUpdated);
    }
}

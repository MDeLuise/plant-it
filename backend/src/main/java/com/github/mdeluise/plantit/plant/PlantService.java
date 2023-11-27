package com.github.mdeluise.plantit.plant;

import java.util.stream.Collectors;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class PlantService {
    private final AuthenticatedUserService authenticatedUserService;
    private final PlantRepository plantRepository;
    private final BotanicalInfoService botanicalInfoService;
    private final ImageStorageService imageStorageService;
    private final PlantImageRepository plantImageRepository;


    @Autowired
    public PlantService(AuthenticatedUserService authenticatedUserService, PlantRepository plantRepository,
                        BotanicalInfoService botanicalInfoService, ImageStorageService imageStorageService,
                        PlantImageRepository plantImageRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.plantRepository = plantRepository;
        this.botanicalInfoService = botanicalInfoService;
        this.imageStorageService = imageStorageService;
        this.plantImageRepository = plantImageRepository;
    }


    @Cacheable(value = "plants", key = "{#pageable, @authenticatedUserService.getAuthenticatedUser().id}")
    public Page<Plant> getAll(Pageable pageable) {
        return plantRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    @Cacheable(value = "plants", key = "{#id, @authenticatedUserService.getAuthenticatedUser().id}")
    public Plant get(Long id) {
        final Plant result = plantRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result.getOwner() != authenticatedUserService.getAuthenticatedUser()) {
            throw new UnauthorizedException();
        }
        return result;
    }


    public long count() {
        return plantRepository.countByOwner(authenticatedUserService.getAuthenticatedUser());
    }


    @CacheEvict(value = "plants", allEntries = true)
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
        toSave.setBotanicalInfo(botanicalInfoService.get(toSave.getBotanicalInfo().getId()));
        return plantRepository.save(toSave);
    }


    public long getNumberOfDistinctBotanicalInfo() {
        return getAll(Pageable.unpaged()).getContent().stream().map(entity -> entity.getBotanicalInfo().getId())
                                         .collect(Collectors.toSet()).size();
    }


    public boolean isNameAlreadyExisting(String plantName) {
        return plantRepository.existsByOwnerAndPersonalName(authenticatedUserService.getAuthenticatedUser(), plantName);
    }


    @CacheEvict(value = "plants", allEntries = true)
    @Transactional
    public void delete(Long plantId) {
        final Plant toDelete = get(plantId);
        if (!toDelete.getOwner().equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }

        // FIXME
        // this is not needed for the DB PlantImage entities (which are removed in cascade),
        // but for the related files in the system
        toDelete.getImages().forEach(plantImage -> imageStorageService.remove(plantImage.getId()));

        plantRepository.delete(toDelete);
    }


    @CacheEvict(value = "plants", allEntries = true)
    @Transactional
    public Plant update(Long id, Plant updated) {
        final Plant toUpdate = get(id);
        if (!toUpdate.getOwner().equals(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        final BotanicalInfo newBotanicalInfo = botanicalInfoService.get(updated.getBotanicalInfo().getId());
        toUpdate.setPersonalName(updated.getPersonalName());
        toUpdate.setBotanicalInfo(newBotanicalInfo);
        toUpdate.setState(updated.getState());
        toUpdate.setNote(updated.getNote());
        toUpdate.setStartDate(updated.getStartDate());
        toUpdate.setEndDate(updated.getEndDate());

        handleAvatar(updated, toUpdate);

        return plantRepository.save(toUpdate);
    }


    private void handleAvatar(Plant updated, Plant toUpdate) {
        final PlantImage toUpdateAvatarImage = toUpdate.getAvatarImage();
        final PlantImage updatedAvatarImage = updated.getAvatarImage();
        if (updatedAvatarImage == null && updated.getAvatarMode().equals(PlantAvatarMode.SPECIFIED)) {
            throw new IllegalArgumentException(
                "Updated plant's avatar mode is PlantAvatarMode.SPECIFIED, but no avatarImage provided");
        }
        toUpdate.setAvatarMode(updated.getAvatarMode());
        if (toUpdateAvatarImage != null) {
            final PlantImage savedAvatarImageToUpdate = plantImageRepository.findById(toUpdateAvatarImage.getId())
                                                                            .orElseThrow(
                                                                                () -> new ResourceNotFoundException(
                                                                                    toUpdateAvatarImage.getId()));
            savedAvatarImageToUpdate.setAvatarOf(null);
            plantImageRepository.save(savedAvatarImageToUpdate);
        }
        if (updatedAvatarImage != null && updated.getAvatarMode().equals(PlantAvatarMode.SPECIFIED)) {
            final String updatedAvatarImageId = updatedAvatarImage.getId();
            final PlantImage newAvatarImage = plantImageRepository.findById(updatedAvatarImageId).orElseThrow(
                () -> new ResourceNotFoundException(updatedAvatarImageId));
            newAvatarImage.setAvatarOf(toUpdate);
            plantImageRepository.save(newAvatarImage);
            newAvatarImage.setAvatarOf(toUpdate);
            plantImageRepository.save(newAvatarImage);
            toUpdate.setAvatarImage(newAvatarImage);
        } else {
            toUpdate.setAvatarImage(null);
        }
    }
}

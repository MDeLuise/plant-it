package com.github.mdeluise.plantit.plant;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
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

@Service
public class PlantService {
    private final AuthenticatedUserService authenticatedUserService;
    private final PlantRepository plantRepository;
    private final BotanicalInfoService botanicalInfoService;
    private final ImageStorageService imageStorageService;
    private final PlantImageRepository plantImageRepository;
    private final Logger logger = LoggerFactory.getLogger(PlantService.class);


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
        logger.debug("Search for DB saved plants");
        return plantRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), pageable);
    }


    @Cacheable(cacheNames = "plants", key = "{#id, @authenticatedUserService.getAuthenticatedUser().id}")
    public Plant get(Long id) {
        logger.debug("Search for DB plant " + id);
        final Plant result = plantRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result.getOwner() != authenticatedUserService.getAuthenticatedUser()) {
            logger.warn("User not authorized to operate on plant " + id);
            throw new UnauthorizedException();
        }
        return result;
    }


    public long count() {
        return plantRepository.countByOwner(authenticatedUserService.getAuthenticatedUser());
    }


    @CacheEvict(cacheNames = "plants", allEntries = true)
    @Transactional
    // https://stackoverflow.com/questions/13370221/persistentobjectexception-detached-entity-passed-to-persist-thrown-by-jpa-and-h
    public Plant save(Plant toSave) {
        final User authenticatedUser = authenticatedUserService.getAuthenticatedUser();
        if (toSave.getOwner() != null && toSave.getOwner() != authenticatedUser) {
            throw new UnauthorizedException();
        }
        toSave.setOwner(authenticatedUser);
        if (toSave.getDiary() == null) {
            final Diary diary = new Diary();
            diary.setTarget(toSave);
            toSave.setDiary(diary);
            toSave.getDiary().setOwner(authenticatedUser);
        }
        if (toSave.getAvatarMode() == null) {
            toSave.setAvatarMode(PlantAvatarMode.NONE);
        }
        toSave.setBotanicalInfo(botanicalInfoService.get(toSave.getBotanicalInfo().getId()));
        return plantRepository.save(toSave);
    }


    public boolean isNameAlreadyExisting(String plantName) {
        return plantRepository.existsByOwnerAndInfoPersonalName(authenticatedUserService.getAuthenticatedUser(), plantName);
    }


    @CacheEvict(cacheNames = "plants", allEntries = true)
    @Transactional
    public void delete(Long plantId) {
        final Plant toDelete = get(plantId);

        // FIXME
        // this is not needed for the DB PlantImage entities (which are removed in cascade),
        // but for the related files in the system
        toDelete.getImages().forEach(plantImage -> imageStorageService.remove(plantImage.getId()));

        plantRepository.delete(toDelete);
    }


    public void deleteInternal(Long plantId) {
        final Plant toDelete = plantRepository.findById(plantId).orElseThrow(() -> new ResourceNotFoundException(plantId));

        // FIXME
        // this is not needed for the DB PlantImage entities (which are removed in cascade),
        // but for the related files in the system
        toDelete.getImages().forEach(plantImage -> imageStorageService.remove(plantImage.getId()));

        plantRepository.delete(toDelete);
    }


    @CacheEvict(cacheNames = "plants", allEntries = true)
    @Transactional
    public Plant update(Long id, Plant updated) {
        final Plant toUpdate = get(id);
        final BotanicalInfo newBotanicalInfo = botanicalInfoService.get(updated.getBotanicalInfo().getId());
        toUpdate.setBotanicalInfo(newBotanicalInfo);
        toUpdate.setInfo(updated.getInfo());

        handleAvatar(updated, toUpdate);

        return plantRepository.save(toUpdate);
    }


    private void handleAvatar(Plant updated, Plant toUpdate) {
        final PlantImage toUpdateAvatarImage = toUpdate.getAvatarImage();
        final PlantImage updatedAvatarImage = updated.getAvatarImage();
        if (updatedAvatarImage == null && updated.getAvatarMode().equals(PlantAvatarMode.SPECIFIED)) {
            logger.error("Updated plant's avatar mode is PlantAvatarMode.SPECIFIED, but no avatarImage provided");
            throw new IllegalArgumentException(
                "Updated plant's avatar mode is PlantAvatarMode.SPECIFIED, but no avatarImage provided");
        }
        toUpdate.setAvatarMode(updated.getAvatarMode());
        if (toUpdateAvatarImage != null) {
            logger.debug("De-link old plant avatar image...");
            final PlantImage savedAvatarImageToUpdate = plantImageRepository.findById(toUpdateAvatarImage.getId())
                                                                            .orElseThrow(
                                                                                () -> new ResourceNotFoundException(
                                                                                    toUpdateAvatarImage.getId()));
            savedAvatarImageToUpdate.setAvatarOf(null);
            plantImageRepository.save(savedAvatarImageToUpdate);
        }
        if (updatedAvatarImage != null && updated.getAvatarMode().equals(PlantAvatarMode.SPECIFIED)) {
            logger.debug("Link new plant avatar image...");
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


    @Transactional
    public void deleteAll() {
        plantRepository.findAll().forEach(plant -> deleteInternal(plant.getId()));
    }


    public Plant getInternal(String name) {
        return plantRepository.findByInfoPersonalName(name)
                              .orElseThrow(() -> new ResourceNotFoundException("name", name));
    }
}

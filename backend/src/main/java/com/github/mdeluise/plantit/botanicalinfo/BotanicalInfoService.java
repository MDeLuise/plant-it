package com.github.mdeluise.plantit.botanicalinfo;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantRepository;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class BotanicalInfoService {
    private final AuthenticatedUserService authenticatedUserService;
    private final BotanicalInfoRepository botanicalInfoRepository;
    private final ImageStorageService imageStorageService;
    private final PlantRepository plantRepository;
    private final Logger logger = LoggerFactory.getLogger(BotanicalInfoService.class);


    @Autowired
    public BotanicalInfoService(AuthenticatedUserService authenticatedUserService,
                                BotanicalInfoRepository botanicalInfoRepository,
                                ImageStorageService imageStorageService, PlantRepository plantRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.botanicalInfoRepository = botanicalInfoRepository;
        this.imageStorageService = imageStorageService;
        this.plantRepository = plantRepository;
    }


    public Set<BotanicalInfo> getByPartialScientificName(String partialScientificName, int size) {
        logger.debug(String.format("Search for DB saved botanical info matching '%s' scientific name (max size %s)",
                                   partialScientificName, size));
        final List<BotanicalInfo> result =
            botanicalInfoRepository.getByScientificNameOrSynonym(partialScientificName).stream().filter(
                botanicalInfo -> botanicalInfo.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser()))
                                   .limit(size)
                                   .toList();
        return new HashSet<>(result.subList(0, Math.min(size, result.size())));
    }


    public Set<BotanicalInfo> getAll(int size) {
        logger.debug(String.format("Search for DB saved botanical info (max size %s)", size));
        final List<BotanicalInfo> result = botanicalInfoRepository.findAll().stream().filter(
                                                                      botanicalInfo -> botanicalInfo.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser()))
                                                                  .limit(size).toList();
        return new HashSet<>(result);
    }


    public int countPlants(Long botanicalInfoId) {
        return botanicalInfoRepository.findById(botanicalInfoId)
                                      .orElseThrow(() -> new ResourceNotFoundException(botanicalInfoId)).getPlants()
                                      .stream().filter(
                pl -> pl.getOwner().equals(authenticatedUserService.getAuthenticatedUser())).collect(Collectors.toSet())
                                      .size();
    }

    public long count() {
        return plantRepository.findAllByOwner(authenticatedUserService.getAuthenticatedUser(), Pageable.unpaged())
                              .getContent().stream().map(entity -> entity.getBotanicalInfo().getId())
                              .collect(Collectors.toSet()).size();
    }


    @CacheEvict(cacheNames = "botanical-info", allEntries = true)
    public BotanicalInfo save(BotanicalInfo toSave) {
        if (toSave.isUserCreated()) {
            toSave.setUserCreator(authenticatedUserService.getAuthenticatedUser());
        }
        if (toSave.getImage() != null && toSave.getImage().getId() == null) {
            toSave.getImage().setId(UUID.randomUUID().toString());
        }
        removeDuplicatedCaseInsensitiveSynonyms(toSave);
        return botanicalInfoRepository.save(toSave);
    }


    public BotanicalInfo get(Long id) {
        final BotanicalInfo result =
            botanicalInfoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!result.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        return result;
    }


    @Transactional
    @CacheEvict(cacheNames = {"botanical-info", "plants"}, allEntries = true)
    public void delete(Long id) {
        final BotanicalInfo toDelete = get(id);
        if (toDelete.getImage() != null) {
            imageStorageService.remove(toDelete.getImage().getId());
        }

        // cascade will not remove plant images
        toDelete.getPlants().forEach(pl -> {
            pl.getImages().forEach(im -> imageStorageService.remove(im.getId()));
            plantRepository.delete(pl);
        });

        botanicalInfoRepository.deleteById(id);
    }


    @Transactional
    @CacheEvict(cacheNames = {"botanical-info", "plants"}, allEntries = true)
    public BotanicalInfo update(Long id, BotanicalInfo updated) {
        final BotanicalInfo toUpdate = get(id);
        if (!toUpdate.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser())) {
            throw new UnauthorizedException();
        }
        if (toUpdate.isUserCreated()) {
            return updateUserCreatedBotanicalInfo(updated, toUpdate);
        }
        logger.info("Trying to update a NON custom botanical info. Creating custom copy...");
        final BotanicalInfo userCreatedCopy = createUserCreatedCopy(toUpdate);
        removeDuplicatedCaseInsensitiveSynonyms(updated);
        return updateUserCreatedBotanicalInfo(updated, userCreatedCopy);
    }


    private BotanicalInfo updateUserCreatedBotanicalInfo(BotanicalInfo updated, BotanicalInfo toUpdate) {
        toUpdate.setUserCreator(authenticatedUserService.getAuthenticatedUser());
        toUpdate.setFamily(updated.getFamily());
        toUpdate.setGenus(updated.getGenus());
        toUpdate.setSpecies(updated.getSpecies());
        toUpdate.setScientificName(updated.getScientificName());
        toUpdate.setPlantCareInfo(updated.getPlantCareInfo());
        toUpdate.setSynonyms(updated.getSynonyms());
        return botanicalInfoRepository.save(toUpdate);
    }


    private BotanicalInfo createUserCreatedCopy(BotanicalInfo toCopy) {
        BotanicalInfo userCreatedCopy = new BotanicalInfo();
        userCreatedCopy.setUserCreator(authenticatedUserService.getAuthenticatedUser());
        userCreatedCopy.setFamily(toCopy.getFamily());
        userCreatedCopy.setGenus(toCopy.getGenus());
        userCreatedCopy.setSpecies(toCopy.getSpecies());
        userCreatedCopy.setScientificName(toCopy.getScientificName());
        userCreatedCopy.setPlantCareInfo(toCopy.getPlantCareInfo());
        userCreatedCopy.setSynonyms(new HashSet<>(toCopy.getSynonyms()));

        userCreatedCopy = save(userCreatedCopy);

        if (toCopy.getImage() != null) {
            logger.debug("Copy botanical info thumbnail...");
            final EntityImage toClone = imageStorageService.get(toCopy.getImage().getId());
            final EntityImage clonedEntityImage = imageStorageService.clone(toClone.getId(), userCreatedCopy);
            userCreatedCopy.setImage((BotanicalInfoImage) clonedEntityImage);
        }

        logger.debug("Move botanical info plants to the custom copy...");
        final BotanicalInfo finalUserCreatedCopy = userCreatedCopy;
        toCopy.getPlants().forEach(pl -> {
            if (pl.getOwner() != authenticatedUserService.getAuthenticatedUser()) {
                return;
            }
            final Plant toChangeBotanicalInfo =
                plantRepository.findById(pl.getId()).orElseThrow(() -> new ResourceNotFoundException(pl.getId()));
            toChangeBotanicalInfo.setBotanicalInfo(finalUserCreatedCopy);
            plantRepository.save(toChangeBotanicalInfo);
        });
        return userCreatedCopy;
    }


    public boolean existsSpecies(String species) {
        return botanicalInfoRepository.findAllBySpecies(species).stream().anyMatch(
            botanicalInfo -> botanicalInfo.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser()));
    }


    public boolean existsExternalId(BotanicalInfoCreator creator, String externalId) {
        return botanicalInfoRepository.findAllByCreatorAndExternalId(creator, externalId).stream().anyMatch(
            botanicalInfo -> botanicalInfo.isAccessibleToUser(authenticatedUserService.getAuthenticatedUser()));
    }


    private void removeDuplicatedCaseInsensitiveSynonyms(BotanicalInfo botanicalInfo) {
        final Set<String> newSynonyms = new HashSet<>();
        botanicalInfo.getSynonyms().forEach(synonym -> {
            if (!containsCaseInsensitive(newSynonyms, synonym)) {
                newSynonyms.add(synonym);
            }
        });
        botanicalInfo.setSynonyms(newSynonyms);
    }

    private boolean containsCaseInsensitive(Set<String> set, String value) {
        for (String str : set) {
            if (str.equalsIgnoreCase(value)) {
                return true;
            }
        }
        return false;
    }
}

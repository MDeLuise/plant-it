package com.github.mdeluise.plantit.botanicalinfo;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

@Service
public class BotanicalInfoService {
    private final AuthenticatedUserService authenticatedUserService;
    private final BotanicalInfoRepository botanicalInfoRepository;
    private final ImageStorageService imageStorageService;


    @Autowired
    public BotanicalInfoService(AuthenticatedUserService authenticatedUserService,
                                BotanicalInfoRepository botanicalInfoRepository,
                                ImageStorageService imageStorageService) {
        this.authenticatedUserService = authenticatedUserService;
        this.botanicalInfoRepository = botanicalInfoRepository;
        this.imageStorageService = imageStorageService;
    }


    public Set<BotanicalInfo> getByPartialScientificName(String partialScientificName, int size) {
        final List<BotanicalInfo> result =
            botanicalInfoRepository.findByScientificNameContainsIgnoreCase(partialScientificName).stream().filter(
                botanicalInfo -> isBotanicalInfoAccessibleToUser(botanicalInfo,
                                                                 authenticatedUserService.getAuthenticatedUser()
                )).limit(size).toList();
        return new HashSet<>(result.subList(0, Math.min(size, result.size())));
    }


    public Set<BotanicalInfo> getAll(int size) {
        final List<BotanicalInfo> result = botanicalInfoRepository.findAll().stream().filter(
            botanicalInfo -> isBotanicalInfoAccessibleToUser(botanicalInfo,
                                                             authenticatedUserService.getAuthenticatedUser()
            )).limit(size).toList();
        return new HashSet<>(result);
    }


    private boolean isBotanicalInfoAccessibleToUser(BotanicalInfo botanicalInfo, User user) {
        return botanicalInfo instanceof GlobalBotanicalInfo || botanicalInfo instanceof UserCreatedBotanicalInfo &&
                                                                   ((UserCreatedBotanicalInfo) botanicalInfo).getCreator()
                                                                                                             .equals(
                                                                                                                 user);
    }


    public int countPlants(Long botanicalInfoId) {
        return botanicalInfoRepository.findById(botanicalInfoId)
                                      .orElseThrow(() -> new ResourceNotFoundException(botanicalInfoId)).getPlants()
                                      .stream().filter(
                pl -> pl.getOwner().equals(authenticatedUserService.getAuthenticatedUser())).collect(Collectors.toSet())
                                      .size();
    }


    @CacheEvict(
        cacheNames = "botanical-info",
        condition = "#toSave instanceof T(com.github.mdeluise.plantit.botanicalinfo.UserCreatedBotanicalInfo)",
        allEntries = true
    )
    public BotanicalInfo save(BotanicalInfo toSave) {
        if (toSave instanceof UserCreatedBotanicalInfo u) {
            u.setCreator(authenticatedUserService.getAuthenticatedUser());
        }
        if (toSave.getImage() != null && toSave.getImage().getId() == null) {
            toSave.getImage().setId(UUID.randomUUID().toString());
        }
        return botanicalInfoRepository.save(toSave);
    }


    public BotanicalInfo get(Long id) {
        final BotanicalInfo result =
            botanicalInfoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result instanceof UserCreatedBotanicalInfo u &&
                u.getCreator() != authenticatedUserService.getAuthenticatedUser()) {
            throw new UnauthorizedException();
        }
        return result;
    }


    public void delete(Long id) {
        final BotanicalInfo toDelete = get(id);
        if (toDelete.getImage() != null) {
            imageStorageService.remove(toDelete.getImage().getId());
        }
        botanicalInfoRepository.deleteById(id);
    }


    public BotanicalInfo update(BotanicalInfo updatedBotanicalInfo) {
        if (!botanicalInfoRepository.existsById(updatedBotanicalInfo.getId())) {
            throw new ResourceNotFoundException(updatedBotanicalInfo.getId());
        } else if (botanicalInfoRepository.findById(updatedBotanicalInfo.getId()).get()
            instanceof UserCreatedBotanicalInfo u && u.getCreator() != authenticatedUserService.getAuthenticatedUser()) {
            throw new UnauthorizedException();
        }
        return botanicalInfoRepository.save(updatedBotanicalInfo);
    }


    public Optional<BotanicalInfo> get(String scientificName, String family, String genus, String species) {
        final Optional<BotanicalInfo> result =
            botanicalInfoRepository.findByScientificNameAndFamilyAndGenusAndSpecies(scientificName, family, genus, species);
        if (result.isPresent() && result.get() instanceof UserCreatedBotanicalInfo u &&
                u.getCreator() != authenticatedUserService.getAuthenticatedUser()) {
            throw new UnauthorizedException();
        }
        return result;
    }


    public boolean existsSpecies(String species) {
        return botanicalInfoRepository.findAllBySpecies(species).stream().anyMatch(
            botanicalInfo -> botanicalInfo instanceof GlobalBotanicalInfo ||
                                 ((UserCreatedBotanicalInfo) botanicalInfo).getCreator().equals(
                                     authenticatedUserService.getAuthenticatedUser()));
    }
}

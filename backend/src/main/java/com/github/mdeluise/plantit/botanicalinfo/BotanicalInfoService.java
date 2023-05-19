package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class BotanicalInfoService {
    private final AuthenticatedUserService authenticatedUserService;
    private final BotanicalInfoRepository botanicalInfoRepository;


    @Autowired
    public BotanicalInfoService(AuthenticatedUserService authenticatedUserService,
                                BotanicalInfoRepository botanicalInfoRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.botanicalInfoRepository = botanicalInfoRepository;
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
        return botanicalInfo instanceof GlobalBotanicalInfo ||
                   botanicalInfo instanceof UserCreatedBotanicalInfo &&
                       ((UserCreatedBotanicalInfo) botanicalInfo).getCreator().equals(user);
    }


    public int countPlants(Long botanicalInfoId) {
        return botanicalInfoRepository.findById(botanicalInfoId)
                                      .orElseThrow(() -> new ResourceNotFoundException(botanicalInfoId)).getPlants()
                                      .stream()
                                      .filter(pl -> pl.getOwner().equals(authenticatedUserService.getAuthenticatedUser()))
                                      .collect(Collectors.toSet())
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
        if (toSave.getImage().getId() == null) {
            toSave.getImage().setId(UUID.randomUUID().toString());
        }
        return botanicalInfoRepository.save(toSave);
    }


    public BotanicalInfo get(Long id) {
        return botanicalInfoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }
}

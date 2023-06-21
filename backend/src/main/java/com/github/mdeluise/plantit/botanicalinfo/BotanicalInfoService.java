package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.image.AbstractBotanicalInfoImage;
import com.github.mdeluise.plantit.image.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class BotanicalInfoService extends AbstractAuthenticatedService {
    private final BotanicalInfoRepository botanicalInfoRepository;
    private final ImageService imageService;


    @Autowired
    public BotanicalInfoService(UserService userService, BotanicalInfoRepository botanicalInfoRepository,
                                ImageService imageService) {
        super(userService);
        this.botanicalInfoRepository = botanicalInfoRepository;
        this.imageService = imageService;
    }


    public Optional<BotanicalInfo> getByScientificName(String scientificName) {
        return botanicalInfoRepository.findByScientificName(scientificName);
    }


    public Set<BotanicalInfo> getByPartialScientificName(String partialScientificName, int size) {
        final Page<BotanicalInfo> result =
            botanicalInfoRepository.findByScientificNameContainsIgnoreCase(partialScientificName,
                                                                           Pageable.ofSize(size)
            );
        return new HashSet<>(result.getContent());
    }


    public Set<BotanicalInfo> getAll(int size) {
        final Page<BotanicalInfo> result = botanicalInfoRepository.findAll(Pageable.ofSize(size));
        return new HashSet<>(result.getContent());
    }


    public int countPlants(Long botanicalInfoId) {
        return botanicalInfoRepository.findById(botanicalInfoId)
                                      .orElseThrow(() -> new ResourceNotFoundException(botanicalInfoId))
                                      .getPlants()
                                      .stream().filter(pl -> pl.getOwner().equals(getAuthenticatedUser()))
                                      .collect(Collectors.toSet())
                                      .size();
    }


    public BotanicalInfo save(BotanicalInfo toSave) {
        if (toSave instanceof UserCreatedBotanicalInfo u) {
            u.setCreator(getAuthenticatedUser());
        }
        final BotanicalInfo result = botanicalInfoRepository.save(toSave);
        final AbstractBotanicalInfoImage image = result.getImage();
        image.setBotanicalName(result);
        imageService.save(image);
        return result;
    }


    public BotanicalInfo get(Long id) {
        return botanicalInfoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }
}

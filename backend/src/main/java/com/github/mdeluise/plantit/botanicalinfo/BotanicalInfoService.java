package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.authentication.UserService;
import com.github.mdeluise.plantit.common.AbstractAuthenticatedService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.image.BotanicalNameImage;
import com.github.mdeluise.plantit.image.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;
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


    public Page<BotanicalInfo> getByPartialScientificName(String partialScientificName, Pageable pageable) {
        return botanicalInfoRepository.findByScientificNameContainsIgnoreCase(partialScientificName, pageable);
    }


    public Page<BotanicalInfo> getAll(Pageable pageable) {
        return botanicalInfoRepository.findAll(pageable);
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
        final BotanicalInfo result = botanicalInfoRepository.save(toSave);
        final BotanicalNameImage image = result.getImage();
        image.setBotanicalName(result);
        imageService.save(image);
        return result;
    }


    public BotanicalInfo get(Long id) {
        return botanicalInfoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    //public Optional<BotanicalInfo> get()
}

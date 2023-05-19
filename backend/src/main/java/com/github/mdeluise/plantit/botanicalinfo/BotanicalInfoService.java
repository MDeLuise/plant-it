package com.github.mdeluise.plantit.botanicalinfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class BotanicalInfoService {
    private final BotanicalInfoRepository botanicalInfoRepository;


    @Autowired
    public BotanicalInfoService(BotanicalInfoRepository botanicalInfoRepository) {
        this.botanicalInfoRepository = botanicalInfoRepository;
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
}

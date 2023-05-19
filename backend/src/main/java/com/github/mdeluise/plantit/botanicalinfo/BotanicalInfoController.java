package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/botanical-info")
public class BotanicalInfoController {
    private final PlantInfoExtractor plantInfoExtractor;
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;


    @Autowired
    public BotanicalInfoController(PlantInfoExtractor plantInfoExtractor,
                                   BotanicalInfoDTOConverter botanicalInfoDtoConverter) {
        this.plantInfoExtractor = plantInfoExtractor;
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
    }


    @GetMapping
    public ResponseEntity<Page<BotanicalInfoDTO>> getAll(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "25", required = false) Integer pageSize,
        @RequestParam(defaultValue = "scientificName", required = false) String sortBy,
        @RequestParam(defaultValue = "ASC", required = false) Sort.Direction sortDir) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<BotanicalInfo> result = plantInfoExtractor.getAll(pageable);
        return ResponseEntity.ok(result.map(botanicalInfoDtoConverter::convertToDTO));
    }


    @GetMapping("/partial/{partialScientificName}")
    public ResponseEntity<Page<BotanicalInfoDTO>> getPartial(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "5", required = false) Integer pageSize,
        @RequestParam(defaultValue = "scientificName", required = false) String sortBy,
        @RequestParam(defaultValue = "ASC", required = false) Sort.Direction sortDir,
        @PathVariable String partialScientificName) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<BotanicalInfo> result = plantInfoExtractor.extractPlants(partialScientificName, pageable);
        return ResponseEntity.ok(result.map(botanicalInfoDtoConverter::convertToDTO));
    }
}

package com.github.mdeluise.plantit.botanicalinfo;

import com.github.mdeluise.plantit.plantinfo.AbstractPlantInfoExtractor;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractorFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/botanical-info")
public class BotanicalInfoController {
    private final AbstractPlantInfoExtractor abstractPlantInfoExtractor;
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public BotanicalInfoController(PlantInfoExtractorFactory plantInfoExtractorFactory,
                                   BotanicalInfoDTOConverter botanicalInfoDtoConverter,
                                   BotanicalInfoService botanicalInfoService) {
        this.abstractPlantInfoExtractor = plantInfoExtractorFactory.getPlantInfoExtractor();
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
        this.botanicalInfoService = botanicalInfoService;
    }


    @GetMapping
    public ResponseEntity<List<BotanicalInfoDTO>> getAll(
        @RequestParam(defaultValue = "5", required = false) Integer size) {
        final Collection<BotanicalInfo> result = abstractPlantInfoExtractor.getAll(size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/partial/{partialScientificName}")
    public ResponseEntity<List<BotanicalInfoDTO>> getPartial(
        @RequestParam(defaultValue = "5", required = false) Integer size,
        @PathVariable String partialScientificName) {
        final Collection<BotanicalInfo> result = abstractPlantInfoExtractor.extractPlants(partialScientificName, size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/{id}/_count")
    public ResponseEntity<Integer> count(@PathVariable Long id) {
        return ResponseEntity.ok(botanicalInfoService.countPlants(id));
    }


    @PostMapping
    public ResponseEntity<BotanicalInfoDTO> save(@RequestBody BotanicalInfoDTO toSave) {
        final BotanicalInfo result = botanicalInfoService.save(botanicalInfoDtoConverter.convertFromDTO(toSave));
        return ResponseEntity.ok(botanicalInfoDtoConverter.convertToDTO(result));
    }
}

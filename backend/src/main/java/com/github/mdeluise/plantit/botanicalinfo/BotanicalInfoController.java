package com.github.mdeluise.plantit.botanicalinfo;

import java.net.MalformedURLException;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import com.github.mdeluise.plantit.common.MessageResponse;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractorFacade;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/botanical-info")
@Tag(name = "Botanical Info", description = "Endpoints for operations on botanical info.")
public class BotanicalInfoController {
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    private final BotanicalInfoService botanicalInfoService;
    private final PlantInfoExtractorFacade plantInfoExtractorFacade;


    @Autowired
    public BotanicalInfoController(BotanicalInfoDTOConverter botanicalInfoDtoConverter,
                                   BotanicalInfoService botanicalInfoService,
                                   PlantInfoExtractorFacade plantInfoExtractorFacade) {
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
        this.botanicalInfoService = botanicalInfoService;
        this.plantInfoExtractorFacade = plantInfoExtractorFacade;
    }


    @GetMapping
    @Operation(summary = "Get all the botanical info", description = "Get all the botanical info.")
    public ResponseEntity<List<BotanicalInfoDTO>> getAll(
        @RequestParam(defaultValue = "5", required = false) Integer size) {
        final Collection<BotanicalInfo> result = plantInfoExtractorFacade.getAll(size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/partial/{partialScientificName}")
    @Operation(
        summary = "Get all the botanical info matching the provided partial scientific name",
        description = "Get all the botanical info, according to the `partialScientificName` parameter"
    )
    public ResponseEntity<List<BotanicalInfoDTO>> getPartial(
        @RequestParam(defaultValue = "5", required = false) Integer size,
        @PathVariable String partialScientificName) {
        final Collection<BotanicalInfo> result = plantInfoExtractorFacade.extractPlants(
            partialScientificName, size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/{botanicalInfoId}/_count")
    @Operation(
        summary = "Count the existing plant for a botanical info.",
        description = "Count the existing plants with the botanical info which id is `botanicalInfoId`."
    )
    public ResponseEntity<Integer> count(@PathVariable Long botanicalInfoId) {
        return ResponseEntity.ok(botanicalInfoService.countPlants(botanicalInfoId));
    }


    @GetMapping("/_count")
    @Operation(summary = "Count the botanical info.", description = "Count all the botanical info.")
    public ResponseEntity<Long> countAll() {
        return ResponseEntity.ok(botanicalInfoService.count());
    }


    @PostMapping
    @Operation(summary = "Save a new botanical info.", description = "Save a new botanical info.")
    public ResponseEntity<BotanicalInfoDTO> save(@RequestBody BotanicalInfoDTO toSave) throws MalformedURLException {
        final BotanicalInfo result = botanicalInfoService.save(botanicalInfoDtoConverter.convertFromDTO(toSave));
        return ResponseEntity.ok(botanicalInfoDtoConverter.convertToDTO(result));
    }


    @GetMapping("/{id}")
    @Operation(summary = "Get a botanical info.", description = "Get the botanical info with the specified `id`.")
    public ResponseEntity<BotanicalInfoDTO> get(@PathVariable Long id) {
        final BotanicalInfo result = botanicalInfoService.get(id);
        return ResponseEntity.ok(botanicalInfoDtoConverter.convertToDTO(result));
    }


    @PutMapping("/{id}")
    @Operation(summary = "Update a botanical info.", description = "Update the botanical info with the specified `id`.")
    public ResponseEntity<BotanicalInfoDTO> update(@PathVariable Long id, @RequestBody BotanicalInfoDTO updated)
        throws MalformedURLException {
        final BotanicalInfo result = botanicalInfoService.update(id, botanicalInfoDtoConverter.convertFromDTO(updated));
        return ResponseEntity.ok(botanicalInfoDtoConverter.convertToDTO(result));
    }


    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a botanical info.", description = "Delete the botanical info with the specified `id`.")
    public ResponseEntity<MessageResponse> remove(@PathVariable Long id) {
        botanicalInfoService.delete(id);
        return ResponseEntity.ok(new MessageResponse("Success"));
    }
}

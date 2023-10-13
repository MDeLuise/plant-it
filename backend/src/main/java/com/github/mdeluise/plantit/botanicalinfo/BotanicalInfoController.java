package com.github.mdeluise.plantit.botanicalinfo;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
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
@Tag(name = "Botanical Info", description = "Endpoints for operations on botanical info.")
public class BotanicalInfoController {
    private final BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    private final BotanicalInfoService botanicalInfoService;


    @Autowired
    public BotanicalInfoController(BotanicalInfoDTOConverter botanicalInfoDtoConverter,
                                   BotanicalInfoService botanicalInfoService) {
        this.botanicalInfoDtoConverter = botanicalInfoDtoConverter;
        this.botanicalInfoService = botanicalInfoService;
    }


    @GetMapping
    @Operation(summary = "Get all the botanical info", description = "Get all the botanical info.")
    public ResponseEntity<List<BotanicalInfoDTO>> getAll(
        @RequestParam(defaultValue = "5", required = false) Integer size) {
        final Collection<BotanicalInfo> result = botanicalInfoService.getAll(size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/partial/{partialScientificName}")
    @Operation(summary = "Get all the botanical info matching the provided partial scientific name",
        description = "Get all the botanical info, according to the `partialScientificName` parameter")
    public ResponseEntity<List<BotanicalInfoDTO>> getPartial(
        @RequestParam(defaultValue = "5", required = false) Integer size,
        @PathVariable String partialScientificName) {
        final Collection<BotanicalInfo> result = botanicalInfoService.getByPartialScientificName(
            partialScientificName, size);
        final List<BotanicalInfoDTO> convertedResult =
            result.stream().map(botanicalInfoDtoConverter::convertToDTO).collect(Collectors.toList());
        return ResponseEntity.ok(convertedResult);
    }


    @GetMapping("/{id}/_count")
    @Operation(summary = "Count the botanical info.", description = "Count the botanical info.")
    public ResponseEntity<Integer> count(@PathVariable Long id) {
        return ResponseEntity.ok(botanicalInfoService.countPlants(id));
    }


    @PostMapping
    @Operation(summary = "Save a new botanical info.", description = "Save a new botanical info.")
    public ResponseEntity<BotanicalInfoDTO> save(@RequestBody BotanicalInfoDTO toSave) {
        final BotanicalInfo result = botanicalInfoService.save(botanicalInfoDtoConverter.convertFromDTO(toSave));
        return ResponseEntity.ok(botanicalInfoDtoConverter.convertToDTO(result));
    }


    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a botanical info.", description = "Delete the botanical info with the specified `id`.")
    public ResponseEntity<String> remove(@PathVariable Long id) {
        botanicalInfoService.remove(id);
        return ResponseEntity.ok("success");
    }
}

package com.github.mdeluise.plantit.plant;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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
@RequestMapping("/plant")
@Tag(name = "Plant", description = "Endpoints for operations on plants.")
public class PlantController {
    private final PlantService plantService;
    private final PlantDTOConverter plantDTOConverter;


    @Autowired
    public PlantController(PlantService plantService, PlantDTOConverter plantDTOConverter) {
        this.plantService = plantService;
        this.plantDTOConverter = plantDTOConverter;
    }


    @GetMapping
    @Operation(summary = "Get all the plants", description = "Get all the plants.")
    public ResponseEntity<Page<PlantDTO>> getAll(@RequestParam(defaultValue = "0", required = false) Integer pageNo,
                                                 @RequestParam(defaultValue = "10", required = false) Integer pageSize,
                                                 @RequestParam(defaultValue = "id", required = false) String sortBy,
                                                 @RequestParam(defaultValue = "DESC", required = false)
                                                 Sort.Direction sortDir) {
        final Sort ignoreCaseSort = Sort.by(new Sort.Order(sortDir, sortBy).ignoreCase());
        final Pageable pageable = PageRequest.of(pageNo, pageSize, ignoreCaseSort);
        final Page<Plant> result = plantService.getAll(pageable);
        return ResponseEntity.ok(result.map(plantDTOConverter::convertToDTO));
    }


    @GetMapping("/{id}")
    @Operation(summary = "Get a single plant", description = "Get a single plant, according to the `id` parameter.")
    public ResponseEntity<PlantDTO> get(@PathVariable Long id) {
        final Plant result = plantService.get(id);
        return ResponseEntity.ok(plantDTOConverter.convertToDTO(result));
    }


    @GetMapping("/_count")
    @Operation(summary = "Count the plants", description = "Count the plants.")
    public ResponseEntity<Long> count() {
        final long result = plantService.count();
        return ResponseEntity.ok(result);
    }


    @PostMapping
    @Operation(summary = "Save a new plant", description = "Save a new plant.")
    public ResponseEntity<PlantDTO> save(@RequestBody PlantDTO plantDTO) {
        final PlantDTO result =
            plantDTOConverter.convertToDTO(plantService.save(plantDTOConverter.convertFromDTO(plantDTO)));
        return ResponseEntity.ok(result);
    }


    @PutMapping("/{id}")
    @Operation(summary = "Update an existing plant", description = "Update the plant with the specified `id`.")
    public ResponseEntity<PlantDTO> update(@PathVariable Long id, @RequestBody PlantDTO plantDTO) {
        final Plant result = plantService.update(id, plantDTOConverter.convertFromDTO(plantDTO));
        return ResponseEntity.ok(plantDTOConverter.convertToDTO(result));
    }


    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an existing plant", description = "Delete an existing plant.")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        plantService.delete(id);
        return ResponseEntity.ok("Success");
    }


    @GetMapping("/_countBotanicalInfo")
    @Operation(summary = "Count the botanical info", description = "Count the botanical info.")
    public ResponseEntity<Long> countDistinctBotanicalInfo() {
        return ResponseEntity.ok(plantService.getNumberOfDistinctBotanicalInfo());
    }


    @GetMapping("/{plantName}/_name-exists")
    @Operation(summary = "Check if a plant name already exists.", description = "Check if a plant name already exists.")
    public ResponseEntity<Boolean> isNameAlreadyExisting(@PathVariable String plantName) {
        return ResponseEntity.ok(plantService.isNameAlreadyExisting(plantName));
    }
}

package com.github.mdeluise.plantit.plant;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/plant")
public class PlantController {
    private final PlantService plantService;
    private final PlantDTOConverter plantDTOConverter;


    @Autowired
    public PlantController(PlantService plantService, PlantDTOConverter plantDTOConverter) {
        this.plantService = plantService;
        this.plantDTOConverter = plantDTOConverter;
    }


    @GetMapping
    public ResponseEntity<Page<PlantDTO>> getAll(@RequestParam(defaultValue = "0", required = false) Integer pageNo,
                                                 @RequestParam(defaultValue = "10", required = false) Integer pageSize,
                                                 @RequestParam(defaultValue = "id", required = false) String sortBy,
                                                 @RequestParam(defaultValue = "DESC", required = false)
                                                 Sort.Direction sortDir) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<Plant> result = plantService.getAll(pageable);
        return ResponseEntity.ok(result.map(plantDTOConverter::convertToDTO));
    }


    @GetMapping("/{id}")
    public ResponseEntity<PlantDTO> get(@PathVariable Long id) {
        final Plant result = plantService.get(id);
        return ResponseEntity.ok(plantDTOConverter.convertToDTO(result));
    }


    @GetMapping("/_count")
    public ResponseEntity<Long> count() {
        final long result = plantService.count();
        return ResponseEntity.ok(result);
    }


    @PostMapping
    public ResponseEntity<PlantDTO> save(@RequestBody PlantDTO plantDTO) {
        final PlantDTO result =
            plantDTOConverter.convertToDTO(plantService.save(plantDTOConverter.convertFromDTO(plantDTO)));
        return ResponseEntity.ok(result);
    }


    @GetMapping("/_countBotanicalInfo")
    public ResponseEntity<Long> countDistinctBotanicalInfo() {
        return ResponseEntity.ok(plantService.getNumberOfDistinctBotanicalInfo());
    }
}

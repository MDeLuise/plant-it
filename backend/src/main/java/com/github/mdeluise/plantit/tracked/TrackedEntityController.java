package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.tracked.plant.PlantDTO;
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
@RequestMapping("/tracked-entity")
public class TrackedEntityController {
    private final TrackedEntityService trackedEntityService;
    private final TrackedEntityDTOConverter trackedEntityDTOConverter;


    @Autowired
    public TrackedEntityController(TrackedEntityService trackedEntityService,
                                   TrackedEntityDTOConverter trackedEntityDTOConverter) {
        this.trackedEntityService = trackedEntityService;
        this.trackedEntityDTOConverter = trackedEntityDTOConverter;
    }


    @GetMapping
    public ResponseEntity<Page<TrackedEntityDTO>> getAll(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "10", required = false) Integer pageSize,
        @RequestParam(defaultValue = "id", required = false) String sortBy,
        @RequestParam(defaultValue = "DESC", required = false) Sort.Direction sortDir) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<AbstractTrackedEntity> result = trackedEntityService.getAll(pageable);
        return ResponseEntity.ok(result.map(trackedEntityDTOConverter::convertToDTO));
    }


    @GetMapping("/{id}")
    public ResponseEntity<TrackedEntityDTO> get(@PathVariable Long id) {
        final AbstractTrackedEntity result = trackedEntityService.get(id);
        return ResponseEntity.ok(trackedEntityDTOConverter.convertToDTO(result));
    }


    @GetMapping("/_count")
    public ResponseEntity<Long> count() {
        final long result = trackedEntityService.count();
        return ResponseEntity.ok(result);
    }


    @PostMapping("/plant")
    public ResponseEntity<TrackedEntityDTO> save(@RequestBody PlantDTO trackedEntityDTO) {
        final TrackedEntityDTO result = trackedEntityDTOConverter.convertToDTO(
            trackedEntityService.save(trackedEntityDTOConverter.convertFromDTO(trackedEntityDTO)));
        return ResponseEntity.ok(result);
    }

}

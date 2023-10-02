package com.github.mdeluise.plantit.diary.entry;

import java.util.Collection;
import java.util.List;

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
@RequestMapping("/diary/entry")
public class DiaryEntryController {
    private final DiaryEntryService diaryEntryService;
    private final DiaryEntryDTOConverter diaryEntryDtoConverter;


    @Autowired
    public DiaryEntryController(DiaryEntryService diaryEntryService, DiaryEntryDTOConverter diaryEntryDtoConverter) {
        this.diaryEntryService = diaryEntryService;
        this.diaryEntryDtoConverter = diaryEntryDtoConverter;
    }


    @SuppressWarnings("ParameterNumber") // FIXME
    @GetMapping
    public ResponseEntity<Page<DiaryEntryDTO>> getAllEntries(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "25", required = false) Integer pageSize,
        @RequestParam(defaultValue = "date", required = false) String sortBy,
        @RequestParam(defaultValue = "DESC", required = false) Sort.Direction sortDir,
        @RequestParam(defaultValue = "", required = false) List<Long> plantIds,
        @RequestParam(defaultValue = "", required = false) List<String> eventTypes) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<DiaryEntry> result = diaryEntryService.getAll(pageable, plantIds, eventTypes);
        return ResponseEntity.ok(result.map(diaryEntryDtoConverter::convertToDTO));
    }


    @GetMapping("/{id}")
    public ResponseEntity<DiaryEntryDTO> get(@PathVariable Long id) {
        final DiaryEntry result = diaryEntryService.get(id);
        return ResponseEntity.ok(diaryEntryDtoConverter.convertToDTO(result));
    }


    @GetMapping("/all/{diaryId}")
    public ResponseEntity<Page<DiaryEntryDTO>> getEntries(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "25", required = false) Integer pageSize,
        @RequestParam(defaultValue = "date", required = false) String sortBy,
        @RequestParam(defaultValue = "DESC", required = false) Sort.Direction sortDir,
        @PathVariable Long diaryId) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<DiaryEntry> result = diaryEntryService.getAll(diaryId, pageable);
        return ResponseEntity.ok(result.map(diaryEntryDtoConverter::convertToDTO));
    }


    @GetMapping("/type")
    public ResponseEntity<Collection<DiaryEntryType>> getEntryTypes() {
        final Collection<DiaryEntryType> result = diaryEntryService.getAllTypes();
        return ResponseEntity.ok(result);
    }


    @PostMapping
    public ResponseEntity<DiaryEntryDTO> save(@RequestBody DiaryEntryDTO diaryEntryDTO) {
        final DiaryEntry result = diaryEntryService.save(diaryEntryDtoConverter.convertFromDTO(diaryEntryDTO));
        return ResponseEntity.ok(diaryEntryDtoConverter.convertToDTO(result));
    }


    @PutMapping("/{id}")
    public ResponseEntity<DiaryEntryDTO> save(@PathVariable Long id, @RequestBody DiaryEntryDTO diaryEntryDTO) {
        final DiaryEntry result = diaryEntryService.update(id, diaryEntryDtoConverter.convertFromDTO(diaryEntryDTO));
        return ResponseEntity.ok(diaryEntryDtoConverter.convertToDTO(result));
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        diaryEntryService.delete(id);
        return ResponseEntity.ok("Success");
    }


    @GetMapping("/_count")
    public ResponseEntity<Long> count() {
        return ResponseEntity.ok(diaryEntryService.count());
    }


    @GetMapping("/{plantId}/_count")
    public ResponseEntity<Long> countByPlant(@PathVariable Long plantId) {
        return ResponseEntity.ok(diaryEntryService.count(plantId));
    }


    @GetMapping("/{plantId}/stats")
    public ResponseEntity<Collection<DiaryEntryStats>> getStats(@PathVariable Long plantId) {
        final Collection<DiaryEntryStats> result = diaryEntryService.getStats(plantId);
        return ResponseEntity.ok(result);
    }
}

package com.github.mdeluise.plantit.diary;

import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTO;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTOConverter;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryType;
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

import java.util.Collection;

@RestController
@RequestMapping("/diary")
public class DiaryController {
    private final DiaryEntryService diaryEntryService;
    private final DiaryEntryDTOConverter diaryEntryDtoConverter;


    @Autowired
    public DiaryController(DiaryEntryService diaryEntryService, DiaryEntryDTOConverter diaryEntryDtoConverter) {
        this.diaryEntryService = diaryEntryService;
        this.diaryEntryDtoConverter = diaryEntryDtoConverter;
    }


    @GetMapping("/entry")
    public ResponseEntity<Page<DiaryEntryDTO>> getAllEntries(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "25", required = false) Integer pageSize,
        @RequestParam(defaultValue = "date", required = false) String sortBy,
        @RequestParam(defaultValue = "DESC", required = false) Sort.Direction sortDir) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<DiaryEntry> result = diaryEntryService.getAll(pageable);
        return ResponseEntity.ok(result.map(diaryEntryDtoConverter::convertToDTO));
    }


    @GetMapping("/entry/{id}")
    public ResponseEntity<DiaryEntryDTO> get(@PathVariable Long id) {
        final DiaryEntry result = diaryEntryService.get(id);
        return ResponseEntity.ok(diaryEntryDtoConverter.convertToDTO(result));
    }


    @GetMapping("/entry/all/{diaryId}")
    public ResponseEntity<Page<DiaryEntryDTO>> getEntries(
        @RequestParam(defaultValue = "0", required = false) Integer pageNo,
        @RequestParam(defaultValue = "25", required = false) Integer pageSize,
        @RequestParam(defaultValue = "date", required = false) String sortBy,
        @RequestParam(defaultValue = "DESC", required = false) Sort.Direction sortDir, @PathVariable Long diaryId) {
        final Pageable pageable = PageRequest.of(pageNo, pageSize, sortDir, sortBy);
        final Page<DiaryEntry> result = diaryEntryService.getAll(diaryId, pageable);
        return ResponseEntity.ok(result.map(diaryEntryDtoConverter::convertToDTO));
    }


    @GetMapping("/entry/type")
    public ResponseEntity<Collection<DiaryEntryType>> getEntryTypes() {
        final Collection<DiaryEntryType> result = diaryEntryService.getAllTypes();
        return ResponseEntity.ok(result);
    }


    @PostMapping("/entry")
    public ResponseEntity<DiaryEntryDTO> save(@RequestBody DiaryEntryDTO diaryEntryDTO) {
        final DiaryEntry result = diaryEntryService.save(diaryEntryDtoConverter.convertFromDTO(diaryEntryDTO));
        return ResponseEntity.ok(diaryEntryDtoConverter.convertToDTO(result));
    }

}

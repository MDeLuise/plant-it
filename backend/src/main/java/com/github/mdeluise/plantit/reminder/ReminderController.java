package com.github.mdeluise.plantit.reminder;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

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
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/reminder")
@Tag(name = "Reminder", description = "Endpoints for reminders")
public class ReminderController {
    private final ReminderService reminderService;
    private final ReminderDTOConverter reminderDtoConverter;


    @Autowired
    public ReminderController(ReminderService reminderService, ReminderDTOConverter reminderDtoConverter) {
        this.reminderService = reminderService;
        this.reminderDtoConverter = reminderDtoConverter;
    }


    @GetMapping
    public ResponseEntity<Collection<ReminderDTO>> getAll() {
        final Set<ReminderDTO> result = reminderService.getAll().stream()
                                                       .map(reminderDtoConverter::convertToDTO)
                                                       .collect(Collectors.toSet());
        return ResponseEntity.ok(result);
    }


    @GetMapping("/{plantId}")
    public ResponseEntity<Collection<ReminderDTO>> getAll(@PathVariable Long plantId) {
        final Set<ReminderDTO> result = reminderService.getAll(plantId).stream()
                                                       .map(reminderDtoConverter::convertToDTO)
                                                       .collect(Collectors.toSet());
        return ResponseEntity.ok(result);
    }


    @DeleteMapping("/{id}")
    public void delete(@PathVariable long id) {
        reminderService.remove(id);
    }


    @PostMapping
    public ResponseEntity<ReminderDTO> save(@RequestBody ReminderDTO reminderDTO) {
        final Reminder result = reminderService.save(reminderDtoConverter.convertFromDTO(reminderDTO));
        return ResponseEntity.ok(reminderDtoConverter.convertToDTO(result));
    }


    @PutMapping("/{id}")
    public ResponseEntity<ReminderDTO> update(@PathVariable Long id, @RequestBody ReminderDTO reminderDTO) {
        final Reminder result = reminderService.update(id, reminderDtoConverter.convertFromDTO(reminderDTO));
        return ResponseEntity.ok(reminderDtoConverter.convertToDTO(result));
    }
}

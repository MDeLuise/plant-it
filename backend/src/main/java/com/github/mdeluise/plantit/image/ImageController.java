package com.github.mdeluise.plantit.image;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Collection;

@RestController
@RequestMapping("/image")
public class ImageController {
    private final ImageService imageService;
    private final ImageDTOConverter imageDtoConverter;


    @Autowired
    public ImageController(ImageService imageService, ImageDTOConverter imageDtoConverter) {
        this.imageService = imageService;
        this.imageDtoConverter = imageDtoConverter;
    }


    @PostMapping("/botanical-info")
    public ResponseEntity<Long> saveBotanicalInfoImage(@RequestParam("image") MultipartFile file) throws IOException {
        final AbstractImage saved = imageService.saveBotanicalInfoImage(file);
        return ResponseEntity.ok(saved.getId());
    }


    @GetMapping("/{id}")
    public ResponseEntity<ImageDTO> get(@PathVariable("id") Long id) {
        final AbstractImage result = imageService.get(id);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(result));
    }


    @DeleteMapping("/botanical-info/{id}")
    public ResponseEntity<String> delete(@PathVariable("id") Long id) {
        imageService.delete(id);
        return ResponseEntity.ok("Success");
    }


    @PostMapping("/entity/{id}")
    public ResponseEntity<Long> saveEntityImage(@RequestParam("image") MultipartFile file,
                                                @PathVariable("id") Long entityId) throws IOException {
        final AbstractImage saved = imageService.saveEntityImage(file, entityId);
        return ResponseEntity.ok(saved.getId());
    }


    @GetMapping("/all/{id}")
    public ResponseEntity<Collection<Long>> getAllImageIdsFromEntity(@PathVariable("id") Long id) {
        final Collection<Long> result = imageService.getAllIds(id);
        return ResponseEntity.ok(result);
    }
}

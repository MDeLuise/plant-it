package com.github.mdeluise.plantit.image;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

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


    @PostMapping
    public ResponseEntity<Long> saveBotanicalInfoImage(@RequestParam("image") MultipartFile file) throws IOException {
        final AbstractImage saved = imageService.save(file);
        return ResponseEntity.ok(saved.getId());
    }


    @GetMapping("/botanical-info/{id}")
    public ResponseEntity<ImageDTO> getBotanicalInfoImage(@PathVariable("id") Long id) {
        final AbstractImage result = imageService.get(id);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(result));
    }
}

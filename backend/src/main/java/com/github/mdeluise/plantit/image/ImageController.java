package com.github.mdeluise.plantit.image;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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


    @GetMapping("/info/{id}")
    public ResponseEntity<ImageDTO> getInfo(@PathVariable Long id) {
        final AbstractImage result = imageService.getInfo(id);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(result));
    }


    @GetMapping(value = "/{id}")
    public ResponseEntity<byte[]> get(@PathVariable Long id) throws IOException {
        final byte[] imageContent = imageService.get(id);
        return ResponseEntity.ok().contentType(MediaType.IMAGE_JPEG).body(imageContent);
    }
}

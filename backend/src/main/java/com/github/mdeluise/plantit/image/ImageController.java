package com.github.mdeluise.plantit.image;

import java.util.Base64;
import java.util.Collection;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/image")
public class ImageController {
    private final ImageStorageService imageStorageService;
    private final BotanicalInfoService botanicalInfoService;
    private final PlantService plantService;
    private final ImageDTOConverter imageDtoConverter;


    @Autowired
    public ImageController(ImageStorageService imageStorageService, BotanicalInfoService botanicalInfoService,
                           PlantService plantService, ImageDTOConverter imageDtoConverter) {
        this.imageStorageService = imageStorageService;
        this.botanicalInfoService = botanicalInfoService;
        this.plantService = plantService;
        this.imageDtoConverter = imageDtoConverter;
    }


    @PostMapping("/botanical-info/{id}")
    public ResponseEntity<ImageDTO> saveBotanicalInfoImage(@RequestParam("image") MultipartFile file,
                                                           @PathVariable("id") Long id) {
        final BotanicalInfo linkedEntity = botanicalInfoService.get(id);
        final EntityImage saved = imageStorageService.save(file, linkedEntity);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(saved));
    }


    @GetMapping("/{id}")
    public ResponseEntity<ImageDTO> get(@PathVariable("id") String id) {
        final EntityImage result = imageStorageService.get(id);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(result));
    }


    @GetMapping("/content/{id}")
    public ResponseEntity<byte[]> getContent(@PathVariable("id") String id) {
        final byte[] result = Base64.getEncoder().encode(imageStorageService.getContent(id));
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG);
        return new ResponseEntity<>(result, headers, HttpStatus.OK);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable("id") String id) {
        imageStorageService.remove(id);
        return ResponseEntity.ok("Success");
    }


    @PostMapping("/entity/{id}")
    public ResponseEntity<String> saveEntityImage(@RequestParam("image") MultipartFile file,
                                                  @PathVariable("id") Long entityId) {
        final Plant linkedEntity = plantService.get(entityId);
        final EntityImage saved = imageStorageService.save(file, linkedEntity);
        return ResponseEntity.ok(saved.getId());
    }


    @GetMapping("/entity/all/{id}")
    public ResponseEntity<Collection<String>> getAllImageIdsFromEntity(@PathVariable("id") Long id) {
        final Plant linkedEntity = plantService.get(id);
        final Collection<String> result = imageStorageService.getAllIds(linkedEntity);
        return ResponseEntity.ok(result);
    }


    @GetMapping("/entity/_count")
    public ResponseEntity<Integer> countUserImage() {
        return ResponseEntity.ok(imageStorageService.count());
    }
}

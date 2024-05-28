package com.github.mdeluise.plantit.image;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Collection;
import java.util.Date;

import com.github.mdeluise.plantit.common.MessageResponse;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantDTO;
import com.github.mdeluise.plantit.plant.PlantDTOConverter;
import com.github.mdeluise.plantit.plant.PlantService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
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
    private final PlantService plantService;
    private final ImageDTOConverter imageDtoConverter;
    private final PlantDTOConverter plantDtoConverter;


    @Autowired
    public ImageController(ImageStorageService imageStorageService, PlantService plantService, ImageDTOConverter imageDtoConverter,
                           PlantDTOConverter plantDtoConverter) {
        this.imageStorageService = imageStorageService;
        this.plantService = plantService;
        this.imageDtoConverter = imageDtoConverter;
        this.plantDtoConverter = plantDtoConverter;
    }


    @PostMapping("/plant/{plantId}/{imageId}")
    @Transactional
    public ResponseEntity<PlantDTO> updatePlantAvatarImageId(@PathVariable Long plantId, @PathVariable String imageId) {
        final Plant linkedEntity = plantService.get(plantId);
        final PlantImage newAvatarImage = (PlantImage) imageStorageService.get(imageId);
        linkedEntity.setAvatarImage(newAvatarImage);
        final Plant saved = plantService.update(linkedEntity.getId(), linkedEntity);
        return ResponseEntity.ok(plantDtoConverter.convertToDTO(saved));
    }


    @GetMapping("/metadata/{id}")
    public ResponseEntity<ImageDTO> get(@PathVariable("id") String id) {
        final EntityImage result = imageStorageService.get(id);
        return ResponseEntity.ok(imageDtoConverter.convertToDTO(result));
    }


    @GetMapping("/content/{id}")
    @SuppressWarnings("ReturnCount")
    public ResponseEntity<Resource> getContent(@PathVariable("id") String id) {
        try {
            final ImageContentResponse imageContent = imageStorageService.getImageContent(id);
            final HttpHeaders headers = new HttpHeaders();
            headers.setContentType(imageContent.getType());
            final ByteArrayResource resource = new ByteArrayResource(imageContent.getContent());
            return ResponseEntity.ok()
                                 .headers(headers)
                                 .contentLength(resource.contentLength())
                                 .body(resource);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    @GetMapping("/thumbnail/{id}")
    public ResponseEntity<byte[]> getThumbnail(@PathVariable("id") String id) {
        final byte[] result = Base64.getEncoder().encode(imageStorageService.getThumbnail(id));
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG);
        return new ResponseEntity<>(result, headers, HttpStatus.OK);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<MessageResponse> delete(@PathVariable("id") String id) {
        imageStorageService.remove(id);
        return ResponseEntity.ok(new MessageResponse("Success"));
    }


    @PostMapping("/entity/{id}")
    public ResponseEntity<String> saveEntityImage(@RequestParam("image") MultipartFile file,
                                                  @PathVariable("id") Long entityId,
                                                  @RequestParam(value = "creationDate", required = false) String creationDateStr,
                                                  @RequestParam(required = false) String description)
        throws ParseException {
        final Plant linkedEntity = plantService.get(entityId);
        final Date creationDate = creationDateStr != null ?
                                      new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(creationDateStr) :
                                      null;
        final EntityImage saved = imageStorageService.save(file, linkedEntity, creationDate, description);
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

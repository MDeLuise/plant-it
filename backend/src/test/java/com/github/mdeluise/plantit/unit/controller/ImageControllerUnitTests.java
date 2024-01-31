package com.github.mdeluise.plantit.unit.controller;

import java.net.MalformedURLException;
import java.text.ParseException;
import java.util.Base64;
import java.util.Collection;
import java.util.Collections;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.ImageController;
import com.github.mdeluise.plantit.image.ImageDTO;
import com.github.mdeluise.plantit.image.ImageDTOConverter;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.SaveImageUrlRequest;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantDTO;
import com.github.mdeluise.plantit.plant.PlantDTOConverter;
import com.github.mdeluise.plantit.plant.PlantService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.multipart.MultipartFile;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for ImageController")
class ImageControllerUnitTests {
    @Mock
    private ImageStorageService imageStorageService;
    @Mock
    private BotanicalInfoService botanicalInfoService;
    @Mock
    private PlantService plantService;
    @Mock
    private ImageDTOConverter imageDtoConverter;
    @Mock
    private PlantDTOConverter plantDtoConverter;
    @InjectMocks
    private ImageController imageController;


    @Test
    @DisplayName("Test saving botanical info image with non-existing ID")
    void testSaveBotanicalInfoImageWithNonExistingId() {
        final Long id = 1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        Mockito.when(botanicalInfoService.get(id)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(
            ResourceNotFoundException.class, () -> imageController.saveBotanicalInfoImage(file, id));
    }


    @Test
    @DisplayName("Test saving botanical info image with invalid ID")
    void testSaveBotanicalInfoImageWithInvalidId() {
        final Long id = 1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        Mockito.when(botanicalInfoService.get(id)).thenThrow(UnauthorizedException.class);

        Assertions.assertThrows(UnauthorizedException.class, () -> imageController.saveBotanicalInfoImage(file, id));
    }


    @Test
    @DisplayName("Test saving plant image with non-existing ID")
    void testSavePlantImageWithNonExistingId() {
        final Long plantId = 1L;
        final String imageId = "imageId";
        Mockito.when(plantService.get(plantId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(
            ResourceNotFoundException.class, () -> imageController.savePlantImage(plantId, imageId));
    }


    @Test
    @DisplayName("Test getting image by non-existing ID")
    void testGetImageByNonExistingId() {
        final String id = "imageId";
        Mockito.when(imageStorageService.get(id)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> imageController.get(id));
    }


    @Test
    @DisplayName("Test deleting image by non-existing ID")
    void testDeleteImageByNonExistingId() {
        final String id = "imageId";
        Mockito.doThrow(ResourceNotFoundException.class).when(imageStorageService).remove(id);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> imageController.delete(id));
    }


    @Test
    @DisplayName("Test saving botanical info image with existing ID")
    void testSaveBotanicalInfoImageWithExistingId() {
        final Long id = 1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoService.get(id)).thenReturn(botanicalInfo);
        final BotanicalInfoImage savedImage = new BotanicalInfoImage();
        final ImageDTO imageDto = new ImageDTO();
        Mockito.when(imageStorageService.save(file, botanicalInfo, null, null)).thenReturn(savedImage);
        Mockito.when(imageDtoConverter.convertToDTO(savedImage)).thenReturn(imageDto);

        final ResponseEntity<ImageDTO> responseEntity = imageController.saveBotanicalInfoImage(file, id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(imageDto, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test saving plant image with existing ID")
    void testSavePlantImageWithExistingId() {
        final Long plantId = 1L;
        final String imageId = "imageId";
        final Plant plant = new Plant();
        final PlantDTO plantDto = new PlantDTO();
        Mockito.when(plantService.get(plantId)).thenReturn(plant);
        final PlantImage newAvatarImage = new PlantImage();
        Mockito.when(imageStorageService.get(imageId)).thenReturn(newAvatarImage);
        Mockito.when(plantService.update(Mockito.any(), Mockito.any())).thenReturn(plant);
        Mockito.when(plantDtoConverter.convertToDTO(plant)).thenReturn(plantDto);

        final ResponseEntity<PlantDTO> responseEntity = imageController.savePlantImage(plantId, imageId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(plantDto, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test getting image by existing ID")
    void testGetImageByExistingId() {
        final String id = "imageId";
        final BotanicalInfoImage image = new BotanicalInfoImage();
        final ImageDTO imageDto = new ImageDTO();
        Mockito.when(imageStorageService.get(id)).thenReturn(image);
        Mockito.when(imageDtoConverter.convertToDTO(image)).thenReturn(imageDto);

        final ResponseEntity<ImageDTO> responseEntity = imageController.get(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(imageDto, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test deleting image by existing ID")
    void testDeleteImageByExistingId() {
        final String id = "imageId";

        final ResponseEntity<String> responseEntity = imageController.delete(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertTrue(responseEntity.getBody().contains("Success"));
    }


    @Test
    @DisplayName("Test getting all image IDs from existing entity")
    void testGetAllImageIdsFromEntity() {
        final Long id = 1L;
        final Plant plant = new Plant();
        Mockito.when(plantService.get(id)).thenReturn(plant);
        Mockito.when(imageStorageService.getAllIds(plant)).thenReturn(Collections.singleton("imageId"));

        final ResponseEntity<Collection<String>> responseEntity = imageController.getAllImageIdsFromEntity(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(1, responseEntity.getBody().size());
        Assertions.assertTrue(responseEntity.getBody().contains("imageId"));
    }


    @Test
    @DisplayName("Test counting user images")
    void testCountUserImage() {
        final int expected = 5;
        Mockito.when(imageStorageService.count()).thenReturn(expected);

        final ResponseEntity<Integer> responseEntity = imageController.countUserImage();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(expected, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test saving botanical info image with existing ID and valid URL")
    void testSaveBotanicalInfoImageWithExistingIdAndValidUrl() throws MalformedURLException {
        final Long id = 1L;
        final String validUrl = "http://valid-url.com/image.jpg";
        final SaveImageUrlRequest saveImageUrlRequest = new SaveImageUrlRequest(validUrl);
        final BotanicalInfo linkedEntity = new BotanicalInfo();
        final BotanicalInfoImage savedImage = new BotanicalInfoImage();
        Mockito.when(botanicalInfoService.get(id)).thenReturn(linkedEntity);
        Mockito.when(imageStorageService.save(saveImageUrlRequest.url(), linkedEntity)).thenReturn(savedImage);
        Mockito.when(imageDtoConverter.convertToDTO(savedImage)).thenReturn(new ImageDTO());

        final ResponseEntity<ImageDTO> responseEntity = imageController.saveBotanicalInfoImage(id, saveImageUrlRequest);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
    }


    @Test
    @DisplayName("Test saving plant image with invalid image ID")
    void testSavePlantImageWithInvalidImageId() {
        final Long plantId = 1L;
        final String invalidImageId = "invalid-image-id";
        Mockito.when(plantService.get(plantId)).thenReturn(new Plant());
        Mockito.when(imageStorageService.get(invalidImageId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class,
                                () -> imageController.savePlantImage(plantId, invalidImageId)
        );
    }


    @Test
    @DisplayName("Test getting content for non-existing image ID")
    void testGetContentForNonExistingImageId() {
        final String nonExistingId = "non-existing-id";
        Mockito.when(imageStorageService.getContent(nonExistingId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> imageController.getContent(nonExistingId));
    }


    @Test
    @DisplayName("Test getting thumbnail for non-existing image ID")
    void testGetThumbnailForNonExistingImageId() {
        final String nonExistingId = "non-existing-id";
        Mockito.when(imageStorageService.getThumbnail(nonExistingId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> imageController.getThumbnail(nonExistingId));
    }


    @Test
    @DisplayName("Test saving plant image with invalid plant ID")
    void testSavePlantImageWithInvalidPlantId() {
        final Long invalidPlantId = -1L;
        final String imageId = "imageId";
        Mockito.when(plantService.get(invalidPlantId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class,
                                () -> imageController.savePlantImage(invalidPlantId, imageId)
        );
    }


    @Test
    @DisplayName("Test getting content for existing image ID")
    void testGetContentForExistingImageId() {
        final String existingId = "existing-id";
        final byte[] content = "image-content".getBytes();
        Mockito.when(imageStorageService.getContent(existingId)).thenReturn(content);

        final ResponseEntity<byte[]> responseEntity = imageController.getContent(existingId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertArrayEquals(Base64.getEncoder().encode(content), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test getting thumbnail for existing image ID")
    void testGetThumbnailForExistingImageId() {
        final String existingId = "existing-id";
        final byte[] thumbnail = "image-thumbnail".getBytes();
        Mockito.when(imageStorageService.getThumbnail(existingId)).thenReturn(thumbnail);

        final ResponseEntity<byte[]> responseEntity = imageController.getThumbnail(existingId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertArrayEquals(Base64.getEncoder().encode(thumbnail), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test deleting image with null ID")
    @Disabled
        //TODO
    void testDeleteImageWithNullId() {
        final String nullId = null;

        Assertions.assertThrows(IllegalArgumentException.class, () -> imageController.delete(nullId));
    }


    @Test
    @DisplayName("Test saving entity image with null file")
    @Disabled
        //TODO
    void testSaveEntityImageWithNullFile() throws MalformedURLException {
        final Long entityId = 1L;
        final String validUrl = "http://valid-url.com/image.jpg";
        final SaveImageUrlRequest saveImageUrlRequest = new SaveImageUrlRequest(validUrl);
        Mockito.when(plantService.get(entityId)).thenReturn(new Plant());

        Assertions.assertThrows(IllegalArgumentException.class,
                                () -> imageController.saveEntityImage(null, entityId, null, null)
        );
    }


    @Test
    @DisplayName("Test getting all image IDs from non-existing entity")
    void testGetAllImageIdsFromNonExistingEntity() {
        final Long nonExistingId = -1L;
        Mockito.when(plantService.get(nonExistingId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class,
                                () -> imageController.getAllImageIdsFromEntity(nonExistingId)
        );
    }


    @Test
    @DisplayName("Test counting user images when no images exist")
    void testCountUserImageWithNoImages() {
        final int expected = 0;
        Mockito.when(imageStorageService.count()).thenReturn(expected);

        final ResponseEntity<Integer> responseEntity = imageController.countUserImage();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(expected, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test saving botanical info image with null file")
    @Disabled
        //TODO
    void testSaveBotanicalInfoImageWithNullFile() {
        final Long id = 1L;
        final MultipartFile nullFile = null;

        Assertions.assertThrows(IllegalArgumentException.class,
                                () -> imageController.saveBotanicalInfoImage(nullFile, id)
        );
    }


    @Test
    @DisplayName("Test saving botanical info image with non-existing ID and valid file")
    void testSaveBotanicalInfoImageWithNonExistingIdAndValidFile() {
        final Long nonExistingId = -1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        Mockito.when(botanicalInfoService.get(nonExistingId)).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class,
                                () -> imageController.saveBotanicalInfoImage(file, nonExistingId)
        );
    }


    @Test
    @DisplayName("Test saving botanical info image with existing ID, null file, and null URL")
    @Disabled
        //TODO
    void testSaveBotanicalInfoImageWithExistingIdNullFileAndNullUrl() {
        final Long id = 1L;
        final MultipartFile nullFile = null;

        Assertions.assertThrows(IllegalArgumentException.class,
                                () -> imageController.saveBotanicalInfoImage(nullFile, id)
        );
    }


    @Test
    @DisplayName("Test saving botanical info image with existing ID, valid file, and null URL")
    void testSaveBotanicalInfoImageWithExistingIdValidFileAndNullUrl() {
        final Long id = 1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoService.get(id)).thenReturn(botanicalInfo);
        final BotanicalInfoImage savedImage = new BotanicalInfoImage();
        final ImageDTO imageDto = new ImageDTO();
        Mockito.when(imageStorageService.save(file, botanicalInfo, null, null)).thenReturn(savedImage);
        Mockito.when(imageDtoConverter.convertToDTO(savedImage)).thenReturn(imageDto);

        final ResponseEntity<ImageDTO> responseEntity = imageController.saveBotanicalInfoImage(file, id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
    }


    @Test
    @DisplayName("Test saving botanical info image with existing ID, null file, and valid URL")
    void testSaveBotanicalInfoImageWithExistingIdNullFileAndValidUrl() throws MalformedURLException {
        final Long id = 1L;
        final SaveImageUrlRequest saveImageUrlRequest = new SaveImageUrlRequest("http://valid-url.com/image.jpg");
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoService.get(id)).thenReturn(botanicalInfo);
        final BotanicalInfoImage savedImage = new BotanicalInfoImage();
        final ImageDTO imageDto = new ImageDTO();
        Mockito.when(imageStorageService.save(saveImageUrlRequest.url(), botanicalInfo)).thenReturn(savedImage);
        Mockito.when(imageDtoConverter.convertToDTO(savedImage)).thenReturn(imageDto);

        final ResponseEntity<ImageDTO> responseEntity = imageController.saveBotanicalInfoImage(id, saveImageUrlRequest);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
    }


    @Test
    @DisplayName("Test saving entity image with valid parameters")
    void testSaveEntityImageWithValidParameters() throws ParseException {
        final Long entityId = 1L;
        final MultipartFile file = Mockito.mock(MultipartFile.class);
        final String creationDateStr = "2024-02-23T00:00:00.000Z";
        final String description = "test description";
        final Plant linkedEntity = new Plant();
        Mockito.when(plantService.get(entityId)).thenReturn(linkedEntity);
        final EntityImage savedImage = new BotanicalInfoImage();
        Mockito.when(imageStorageService.save(Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any()))
               .thenReturn(savedImage);

        final ResponseEntity<String> responseEntity =
            imageController.saveEntityImage(file, entityId, creationDateStr, description);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
    }


    @Test
    @DisplayName("Test getting all image IDs from existing entity")
    void testGetAllImageIdsFromExistingEntity() {
        final Long entityId = 1L;
        final Plant linkedEntity = new Plant();
        Mockito.when(plantService.get(entityId)).thenReturn(linkedEntity);
        Mockito.when(imageStorageService.getAllIds(linkedEntity)).thenReturn(Collections.singleton("imageId"));

        final ResponseEntity<Collection<String>> responseEntity = imageController.getAllImageIdsFromEntity(entityId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(1, responseEntity.getBody().size());
        Assertions.assertTrue(responseEntity.getBody().contains("imageId"));
    }
}

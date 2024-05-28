package com.github.mdeluise.plantit.unit.controller;

import java.util.List;

import com.github.mdeluise.plantit.common.MessageResponse;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantController;
import com.github.mdeluise.plantit.plant.PlantDTO;
import com.github.mdeluise.plantit.plant.PlantDTOConverter;
import com.github.mdeluise.plantit.plant.PlantService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;

@ExtendWith(MockitoExtension.class)
@DisplayName("Unit tests for PlantController")
class PlantControllerUnitTests {
    @Mock
    private PlantService plantService;
    @Mock
    private PlantDTOConverter plantDTOConverter;
    @InjectMocks
    private PlantController plantController;


    @Test
    @DisplayName("Test get all plants with default parameters")
    void testGetAllPlantsWithDefaultParams() {
        final Plant plant1 = new Plant();
        Mockito.when(plantService.getAll(any())).thenReturn(new PageImpl<>(List.of(plant1)));
        Mockito.when(plantDTOConverter.convertToDTO(plant1)).thenReturn(new PlantDTO());
        final ResponseEntity<Page<PlantDTO>> responseEntity = plantController.getAll(0, 10, "id", Sort.Direction.DESC);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(1, responseEntity.getBody().getTotalElements());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get plant by existing ID")
    void testGetPlantByExistingId() {
        Mockito.when(plantService.get(anyLong())).thenReturn(new Plant());
        Mockito.when(plantDTOConverter.convertToDTO(any())).thenReturn(new PlantDTO());
        final ResponseEntity<PlantDTO> responseEntity = plantController.get(1L);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get plant by non-existing ID")
    void testGetPlantByNonExistingId() {
        Mockito.when(plantService.get(anyLong())).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> plantController.get(1L));
    }


    @Test
    @DisplayName("Test count plants")
    void testCountPlants() {
        Mockito.when(plantService.count()).thenReturn(10L);
        final ResponseEntity<Long> responseEntity = plantController.count();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(10L, responseEntity.getBody().longValue());
    }


    @Test
    @DisplayName("Test save plant")
    void testSavePlant() {
        PlantDTO plantDTO = new PlantDTO();
        Plant plant = new Plant();
        Mockito.when(plantService.save(any())).thenReturn(plant);
        Mockito.when(plantDTOConverter.convertToDTO(any())).thenReturn(plantDTO);
        final ResponseEntity<PlantDTO> responseEntity = plantController.save(plantDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test updateInternal plant with existing ID")
    void testUpdatePlantWithExistingId() {
        PlantDTO plantDTO = new PlantDTO();
        Plant plant = new Plant();
        Mockito.when(plantService.update(anyLong(), any())).thenReturn(plant);
        Mockito.when(plantDTOConverter.convertToDTO(any())).thenReturn(plantDTO);
        final ResponseEntity<PlantDTO> responseEntity = plantController.update(1L, plantDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertNotNull(responseEntity.getBody());
    }


    @Test
    @DisplayName("Test updateInternal plant with non-existing ID")
    void testUpdatePlantWithNonExistingId() {
        Mockito.when(plantService.update(anyLong(), any())).thenThrow(ResourceNotFoundException.class);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> plantController.update(1L, new PlantDTO()));
    }


    @Test
    @DisplayName("Test delete plant by existing ID")
    void testDeletePlantByExistingId() {
        final ResponseEntity<MessageResponse> responseEntity = plantController.delete(1L);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals("Success", responseEntity.getBody().getMessage());
    }


    @Test
    @DisplayName("Test delete plant by non-existing ID")
    void testDeletePlantByNonExistingId() {
        Mockito.doThrow(ResourceNotFoundException.class).when(plantService).delete(anyLong());

        Assertions.assertThrows(ResourceNotFoundException.class, () -> plantController.delete(1L));
    }


    @Test
    @DisplayName("Test check if plant name exists")
    void testIsNameAlreadyExisting() {
        Mockito.when(plantService.isNameAlreadyExisting(any())).thenReturn(true);
        final ResponseEntity<Boolean> responseEntity = plantController.isNameAlreadyExisting("test");

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertTrue(responseEntity.getBody());
    }
}

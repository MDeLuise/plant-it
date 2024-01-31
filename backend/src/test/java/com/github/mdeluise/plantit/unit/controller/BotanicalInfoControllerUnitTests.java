package com.github.mdeluise.plantit.unit.controller;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoController;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTOConverter;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractorFacade;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for BotanicalInfoController")
class BotanicalInfoControllerUnitTests {
    @Mock
    private BotanicalInfoDTOConverter botanicalInfoDtoConverter;
    @Mock
    private BotanicalInfoService botanicalInfoService;
    @Mock
    private PlantInfoExtractorFacade plantInfoExtractorFacade;
    @InjectMocks
    private BotanicalInfoController botanicalInfoController;


    @Test
    @DisplayName("Test get all botanical info")
    void testGetAllBotanicalInfo() {
        final BotanicalInfo botanicalInfo1 = new BotanicalInfo();
        final BotanicalInfo botanicalInfo2 = new BotanicalInfo();
        botanicalInfo1.setId(1L);
        botanicalInfo2.setId(2L);
        final BotanicalInfoDTO dto1 = new BotanicalInfoDTO();
        final BotanicalInfoDTO dto2 = new BotanicalInfoDTO();
        dto1.setId(1L);
        dto2.setId(2L);
        final List<BotanicalInfo> botanicalInfoList = Arrays.asList(botanicalInfo1, botanicalInfo2);
        final List<BotanicalInfoDTO> dtoList = Arrays.asList(dto1, dto2);
        Mockito.when(plantInfoExtractorFacade.getAll(5)).thenReturn(botanicalInfoList);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(botanicalInfo1)).thenReturn(dto1);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(botanicalInfo2)).thenReturn(dto2);

        final ResponseEntity<List<BotanicalInfoDTO>> responseEntity = botanicalInfoController.getAll(5);

        Assertions.assertEquals(dtoList, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get all botanical info with empty list")
    void testGetAllBotanicalInfoWithEmptyList() {
        Mockito.when(plantInfoExtractorFacade.getAll(5)).thenReturn(Collections.emptyList());

        final ResponseEntity<List<BotanicalInfoDTO>> responseEntity = botanicalInfoController.getAll(5);

        Assertions.assertEquals(Collections.emptyList(), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get partial botanical info")
    void testGetPartialBotanicalInfo() {
        final String partialScientificName = "rose";
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(1L);
        final BotanicalInfoDTO dto = new BotanicalInfoDTO();
        dto.setId(1L);
        final List<BotanicalInfo> botanicalInfoList = Collections.singletonList(botanicalInfo);
        final List<BotanicalInfoDTO> dtoList = Collections.singletonList(dto);

        Mockito.when(plantInfoExtractorFacade.extractPlants(partialScientificName, 5)).thenReturn(botanicalInfoList);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(botanicalInfo)).thenReturn(dto);

        final ResponseEntity<List<BotanicalInfoDTO>> responseEntity =
            botanicalInfoController.getPartial(5, partialScientificName);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(dtoList, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test get partial botanical info with empty list")
    void testGetPartialBotanicalInfoWithEmptyList() {
        final String partialScientificName = "unknown";
        Mockito.when(plantInfoExtractorFacade.extractPlants(partialScientificName, 5))
               .thenReturn(Collections.emptyList());
        final ResponseEntity<List<BotanicalInfoDTO>> responseEntity =
            botanicalInfoController.getPartial(5, partialScientificName);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(Collections.emptyList(), responseEntity.getBody());
    }


    @Test
    @DisplayName("Test count plants for a botanical info")
    void testCountPlantsForBotanicalInfo() {
        final long botanicalInfoId = 1L;
        final int expectedCount = 5;
        Mockito.when(botanicalInfoService.countPlants(botanicalInfoId)).thenReturn(expectedCount);

        final ResponseEntity<Integer> responseEntity = botanicalInfoController.count(botanicalInfoId);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(expectedCount, responseEntity.getBody().intValue());
    }


    @Test
    @DisplayName("Test count all botanical info")
    void testCountAllBotanicalInfo() {
        final long totalCount = 10L;
        Mockito.when(botanicalInfoService.count()).thenReturn(totalCount);

        final ResponseEntity<Long> responseEntity = botanicalInfoController.countAll();

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(totalCount, responseEntity.getBody().longValue());
    }


    @Test
    @DisplayName("Test saving a new botanical info")
    void testSaveBotanicalInfo() {
        final BotanicalInfoDTO botanicalInfoDTO = new BotanicalInfoDTO();
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoDtoConverter.convertFromDTO(botanicalInfoDTO)).thenReturn(botanicalInfo);
        Mockito.when(botanicalInfoService.save(botanicalInfo)).thenReturn(botanicalInfo);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(botanicalInfo)).thenReturn(botanicalInfoDTO);
        final ResponseEntity<BotanicalInfoDTO> responseEntity = botanicalInfoController.save(botanicalInfoDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(botanicalInfoDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test getting a botanical info by ID")
    void testGetBotanicalInfoById() {
        final long id = 1L;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        BotanicalInfoDTO botanicalInfoDTO = new BotanicalInfoDTO();
        Mockito.when(botanicalInfoService.get(id)).thenReturn(botanicalInfo);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(botanicalInfo)).thenReturn(botanicalInfoDTO);

        final ResponseEntity<BotanicalInfoDTO> responseEntity = botanicalInfoController.get(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(botanicalInfoDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test updating a botanical info")
    void testUpdateBotanicalInfo() {
        final long id = 1L;
        final BotanicalInfoDTO updatedDTO = new BotanicalInfoDTO();
        final BotanicalInfo updatedInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoDtoConverter.convertFromDTO(updatedDTO)).thenReturn(updatedInfo);
        Mockito.when(botanicalInfoService.update(id, updatedInfo)).thenReturn(updatedInfo);
        Mockito.when(botanicalInfoDtoConverter.convertToDTO(updatedInfo)).thenReturn(updatedDTO);

        final ResponseEntity<BotanicalInfoDTO> responseEntity = botanicalInfoController.update(id, updatedDTO);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertEquals(updatedDTO, responseEntity.getBody());
    }


    @Test
    @DisplayName("Test deleting a botanical info by ID")
    void testDeleteBotanicalInfo() {
        final long id = 1L;

        final ResponseEntity<String> responseEntity = botanicalInfoController.remove(id);

        Assertions.assertEquals(HttpStatus.OK, responseEntity.getStatusCode());
        Assertions.assertTrue(responseEntity.getBody().contains("success"));
    }


    @Test
    @DisplayName("Test getting a botanical info by non-existing ID")
    void testGetBotanicalInfoByNonExistentId() {
        final long id = 1L;
        Mockito.doThrow(ResourceNotFoundException.class).when(botanicalInfoService).get(id);

        Mockito.doThrow(ResourceNotFoundException.class).when(botanicalInfoService).get(id);
    }


    @Test
    @DisplayName("Test updating a non-existent botanical info")
    void testUpdateNonExistentBotanicalInfo() {
        final long id = 1L;
        final BotanicalInfoDTO updatedDTO = new BotanicalInfoDTO();
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoDtoConverter.convertFromDTO(updatedDTO)).thenReturn(botanicalInfo);
        Mockito.doThrow(ResourceNotFoundException.class).when(botanicalInfoService).update(id, botanicalInfo);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> botanicalInfoController.update(id, updatedDTO));
    }


    @Test
    @DisplayName("Test deleting a non-existent botanical info")
    void testDeleteNonExistentBotanicalInfo() {
        final long id = -1L;
        Mockito.doThrow(ResourceNotFoundException.class).when(botanicalInfoService).delete(id);

        Assertions.assertThrows(ResourceNotFoundException.class, () -> botanicalInfoController.remove(id));
    }


    @Test
    @DisplayName("Test getting a botanical info by invalid ID")
    void testGetBotanicalInfoByInvalidId() {
        final long id = 1L;
        Mockito.doThrow(UnauthorizedException.class).when(botanicalInfoService).get(id);

        Mockito.doThrow(UnauthorizedException.class).when(botanicalInfoService).get(id);
    }


    @Test
    @DisplayName("Test updating a invalid botanical info")
    void testUpdateInvalidBotanicalInfo() {
        final long id = 1L;
        final BotanicalInfoDTO updatedDTO = new BotanicalInfoDTO();
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        Mockito.when(botanicalInfoDtoConverter.convertFromDTO(updatedDTO)).thenReturn(botanicalInfo);
        Mockito.doThrow(UnauthorizedException.class).when(botanicalInfoService).update(id, botanicalInfo);

        Assertions.assertThrows(UnauthorizedException.class, () -> botanicalInfoController.update(id, updatedDTO));
    }


    @Test
    @DisplayName("Test deleting a invalid botanical info")
    void testDeleteInvalidBotanicalInfo() {
        final long id = -1L;
        Mockito.doThrow(UnauthorizedException.class).when(botanicalInfoService).delete(id);

        Assertions.assertThrows(UnauthorizedException.class, () -> botanicalInfoController.remove(id));
    }
}

package com.github.mdeluise.plantit.plant.controller;

import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantController;
import com.github.mdeluise.plantit.plant.PlantDTO;
import com.github.mdeluise.plantit.plant.PlantDTOConverter;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.security.apikey.ApiKeyFilter;
import com.github.mdeluise.plantit.security.apikey.ApiKeyRepository;
import com.github.mdeluise.plantit.security.apikey.ApiKeyService;
import com.github.mdeluise.plantit.security.jwt.JwtTokenFilter;
import com.github.mdeluise.plantit.security.jwt.JwtTokenUtil;
import com.github.mdeluise.plantit.security.jwt.JwtWebUtil;
import org.hamcrest.Matchers;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;


@WebMvcTest(PlantController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class PlantControllerTest {
    @MockBean
    JwtTokenFilter jwtTokenFilter;
    @MockBean
    JwtTokenUtil jwtTokenUtil;
    @MockBean
    JwtWebUtil jwtWebUtil;
    @MockBean
    ApiKeyFilter apiKeyFilter;
    @MockBean
    ApiKeyService apiKeyService;
    @MockBean
    ApiKeyRepository apiKeyRepository;
    @MockBean
    AuthenticatedUserService authenticatedUserService;
    @MockBean
    PlantService plantService;
    @MockBean
    PlantDTOConverter plantDTOConverter;
    @Autowired
    ObjectMapper objectMapper;
    @Autowired
    MockMvc mockMvc;


    @Test
    @DisplayName("Should be able to retrieve all plant")
    void shouldGetAll() throws Exception {
        final long plant1Id = 1;
        final Plant plant1 = new Plant();
        plant1.setId(plant1Id);
        final PlantDTO plant1DTO = new PlantDTO();
        plant1DTO.setId(plant1Id);
        final long plant2Id = 2;
        final Plant plant2 = new Plant();
        plant2.setId(plant2Id);
        final PlantDTO plant2DTO = new PlantDTO();
        plant2DTO.setId(plant2Id);
        final Sort defaultSort = Sort.by(new Sort.Order(Sort.Direction.DESC, "id").ignoreCase());
        final Pageable defaultPageable = PageRequest.of(0, 10, defaultSort);

        Mockito.when(plantService.getAll(defaultPageable)).thenReturn(new PageImpl<>(List.of(plant1, plant2)));
        Mockito.when(plantDTOConverter.convertToDTO(plant1)).thenReturn(plant1DTO);
        Mockito.when(plantDTOConverter.convertToDTO(plant2)).thenReturn(plant2DTO);

        mockMvc.perform(MockMvcRequestBuilders.get("/plant")).andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.content").isArray())
               .andExpect(MockMvcResultMatchers.jsonPath("$.content", Matchers.hasSize(2)));
    }


    @Test
    @DisplayName("Should be able to retrieve a specific plant")
    void shouldGet() throws Exception {
        final long toGetId = 1;
        final Plant toGet = new Plant();
        toGet.setId(toGetId);
        final PlantDTO toGetDTO = new PlantDTO();
        toGetDTO.setId(toGetId);

        Mockito.when(plantService.get(toGetId)).thenReturn(toGet);
        Mockito.when(plantDTOConverter.convertToDTO(toGet)).thenReturn(toGetDTO);

        mockMvc.perform(MockMvcRequestBuilders.get("/plant/" + toGetId))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(toGetDTO)));
    }


    @Test
    @DisplayName("Should return error if trying to retrieve a non existing plant")
    void shouldReturnErrorWhenGetNonExisting() throws Exception {
        final long toGetId = 1;

        Mockito.when(plantService.get(toGetId)).thenThrow(new ResourceNotFoundException(toGetId));

        mockMvc.perform(MockMvcRequestBuilders.get("/plant/" + toGetId))
               .andExpect(MockMvcResultMatchers.status().isNotFound());
    }


    @Test
    @DisplayName("Should count plants")
    void shouldCount() throws Exception {
        final long count = 1;

        Mockito.when(plantService.count()).thenReturn(count);

        mockMvc.perform(MockMvcRequestBuilders.get("/plant/_count"))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(count));
    }


    @Test
    @DisplayName("Should save new plant and return it")
    void shouldSave() throws Exception {
        final Plant toSave = new Plant();
        toSave.setId(1L);
        final PlantDTO toSaveDTO = new PlantDTO();
        toSaveDTO.setId(1L);

        Mockito.when(plantService.save(toSave)).thenReturn(toSave);
        Mockito.when(plantDTOConverter.convertFromDTO(toSaveDTO)).thenReturn(toSave);
        Mockito.when(plantDTOConverter.convertToDTO(toSave)).thenReturn(toSaveDTO);

        mockMvc.perform(MockMvcRequestBuilders.post("/plant").content(
                   objectMapper.writeValueAsString(plantDTOConverter.convertToDTO(toSave)))
                                              .contentType(MediaType.APPLICATION_JSON))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(toSaveDTO)));
    }


    @Test
    @DisplayName("Should update new plant and return it")
    void shouldUpdate() throws Exception {
        final String updatedPersonalName = "updated personal name";
        final Long plantId = 1L;
        final Plant updated = new Plant();
        updated.setId(plantId);
        updated.setPersonalName(updatedPersonalName);
        final PlantDTO updatedDTO = new PlantDTO();
        updatedDTO.setId(1L);
        updatedDTO.setPersonalName(updatedPersonalName);

        Mockito.when(plantService.update(plantId, updated)).thenReturn(updated);
        Mockito.when(plantDTOConverter.convertFromDTO(updatedDTO)).thenReturn(updated);
        Mockito.when(plantDTOConverter.convertToDTO(updated)).thenReturn(updatedDTO);

        mockMvc.perform(MockMvcRequestBuilders.put("/plant/" + plantId).content(
                                                  objectMapper.writeValueAsString(plantDTOConverter.convertToDTO(updated)))
                                              .contentType(MediaType.APPLICATION_JSON))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(updatedDTO)));
    }


    @Test
    @DisplayName("Should be able to delete a specific plant")
    void shouldDelete() throws Exception {
        final long toDeleteId = 1;

        Mockito.doNothing().when(plantService).delete(toDeleteId);

        mockMvc.perform(MockMvcRequestBuilders.delete("/plant/" + toDeleteId))
               .andExpect(MockMvcResultMatchers.status().isOk());

        Mockito.verify(plantService).delete(toDeleteId);
    }


    @Test
    @DisplayName("Should return error if trying to delete a non existing plant")
    void shouldReturnErrorWhenDeleteNonExisting() throws Exception {
        final long toDeleteId = 1;

        Mockito.doThrow(ResourceNotFoundException.class).when(plantService).delete(toDeleteId);

        mockMvc.perform(MockMvcRequestBuilders.delete("/plant/" + toDeleteId))
               .andExpect(MockMvcResultMatchers.status().isNotFound());
    }


    @Test
    @DisplayName("Should count the plants' botanical info")
    void shouldCountPlantBotanicalInfo() throws Exception {
        final long count = 1;

        Mockito.when(plantService.getNumberOfDistinctBotanicalInfo()).thenReturn(count);

        mockMvc.perform(MockMvcRequestBuilders.get("/plant/_countBotanicalInfo"))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(count + ""));
    }


    @Test
    @DisplayName("Check if the plant's name already exists")
    void shouldCheckPlantNameExistence() throws Exception {
        final String plantName = "this is the plant name";

        Mockito.when(plantService.isNameAlreadyExisting(plantName)).thenReturn(true);

        mockMvc.perform(MockMvcRequestBuilders.get(String.format("/plant/%s/_name-exists", plantName)))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(true));
    }
}
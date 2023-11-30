package com.github.mdeluise.plantit.botanicalinfo.controller;

import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoController;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTOConverter;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractorFacade;
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
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@WebMvcTest(BotanicalInfoController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class BotanicalInfoControllerTest {
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
    PlantInfoExtractorFacade plantInfoExtractorFacade;
    @MockBean
    BotanicalInfoDTOConverter botanicalInfoDTOConverter;
    @MockBean
    BotanicalInfoService botanicalInfoService;
    @Autowired
    ObjectMapper objectMapper;
    @Autowired
    MockMvc mockMvc;

    @Test
    @DisplayName("Should be able to retrieve all botanical info")
    void shouldGetAll() throws Exception {
        final BotanicalInfo botanicalInfo1 = new BotanicalInfo();
        botanicalInfo1.setId(1L);
        botanicalInfo1.setScientificName("scientific_name_1");
        botanicalInfo1.setSpecies("species_1");
        final BotanicalInfo botanicalInfo2 = new BotanicalInfo();
        botanicalInfo2.setId(2L);
        botanicalInfo2.setScientificName("scientific_name_2");
        botanicalInfo1.setSpecies("species_2");
        final BotanicalInfoDTO botanicalInfoDTO1 = new BotanicalInfoDTO();
        botanicalInfoDTO1.setId(1L);
        botanicalInfoDTO1.setScientificName("scientific_name_1");
        botanicalInfo1.setSpecies("species_1");
        final BotanicalInfoDTO botanicalInfoDTO2 = new BotanicalInfoDTO();
        botanicalInfoDTO2.setId(2L);
        botanicalInfoDTO2.setScientificName("scientific_name_2");
        botanicalInfo1.setSpecies("species_2");
        final int defaultSize = 5;

        Mockito.when(plantInfoExtractorFacade.getAll(defaultSize)).thenReturn(List.of(botanicalInfo1, botanicalInfo2));
        Mockito.when(botanicalInfoDTOConverter.convertToDTO(botanicalInfo1)).thenReturn(botanicalInfoDTO1);
        Mockito.when(botanicalInfoDTOConverter.convertToDTO(botanicalInfo2)).thenReturn(botanicalInfoDTO2);

        mockMvc.perform(MockMvcRequestBuilders.get("/botanical-info"))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.jsonPath("$").isArray())
            .andExpect(MockMvcResultMatchers.jsonPath("$", Matchers.hasSize(2)));
    }


    @Test
    @DisplayName("Should delete a specific botanical info")
    void shouldDelete() throws Exception {
        final long idToRemove = 0;

        Mockito.doNothing().when(botanicalInfoService).delete(idToRemove);

        mockMvc.perform(MockMvcRequestBuilders.delete("/botanical-info/" + idToRemove))
               .andExpect(MockMvcResultMatchers.status().isOk());
    }


    @Test
    @DisplayName("Should return error if trying to delete a non existing botanical info")
    void shouldReturnErrorWhenDeleteNonExisting() throws Exception {
        final long idToRemove = 0;

        Mockito.doThrow(ResourceNotFoundException.class).when(botanicalInfoService).delete(idToRemove);

        mockMvc.perform(MockMvcRequestBuilders.delete("/botanical-info/0"))
               .andExpect(MockMvcResultMatchers.status().isNotFound());
    }


    @Test
    @DisplayName("Should return error when delete another user's botanical info")
    void shouldReturnErrorWhenDeleteAnotherUser() throws Exception {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(1L);
        final long idToRemove = 0;

        Mockito.doThrow(new UnauthorizedException()).when(botanicalInfoService).delete(idToRemove);

        mockMvc.perform(MockMvcRequestBuilders.delete("/botanical-info/" + idToRemove))
               .andExpect(MockMvcResultMatchers.status().isUnauthorized());
    }


    @Test
    @DisplayName("Should save new botanical info and return it")
    void shouldSave() throws Exception {
        final BotanicalInfo toSave = new BotanicalInfo();
        toSave.setSpecies("species");
        toSave.setId(1L);
        final BotanicalInfoDTO toSaveDTO = new BotanicalInfoDTO();
        toSaveDTO.setSpecies("species");
        toSaveDTO.setId(1L);

        Mockito.when(botanicalInfoService.save(toSave)).thenReturn(toSave);
        Mockito.when(botanicalInfoDTOConverter.convertToDTO(toSave)).thenReturn(toSaveDTO);
        Mockito.when(botanicalInfoDTOConverter.convertFromDTO(toSaveDTO)).thenReturn(toSave);

        mockMvc.perform(MockMvcRequestBuilders.post("/botanical-info").content(
                                                  objectMapper.writeValueAsString(botanicalInfoDTOConverter.convertToDTO(toSave)))
                                              .contentType(MediaType.APPLICATION_JSON))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.species").value("species"))
               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(1));
    }
}

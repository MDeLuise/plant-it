package com.github.mdeluise.plantit.image.controller;

import java.util.Base64;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.EntityImageImpl;
import com.github.mdeluise.plantit.image.ImageController;
import com.github.mdeluise.plantit.image.ImageDTO;
import com.github.mdeluise.plantit.image.ImageDTOConverter;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
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
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@WebMvcTest(ImageController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class ImageControllerTest {
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
    ImageStorageService imageStorageService;
    @MockBean
    BotanicalInfoService botanicalInfoService;
    @MockBean
    PlantService plantService;
    @MockBean
    ImageDTOConverter imageDTOConverter;
    @Autowired
    ObjectMapper objectMapper;
    @Autowired
    MockMvc mockMvc;


    @Test
    @DisplayName("Should be able to get a specific image")
    void shouldGet() throws Exception {
        final String idToGet = "this-is-the-id-1";
        final EntityImage toGet = new EntityImageImpl();
        toGet.setId(idToGet);
        final ImageDTO toGetDTO = new ImageDTO();
        toGetDTO.setId(idToGet);

        Mockito.when(imageStorageService.get(idToGet)).thenReturn(toGet);
        Mockito.when(imageDTOConverter.convertToDTO(toGet)).thenReturn(toGetDTO);

        mockMvc.perform(MockMvcRequestBuilders.get("/image/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(idToGet));
    }


    @Test
    @DisplayName("Should return error if trying to retrieve a non existing image")
    void shouldReturnErrorWhenGetNonExisting() throws Exception {
        final String idToGet = "this-is-the-id-1";

        Mockito.when(imageStorageService.get(idToGet)).thenThrow(new ResourceNotFoundException(idToGet));

        mockMvc.perform(MockMvcRequestBuilders.get("/image/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should be able to get a specific image content")
    void shouldReturnImageContent() throws Exception {
        final String idToGet = "this-is-the-id-1";
        final byte[] content = new byte[]{0, 1, 0, 1};
        final String contentString = Base64.getEncoder().encodeToString(content);

        Mockito.when(imageStorageService.getContent(idToGet)).thenReturn(content);

        mockMvc.perform(MockMvcRequestBuilders.get("/image/content/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(contentString));
    }


    @Test
    @DisplayName("Should return error when get non existing image content")
    void shouldReturnErrorWhenGetNonExistingContent() throws Exception {
        final String idToGet = "this-is-the-id-1";

        Mockito.when(imageStorageService.getContent(idToGet)).thenThrow(new ResourceNotFoundException(idToGet));

        mockMvc.perform(MockMvcRequestBuilders.get("/image/content/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should get an image thumbnail")
    void shouldGetImageThumbnail() throws Exception {
        final String idToGet = "this-is-the-id-1";
        final byte[] content = new byte[]{0, 1, 0, 1};
        final String contentString = Base64.getEncoder().encodeToString(content);

        Mockito.when(imageStorageService.getThumbnail(idToGet)).thenReturn(content);

        mockMvc.perform(MockMvcRequestBuilders.get("/image/thumbnail/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(contentString));
    }


    @Test
    @DisplayName("Should return error when get a non existing image thumbnail")
    void shouldReturnErrorWhenGetNonExistingThumbnail() throws Exception {
        final String idToGet = "this-is-the-id-1";

        Mockito.when(imageStorageService.getThumbnail(idToGet)).thenThrow(new ResourceNotFoundException(idToGet));

        mockMvc.perform(MockMvcRequestBuilders.get("/image/thumbnail/" + idToGet))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should be able to delete a specific image")
    void shouldDelete() throws Exception {
        final String idToDelete = "this-is-the-id-1";

        mockMvc.perform(MockMvcRequestBuilders.delete("/image/" + idToDelete));

        Mockito.verify(imageStorageService, Mockito.times(1)).remove(idToDelete);
    }


    @Test
    @DisplayName("Should return error when delete non existing image")
    void shouldReturnErrorWhenDeleteNonExisting() throws Exception {
        final String idToDelete = "this-is-the-id-1";

        Mockito.doThrow(new ResourceNotFoundException(idToDelete)).when(imageStorageService).remove(idToDelete);

        mockMvc.perform(MockMvcRequestBuilders.delete("/image/" + idToDelete))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should be able to retrieve all plant's images")
    void shouldReturnAll() throws Exception {
        final long plantId = 1;
        final Plant plant = new Plant();
        plant.setId(plantId);
        final List<String> plantImageIds = List.of("1", "2", "3");

        Mockito.when(plantService.get(plantId)).thenReturn(plant);
        Mockito.when(imageStorageService.getAllIds(plant)).thenReturn(plantImageIds);

        mockMvc.perform(MockMvcRequestBuilders.get("/image/entity/all/" + plantId))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").isArray())
               .andExpect(MockMvcResultMatchers.jsonPath("$", Matchers.hasSize(3)));
    }


    @Test
    @DisplayName("Should return error if trying to retrieve a non existing plant's images")
    void shouldReturnErrorWhenGetAllNonExisting() throws Exception {
        final long plantId = 1;

        Mockito.when(plantService.get(plantId)).thenThrow(new ResourceNotFoundException(plantId));

        mockMvc.perform(MockMvcRequestBuilders.get("/image/entity/all/" + plantId))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should count the plants' images")
    void shouldCountAll() throws Exception {
        final int count = 42;
        Mockito.when(imageStorageService.count()).thenReturn(count);

        mockMvc.perform(MockMvcRequestBuilders.get("/image/entity/_count"))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").value(count));
    }


    // TODO
    //    @Test
    //    void whenSaveBotanicalInfoImage_thenShouldSave() throws Exception {
    //        final long idToSave = 1;
    //        final String idOfCreatedImage = "this-is-the-id";
    //        final BotanicalInfo botanicalInfo = new BotanicalInfo();
    //        botanicalInfo.setId(idToSave);
    //        final EntityImage createdEntityImage = new EntityImageImpl();
    //        createdEntityImage.setId(idOfCreatedImage);
    //        final ImageDTO createdImageDTO = new ImageDTO();
    //        createdImageDTO.setId(idOfCreatedImage);
    //        final MultipartFile multipartFile = new MockMultipartFile("file-name", new byte[]{});
    //
    //
    //        Mockito.when(botanicalInfoService.get(idToSave)).thenReturn(botanicalInfo);
    //        Mockito.when(imageStorageService.save(multipartFile, botanicalInfo, null)).thenReturn(createdEntityImage);
    //        Mockito.when(imageDTOConverter.convertToDTO(createdEntityImage)).thenReturn(createdImageDTO);
    //
    //        mockMvc.perform(MockMvcRequestBuilders.post("/botanical-info/" + idToSave)
    //                                              .contentType(MediaType.IMAGE_JPEG)
    //                                              .content(objectMapper.writeValueAsString(multipartFile)))
    //               .andExpect(MockMvcResultMatchers.status().isOk())
    //               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(idOfCreatedImage));
    //    }
}
package com.github.mdeluise.plantit.diary.controller;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryController;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTO;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTOConverter;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
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
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@WebMvcTest(DiaryEntryController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class DiaryEntryControllerTest {
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
    DiaryEntryDTOConverter diaryEntryDTOConverter;
    @MockBean
    DiaryEntryService diaryEntryService;
    @MockBean
    AuthenticatedUserService authenticatedUserService;
    @Autowired
    ObjectMapper objectMapper;
    @Autowired
    MockMvc mockMvc;


    @Test
    @DisplayName("Should be able to retrieve all diary entries")
    void shouldGetAll() throws Exception {
        final User owner = new User(0L, "user", "password");
        final DiaryEntry diaryEntry1 = new DiaryEntry();
        diaryEntry1.setId(1L);
        final DiaryEntry diaryEntry2 = new DiaryEntry();
        diaryEntry2.setId(2L);
        final DiaryEntryDTO diaryEntryDTO1 = new DiaryEntryDTO();
        final DiaryEntryDTO diaryEntryDTO2 = new DiaryEntryDTO();
        final Pageable defaultPageable = PageRequest.of(0, 25, Sort.Direction.DESC, "date");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(owner);
        Mockito.when(diaryEntryService.getAll(defaultPageable, new ArrayList<>(), new ArrayList<>()))
               .thenReturn(new PageImpl<>(List.of(diaryEntry1, diaryEntry2)));
        Mockito.when(diaryEntryDTOConverter.convertToDTO(diaryEntry1)).thenReturn(diaryEntryDTO1);
        Mockito.when(diaryEntryDTOConverter.convertToDTO(diaryEntry2)).thenReturn(diaryEntryDTO2);

        mockMvc.perform(MockMvcRequestBuilders.get("/diary/entry"))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.content").isArray())
               .andExpect(MockMvcResultMatchers.jsonPath("$.content", Matchers.hasSize(2)));
    }


    @Test
    @DisplayName("Should be able to retrieve a specific diary entry")
    void shouldGet() throws Exception {
        final long toReturnId = 1;
        final DiaryEntry toReturn = new DiaryEntry();
        toReturn.setId(toReturnId);
        final DiaryEntryDTO toReturnDTO = new DiaryEntryDTO();
        toReturnDTO.setId(toReturnId);

        Mockito.when(diaryEntryService.get(toReturnId)).thenReturn(toReturn);
        Mockito.when(diaryEntryDTOConverter.convertToDTO(toReturn)).thenReturn(toReturnDTO);

        mockMvc.perform(MockMvcRequestBuilders.get("/diary/entry/" + toReturnId))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(toReturnId));
    }


    @Test
    @DisplayName("Should return error when get non existing diary entry")
    void shouldReturnErrorWhenGetNonExisting() throws Exception {
        final long nonExisting = 1;
        Mockito.when(diaryEntryService.get(nonExisting)).thenThrow(new ResourceNotFoundException(nonExisting));

        mockMvc.perform(MockMvcRequestBuilders.get("/diary/entry/" + nonExisting))
               .andExpect(MockMvcResultMatchers.status().is4xxClientError());
    }


    @Test
    @DisplayName("Should be able to delete a specific diary entry")
    void shouldDelete() throws Exception {
        final long toDeleteId = 1;
        mockMvc.perform(MockMvcRequestBuilders.delete("/diary/entry/" + toDeleteId))
                                           .andExpect(MockMvcResultMatchers.status().isOk());
        Mockito.verify(diaryEntryService, Mockito.times(1)).delete(toDeleteId);
    }
}

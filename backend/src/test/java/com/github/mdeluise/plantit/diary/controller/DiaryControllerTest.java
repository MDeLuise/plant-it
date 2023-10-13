package com.github.mdeluise.plantit.diary.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryController;
import com.github.mdeluise.plantit.diary.DiaryDTO;
import com.github.mdeluise.plantit.diary.DiaryDTOConverter;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.diary.entry.DiaryEntry;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTO;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryDTOConverter;
import com.github.mdeluise.plantit.diary.entry.DiaryEntryService;
import com.github.mdeluise.plantit.security.apikey.ApiKeyFilter;
import com.github.mdeluise.plantit.security.apikey.ApiKeyRepository;
import com.github.mdeluise.plantit.security.apikey.ApiKeyService;
import com.github.mdeluise.plantit.security.jwt.JwtTokenFilter;
import com.github.mdeluise.plantit.security.jwt.JwtTokenUtil;
import com.github.mdeluise.plantit.security.jwt.JwtWebUtil;
import org.hamcrest.Matchers;
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

import java.util.List;

@WebMvcTest(DiaryController.class)
@AutoConfigureMockMvc(addFilters = false)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
public class DiaryControllerTest {
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
    DiaryDTOConverter diaryDTOConverter;
    @MockBean
    DiaryService diaryService;
    @MockBean
    DiaryEntryService diaryEntryService;
    @MockBean
    DiaryEntryDTOConverter diaryEntryDTOConverter;
    @Autowired
    ObjectMapper objectMapper;
    @Autowired
    MockMvc mockMvc;


    @Test
    void whenGetDiaries_thenShouldReturnDiaries() throws Exception {
        final Diary diary1 = new Diary();
        diary1.setId(1L);
        final Diary diary2 = new Diary();
        diary2.setId(2L);
        final DiaryDTO diaryDTO1 = new DiaryDTO();
        diaryDTO1.setId(1L);
        final DiaryDTO diaryDTO2 = new DiaryDTO();
        diaryDTO2.setId(2L);
        final Pageable defaultPageable = PageRequest.of(0, 25, Sort.Direction.DESC, "date");

        Mockito.when(diaryService.getAll(defaultPageable)).thenReturn(new PageImpl<>(List.of(diary1, diary2)));
        Mockito.when(diaryDTOConverter.convertToDTO(diary1)).thenReturn(diaryDTO1);
        Mockito.when(diaryDTOConverter.convertToDTO(diary2)).thenReturn(diaryDTO2);

        mockMvc.perform(MockMvcRequestBuilders.get("/diary"))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$").isArray())
               .andExpect(MockMvcResultMatchers.jsonPath("$", Matchers.hasSize(2)));
    }


    @Test
    void whenGetDiary_thenShouldReturnDiary() throws Exception {
        final long toReturnId = 1;
        final Diary toReturn = new Diary();
        toReturn.setId(toReturnId);
        final DiaryDTO toReturnDTO = new DiaryDTO();
        toReturnDTO.setId(toReturnId);

        Mockito.when(diaryService.get(toReturnId)).thenReturn(toReturn);
        Mockito.when(diaryDTOConverter.convertToDTO(toReturn)).thenReturn(toReturnDTO);

        mockMvc.perform(MockMvcRequestBuilders.get("/diary/" + toReturnId))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(toReturnId));
    }


    @Test
    void whenCreateDiaryEntry_thenShouldCreate() throws Exception {
        final DiaryEntry toSave = new DiaryEntry();
        toSave.setId(1L);
        DiaryEntryDTO toSaveDTO = new DiaryEntryDTO();
        toSaveDTO.setId(1L);

        Mockito.when(diaryEntryService.save(toSave)).thenReturn(toSave);
        Mockito.when(diaryDTOConverter.convertToDTO(toSave)).thenReturn(toSaveDTO);
        Mockito.when(diaryDTOConverter.convertFromDTO(toSaveDTO)).thenReturn(toSave);

        mockMvc.perform(MockMvcRequestBuilders.post("/diary").content(
                                                  objectMapper.writeValueAsString(diaryDTOConverter.convertToDTO(toSave)))
                                              .contentType(MediaType.APPLICATION_JSON))
               .andExpect(MockMvcResultMatchers.status().isOk())
               .andExpect(MockMvcResultMatchers.jsonPath("$.species").value("species"))
               .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(1));
    }
}

package com.github.mdeluise.plantit.diary.service;

import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.diary.DiaryRepository;
import com.github.mdeluise.plantit.diary.DiaryService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class DiaryServiceTest {
    @Mock
    PlantService plantService;
    @Mock
    AuthenticatedUserService authenticatedUserService;
    @Mock
    DiaryRepository diaryRepository;
    @InjectMocks
    DiaryService diaryService;


    @Test
    @DisplayName("Should get all diaries")
    void shouldGetAll() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Sort sort = Sort.by(new Sort.Order(Sort.Direction.DESC, "id").ignoreCase());
        final Pageable pageable = PageRequest.of(0, 10, sort);
        final Diary toGet1 = new Diary();
        toGet1.setId(1L);
        final Diary toGet2 = new Diary();
        toGet2.setId(2L);
        final Page<Diary> toGet = new PageImpl<>(List.of(toGet1, toGet2));

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(diaryRepository.findAllByOwner(authenticatedUser, pageable)).thenReturn(toGet);

        Assertions.assertThat(diaryService.getAll(pageable)).as("diaries are correct").hasSameElementsAs(toGet);
    }


    @Test
    @DisplayName("Should get diary")
    void shouldGet() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant target = new Plant();
        target.setId(1L);
        final long targetId = 1;
        final Diary toGet = new Diary();
        toGet.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantService.get(targetId)).thenReturn(target);
        Mockito.when(diaryRepository.findByOwnerAndTarget(authenticatedUser, target)).thenReturn(Optional.of(toGet));

        Assertions.assertThat(diaryService.get(targetId)).as("diary is correct").isEqualTo(toGet);
    }


    @Test
    @DisplayName("Should return error on get non existing diary's target")
    void shouldReturnErrorWhenNonExisting() {
        final long targetId = 1;

        Mockito.when(plantService.get(targetId)).thenThrow(new ResourceNotFoundException(targetId));

        Assertions.assertThatThrownBy(() -> diaryService.get(targetId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error on get diary of another user's plant")
    void shouldReturnErrorWhenGetOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long targetId = 1;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantService.get(targetId)).thenThrow(new UnauthorizedException());

        Assertions.assertThatThrownBy(() -> diaryService.get(targetId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }
}
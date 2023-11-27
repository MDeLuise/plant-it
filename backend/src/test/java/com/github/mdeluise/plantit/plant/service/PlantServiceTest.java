package com.github.mdeluise.plantit.plant.service;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import com.github.mdeluise.plantit.TestEnvironment;
import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantRepository;
import com.github.mdeluise.plantit.plant.PlantService;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class PlantServiceTest {
    @Mock
    PlantRepository plantRepository;
    @Mock
    AuthenticatedUserService authenticatedUserService;
    @Mock
    ImageStorageService imageStorageService;
    @Mock
    PlantImageRepository plantImageRepository;
    @Mock
    BotanicalInfoService botanicalInfoService;
    @InjectMocks
    PlantService plantService;


    @Test
    @DisplayName("Should get all plants")
    void shouldGetAll() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant toReturn1 = new Plant();
        toReturn1.setId(1L);
        final Plant toReturn2 = new Plant();
        toReturn2.setId(2L);
        final Plant toReturn3 = new Plant();
        toReturn3.setId(3L);
        final PageImpl<Plant> toReturn = new PageImpl<>(List.of(toReturn1, toReturn2));
        final Sort sort = Sort.by(new Sort.Order(Sort.Direction.DESC, "id").ignoreCase());
        final Pageable pageable = PageRequest.of(0, 10, sort);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findAllByOwner(authenticatedUser, pageable)).thenReturn(toReturn);

        Assertions.assertThat(plantService.getAll(pageable)).as("plant page is correct").hasSameElementsAs(toReturn);
    }


    @Test
    @DisplayName("Should get plant")
    void shouldGet() {
        final long plantId = 1;
        final Plant toReturn = new Plant();
        toReturn.setId(plantId);

        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toReturn));

        Assertions.assertThat(plantService.get(plantId)).as("plant is correct").isEqualTo(toReturn);
    }


    @Test
    @DisplayName("Should return error on get non existing plant")
    void shouldReturnErrorWhenGetNonExisting() {
        final long plantId = 1;

        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.get(plantId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error on get plant of another user")
    void shouldReturnErrorWhenGetOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final long plantId = 1;
        final Plant toReturn = new Plant();
        toReturn.setId(plantId);
        toReturn.setOwner(owner);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toReturn));

        Assertions.assertThatThrownBy(() -> plantService.get(plantId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should count owned plants")
    void shouldCount() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long count = 42;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.countByOwner(authenticatedUser)).thenReturn(count);

        Assertions.assertThat(plantService.count()).as("count is correct").isEqualTo(count);
    }


    @Test
    @DisplayName("Should save plant")
    void shouldSave() {
        final long botanicalInfoId = 1;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(botanicalInfoId);
        botanicalInfo.setCreator(BotanicalInfoCreator.TREFLE);
        final Plant toSave = new Plant();
        toSave.setId(1L);
        toSave.setBotanicalInfo(botanicalInfo);

        Mockito.when(botanicalInfoService.get(botanicalInfoId)).thenReturn(botanicalInfo);
        Mockito.when(plantRepository.save(toSave)).thenReturn(toSave);

        Assertions.assertThat(plantService.save(toSave)).as("plant is correct").isEqualTo(toSave);
    }


    @Test
    @DisplayName("Should count distinct botanical info")
    void shouldCountDistinctBotanicalInfo() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Pageable pageable = Pageable.unpaged();
        final int count = 3;
        final Set<Plant> botanicalInfoPlants = new HashSet<>();
        for (int i = 0; i < count; i++) {
            final Plant plant = new Plant();
            plant.setId((long) i);
            plant.setOwner(authenticatedUser);
            final BotanicalInfo botanicalInfo = new BotanicalInfo();
            botanicalInfo.setId((long) i);
            plant.setBotanicalInfo(botanicalInfo);
            botanicalInfoPlants.add(plant);
        }
        final Plant notDistincBotanicalInfoPlant = new Plant();
        notDistincBotanicalInfoPlant.setBotanicalInfo(botanicalInfoPlants.stream().toList().get(0).getBotanicalInfo());
        botanicalInfoPlants.add(notDistincBotanicalInfoPlant);
        final PageImpl<Plant> toReturn = new PageImpl<>(botanicalInfoPlants.stream().toList());

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findAllByOwner(authenticatedUser, pageable)).thenReturn(toReturn);

        Assertions.assertThat(plantService.getNumberOfDistinctBotanicalInfo()).as("count is correct").isEqualTo(count);
    }


    @Test
    @DisplayName("Should check if name already exists")
    void shouldCheckNameExistence() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final String personalName1 = "personal name to check 1";
        final String personalName2 = "personal name to check 2";

        Mockito.when(plantRepository.existsByOwnerAndPersonalName(authenticatedUser, personalName1)).thenReturn(true);
        Mockito.when(plantRepository.existsByOwnerAndPersonalName(authenticatedUser, personalName2)).thenReturn(false);

        SoftAssertions softly = new SoftAssertions();
        softly.assertThat(plantService.isNameAlreadyExisting(personalName1)).as("name exists correctly").isTrue();
        softly.assertThat(plantService.isNameAlreadyExisting(personalName1)).as("name not exists correctly").isFalse();
    }


    @Test
    @DisplayName("Should delete plant and not botanical info")
    void shouldDelete() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long plantId = 1;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        final long botanicalInfoId = 1;
        botanicalInfo.setId(botanicalInfoId);
        final Plant toDelete = new Plant();
        toDelete.setId(plantId);
        toDelete.setOwner(authenticatedUser);
        toDelete.setBotanicalInfo(botanicalInfo);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoService.countPlants(botanicalInfoId)).thenReturn(2);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toDelete));

        Assertions.assertThatNoException().isThrownBy(() -> plantService.delete(plantId));
        Mockito.verify(botanicalInfoService, Mockito.never()).delete(botanicalInfoId);
    }


    @Test
    @DisplayName("Should delete images on plant delete")
    void shouldDeleteImages() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long plantId = 1;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        final long botanicalInfoId = 1;
        botanicalInfo.setId(botanicalInfoId);
        final Plant toDelete = new Plant();
        toDelete.setId(plantId);
        toDelete.setOwner(authenticatedUser);
        toDelete.setBotanicalInfo(botanicalInfo);
        final int plantImagesCount = 4;
        final Set<PlantImage> plantImages = new HashSet<>();
        for (int i = 0; i < plantImagesCount; i++) {
            final PlantImage plantImage = new PlantImage();
            plantImage.setId("images " + i);
            plantImages.add(plantImage);
        }
        toDelete.setImages(plantImages);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoService.countPlants(botanicalInfoId)).thenReturn(2);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toDelete));

        plantService.delete(plantId);

        for (int i = 0; i < plantImagesCount; i++) {
            Mockito.verify(imageStorageService, Mockito.times(1)).remove("images " + i);
        }
    }


    @Test
    @DisplayName("Should return error if delete non existing plant")
    void shouldReturnErrorWhenDeleteNonExisting() {
        final long plantId = 1;

        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.delete(plantId)).as("Exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error if delete plant of another user")
    void shouldReturnErrorWhenDeleteOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final long botanicalInfoId = 1;
        final Plant toGet = new Plant();
        toGet.setId(botanicalInfoId);
        toGet.setOwner(creator);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> plantService.delete(botanicalInfoId)).as("Exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    //    @Test
    //    @DisplayName("Should update plant and not botanical info")
    //    void shouldUpdate() {
    //        final User authenticatedUser = new User();
    //        authenticatedUser.setId(1L);
    //        final long plantId = 1;
    //        final BotanicalInfo botanicalInfo = new BotanicalInfo();
    //        final long botanicalInfoId = 1;
    //        botanicalInfo.setId(botanicalInfoId);
    //        final Plant toUpdate = new Plant();
    //        toUpdate.setAvatarMode(PlantAvatarMode.NONE);
    //        toUpdate.setId(plantId);
    //        toUpdate.setOwner(authenticatedUser);
    //        toUpdate.setBotanicalInfo(botanicalInfo);
    //        final Plant updated = new Plant();
    //        updated.setAvatarMode(PlantAvatarMode.NONE);
    //        updated.setId(plantId);
    //        updated.setOwner(authenticatedUser);
    //        updated.setBotanicalInfo(botanicalInfo);
    //        updated.setStartDate(new Date());
    //        updated.setPersonalName("Sergio");
    //
    //        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
    //        Mockito.when(botanicalInfoService.countPlants(botanicalInfoId)).thenReturn(2);
    //        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toUpdate));
    //        Mockito.when(plantRepository.save(Mockito.any())).thenAnswer(i -> i.getArguments()[0]);
    //
    //        Assertions.assertThat(plantService.update(updated)).isEqualTo(updated);
    //        Mockito.verify(botanicalInfoService, Mockito.never()).delete(botanicalInfoId);
    //    }


    //    @Test
    //    @DisplayName("Should update botanical info on plant update")
    //    void shouldUpdateBotanicalInfo() {
    //        final User authenticatedUser = new User();
    //        authenticatedUser.setId(1L);
    //        final long plantId = 1;
    //        final BotanicalInfo botanicalInfo = new BotanicalInfo();
    //        final long botanicalInfoId = 1;
    //        botanicalInfo.setId(botanicalInfoId);
    //        final BotanicalInfo updatedBotanicalInfo = new BotanicalInfo();
    //        updatedBotanicalInfo.setId(botanicalInfoId + 1);
    //        final Plant toUpdate = new Plant();
    //        toUpdate.setAvatarMode(PlantAvatarMode.NONE);
    //        toUpdate.setId(plantId);
    //        toUpdate.setOwner(authenticatedUser);
    //        toUpdate.setBotanicalInfo(botanicalInfo);
    //        final Plant updated = new Plant();
    //        updated.setAvatarMode(PlantAvatarMode.NONE);
    //        updated.setId(plantId);
    //        updated.setOwner(authenticatedUser);
    //        updated.setBotanicalInfo(updatedBotanicalInfo);
    //        updated.setStartDate(new Date());
    //        updated.setPersonalName("Sergio");
    //
    //        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
    //        Mockito.when(botanicalInfoService.countPlants(botanicalInfoId)).thenReturn(1);
    //        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(toUpdate));
    //        Mockito.when(botanicalInfoService.save(updatedBotanicalInfo)).thenReturn(updatedBotanicalInfo);
    //        Mockito.when(plantRepository.save(Mockito.any())).thenAnswer(i -> i.getArguments()[0]);
    //
    //
    //        Assertions.assertThat(plantService.update(updated)).isEqualTo(updated);
    //        Mockito.verify(botanicalInfoService, Mockito.times(1)).delete(botanicalInfoId);
    //    }


    @Test
    @DisplayName("Should return error if update non existing plant")
    void shouldReturnErrorWhenUpdateNonExisting() {
        final long plantId = 1;
        final Plant updated = new Plant();
        updated.setId(plantId);

        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.update(plantId, updated)).as("Exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error if update plant of another user")
    void shouldReturnErrorWhenUpdateOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final long botanicalInfoId = 1;
        final long plantId = 1;
        final Plant toUpdate = new Plant();
        toUpdate.setId(plantId);
        toUpdate.setId(botanicalInfoId);
        toUpdate.setOwner(creator);
        final Plant updated = new Plant();
        updated.setId(botanicalInfoId);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toUpdate));

        Assertions.assertThatThrownBy(() -> plantService.update(plantId, updated)).as("Exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }
}
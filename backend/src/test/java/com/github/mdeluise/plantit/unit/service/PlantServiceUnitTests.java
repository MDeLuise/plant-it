package com.github.mdeluise.plantit.unit.service;

import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantAvatarMode;
import com.github.mdeluise.plantit.plant.PlantRepository;
import com.github.mdeluise.plantit.plant.PlantService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for PlantService")
class PlantServiceUnitTests {
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @Mock
    private PlantRepository plantRepository;
    @Mock
    private BotanicalInfoService botanicalInfoService;
    @Mock
    private ImageStorageService imageStorageService;
    @Mock
    private PlantImageRepository plantImageRepository;
    @InjectMocks
    private PlantService plantService;


    @Test
    @DisplayName("Should get all plants")
    void shouldGetAllPlants() {
        final User authenticated = new User();
        final Pageable pageable = Pageable.unpaged();
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        final List<Plant> plants = List.of(plant1, plant2);
        final Page<Plant> plantPage = new PageImpl<>(plants);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantRepository.findAllByOwner(authenticated, pageable)).thenReturn(plantPage);

        final Page<Plant> result = plantService.getAll(pageable);

        Assertions.assertThat(result).isEqualTo(plantPage);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findAllByOwner(authenticated, pageable);
    }


    @Test
    @DisplayName("Should get plant by ID")
    void shouldGetPlantById() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long plantId = 1L;
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(authenticated);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(plant));

        final Plant result = plantService.get(plantId);

        Assertions.assertThat(result).isEqualTo(plant);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
    }


    @Test
    @DisplayName("Should throw error when getting non-existing plant")
    void shouldThrowResourceNotFoundExceptionWhenGettingNonExistingPlant() {
        final Long plantId = 1L;
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.get(plantId)).isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
    }


    @Test
    @DisplayName("Should throw error when getting plant owned by another user")
    void shouldThrowUnauthorizedExceptionWhenGettingPlantOwnedByAnotherUser() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Long plantId = 1L;
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(new User());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(plant));

        Assertions.assertThatThrownBy(() -> plantService.get(plantId)).isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
    }


    @Test
    @DisplayName("Should get count of all plants")
    void shouldGetCountOfAllPlants() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final long count = 5L;
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(plantRepository.countByOwner(authenticated)).thenReturn(count);

        final long result = plantService.count();

        Assertions.assertThat(result).isEqualTo(count);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).countByOwner(authenticated);
    }


    @Test
    @DisplayName("Should save plant successfully")
    void shouldSavePlantSuccessfully() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Plant plantToSave = new Plant();
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(1L);
        plantToSave.setBotanicalInfo(botanicalInfo);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);
        Mockito.when(botanicalInfoService.get(botanicalInfo.getId())).thenReturn(botanicalInfo);
        Mockito.when(plantRepository.save(plantToSave)).thenReturn(plantToSave);

        final Plant result = plantService.save(plantToSave);

        Assertions.assertThat(result).isEqualTo(plantToSave);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoService, Mockito.times(1)).get(botanicalInfo.getId());
        Mockito.verify(plantRepository, Mockito.times(1)).save(plantToSave);
    }


    @Test
    @DisplayName("Should throw error when saving plant with different owner")
    void shouldThrowUnauthorizedExceptionWhenSavingPlantWithDifferentOwner() {
        final User authenticated = new User();
        authenticated.setId(1L);
        final Plant plantToSave = new Plant();
        plantToSave.setOwner(new User());
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticated);

        Assertions.assertThatThrownBy(() -> plantService.save(plantToSave)).isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verifyNoInteractions(botanicalInfoService);
        Mockito.verifyNoInteractions(plantRepository);
    }


    @Test
    @DisplayName("Should return true if plant name already exists")
    void shouldReturnTrueIfPlantNameAlreadyExists() {
        final String plantName = "Rose";
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.existsByOwnerAndInfoPersonalName(authenticatedUser, plantName)).thenReturn(true);

        final boolean result = plantService.isNameAlreadyExisting(plantName);

        Assertions.assertThat(result).isTrue();
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1))
               .existsByOwnerAndInfoPersonalName(authenticatedUser, plantName);
    }


    @Test
    @DisplayName("Should return false if plant name does not already exist")
    void shouldReturnFalseIfPlantNameDoesNotAlreadyExist() {
        final String plantName = "Sunflower";
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.existsByOwnerAndInfoPersonalName(authenticatedUser, plantName)).thenReturn(false);

        final boolean result = plantService.isNameAlreadyExisting(plantName);

        Assertions.assertThat(result).isFalse();
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1))
               .existsByOwnerAndInfoPersonalName(authenticatedUser, plantName);
    }


    @Test
    @DisplayName("Should delete plant successfully")
    void shouldDeletePlantSuccessfully() {
        final Long plantId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(authenticatedUser);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(plant));

        plantService.delete(plantId);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(plantRepository, Mockito.times(1)).delete(plant);
    }


    @Test
    @DisplayName("Should throw error when deleting non-existing plant")
    void shouldThrowResourceNotFoundExceptionWhenDeletingNonExistingPlant() {
        final Long plantId = 1L;
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(new User());
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.delete(plantId)).isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(plantRepository, Mockito.never()).delete(Mockito.any());
    }


    @Test
    @DisplayName("Should throw error when deleting plant not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenDeletingPlantNotOwnedByAuthenticatedUser() {
        final Long plantId = 1L;
        final User plantOwner = new User();
        plantOwner.setId(2L);
        final Plant plant = new Plant();
        plant.setId(plantId);
        plant.setOwner(plantOwner);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(new User());
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(plant));

        Assertions.assertThatThrownBy(() -> plantService.delete(plantId)).isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(plantRepository, Mockito.never()).delete(Mockito.any());
    }


    @Test
    @DisplayName("Should update plant successfully")
    void shouldUpdatePlantSuccessfully() {
        final Long plantId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final Plant existingPlant = new Plant();
        existingPlant.setId(plantId);
        existingPlant.setOwner(authenticatedUser);
        final Plant updatedPlant = new Plant();
        updatedPlant.setId(plantId);
        updatedPlant.setOwner(authenticatedUser);
        updatedPlant.setBotanicalInfo(new BotanicalInfo());
        updatedPlant.setAvatarMode(PlantAvatarMode.NONE);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(existingPlant));
        Mockito.when(botanicalInfoService.get(updatedPlant.getBotanicalInfo().getId())).thenReturn(new BotanicalInfo());
        Mockito.when(plantRepository.save(updatedPlant)).thenReturn(updatedPlant);

        final Plant result = plantService.update(plantId, updatedPlant);

        Assertions.assertThat(result).isEqualTo(updatedPlant);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(botanicalInfoService, Mockito.times(1)).get(updatedPlant.getBotanicalInfo().getId());
        Mockito.verify(plantRepository, Mockito.times(1)).save(updatedPlant);
    }


    @Test
    @DisplayName("Should throw error when updating non-existing plant")
    void shouldThrowResourceNotFoundExceptionWhenUpdatingNonExistingPlant() {
        final Long plantId = 1L;
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(new User());
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> plantService.update(plantId, new Plant()))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(botanicalInfoService, Mockito.never()).get(Mockito.any());
        Mockito.verify(plantRepository, Mockito.never()).save(Mockito.any());
    }


    @Test
    @DisplayName("Should throw error when updating plant not owned by authenticated user")
    void shouldThrowUnauthorizedExceptionWhenUpdatingPlantNotOwnedByAuthenticatedUser() {
        final Long plantId = 1L;
        final User plantOwner = new User();
        plantOwner.setId(2L);
        final Plant existingPlant = new Plant();
        existingPlant.setId(plantId);
        existingPlant.setOwner(plantOwner);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(new User());
        Mockito.when(plantRepository.findById(plantId)).thenReturn(Optional.of(existingPlant));

        Assertions.assertThatThrownBy(() -> plantService.update(plantId, new Plant()))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(plantRepository, Mockito.times(1)).findById(plantId);
        Mockito.verify(botanicalInfoService, Mockito.never()).get(Mockito.any());
        Mockito.verify(plantRepository, Mockito.never()).save(Mockito.any());
    }
}

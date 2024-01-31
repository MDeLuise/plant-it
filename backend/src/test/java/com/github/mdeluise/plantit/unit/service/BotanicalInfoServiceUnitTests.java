package com.github.mdeluise.plantit.unit.service;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoRepository;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantRepository;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for BotanicalInfoService")
class BotanicalInfoServiceUnitTests {
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    @Mock
    private BotanicalInfoRepository botanicalInfoRepository;
    @Mock
    private ImageStorageService imageStorageService;
    @Mock
    private PlantRepository plantRepository;
    @InjectMocks
    private BotanicalInfoService botanicalInfoService;


    @Test
    @DisplayName("Should get botanical info by partial scientific name")
    void shouldGetBotanicalInfoByPartialScientificName() {
        final String partialScientificName = "partialName";
        final int size = 5;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo botanicalInfo1 = new BotanicalInfo();
        botanicalInfo1.setId(1L);
        botanicalInfo1.setUserCreator(authenticatedUser);
        final BotanicalInfo botanicalInfo2 = new BotanicalInfo();
        botanicalInfo2.setId(2L);
        botanicalInfo2.setUserCreator(authenticatedUser);
        final List<BotanicalInfo> botanicalInfoList = Arrays.asList(botanicalInfo1, botanicalInfo2);
        final Set<BotanicalInfo> expectedBotanicalInfoSet = new HashSet<>(botanicalInfoList);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.getByScientificNameOrSynonym(partialScientificName))
               .thenReturn(botanicalInfoList);

        final Set<BotanicalInfo> result = botanicalInfoService.getByPartialScientificName(partialScientificName, size);

        Assertions.assertThat(expectedBotanicalInfoSet).hasSameElementsAs(result);
        Mockito.verify(authenticatedUserService, Mockito.times(2)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).getByScientificNameOrSynonym(partialScientificName);
    }


    @Test
    @DisplayName("Should get all botanical info")
    void shouldGetAllBotanicalInfo() {
        final int size = 5;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo botanicalInfo1 = new BotanicalInfo();
        botanicalInfo1.setId(1L);
        botanicalInfo1.setUserCreator(authenticatedUser);
        final BotanicalInfo botanicalInfo2 = new BotanicalInfo();
        botanicalInfo2.setId(2L);
        botanicalInfo2.setUserCreator(authenticatedUser);
        final BotanicalInfo botanicalInfo3 = new BotanicalInfo();
        botanicalInfo2.setId(3L);
        botanicalInfo2.setCreator(BotanicalInfoCreator.TREFLE);
        final List<BotanicalInfo> botanicalInfoList = Arrays.asList(botanicalInfo1, botanicalInfo2, botanicalInfo3);
        final Set<BotanicalInfo> expectedBotanicalInfoSet = new HashSet<>(botanicalInfoList);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findAll()).thenReturn(botanicalInfoList);

        final Set<BotanicalInfo> result = botanicalInfoService.getAll(size);

        Assertions.assertThat(expectedBotanicalInfoSet).hasSameElementsAs(result);
        Mockito.verify(authenticatedUserService, Mockito.times(3)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findAll();
    }


    @Test
    @DisplayName("Should count plants for a botanical info")
    void shouldCountPlantsForBotanicalInfo() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(botanicalInfoId);
        final Set<Plant> plants = new HashSet<>();
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        plant1.setOwner(authenticatedUser);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        plant2.setOwner(authenticatedUser);
        plants.add(plant1);
        plants.add(plant2);
        botanicalInfo.setPlants(plants);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(botanicalInfo));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        final int result = botanicalInfoService.countPlants(botanicalInfoId);

        Assertions.assertThat(result).isEqualTo(2);
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(authenticatedUserService, Mockito.times(2)).getAuthenticatedUser();
    }


    @Test
    @DisplayName("Should count botanical info")
    void shouldCountBotanicalInfo() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo botanicalInfo1 = new BotanicalInfo();
        botanicalInfo1.setId(1L);
        final BotanicalInfo botanicalInfo2 = new BotanicalInfo();
        botanicalInfo2.setId(2L);
        final BotanicalInfo botanicalInfo3 = new BotanicalInfo();
        botanicalInfo3.setId(3L);
        final Plant plant1 = new Plant();
        plant1.setId(1L);
        plant1.setBotanicalInfo(botanicalInfo1);
        final Plant plant2 = new Plant();
        plant2.setId(2L);
        plant2.setBotanicalInfo(botanicalInfo2);
        final Plant plant3 = new Plant();
        plant3.setId(3L);
        plant3.setBotanicalInfo(botanicalInfo3);
        final List<Plant> plants = Arrays.asList(plant1, plant2, plant3);
        Mockito.when(plantRepository.findAllByOwner(authenticatedUser, Pageable.unpaged()))
               .thenReturn(new PageImpl<>(plants));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        final long result = botanicalInfoService.count();

        Assertions.assertThat(result).isEqualTo(3);
        Mockito.verify(plantRepository, Mockito.times(1)).findAllByOwner(authenticatedUser, Pageable.unpaged());
    }


    @Test
    @DisplayName("Should save a botanical info")
    void shouldSaveBotanicalInfo() {
        final BotanicalInfo botanicalInfoToSave = new BotanicalInfo();
        botanicalInfoToSave.setId(1L);
        botanicalInfoToSave.setCreator(BotanicalInfoCreator.USER);
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.save(botanicalInfoToSave)).thenReturn(botanicalInfoToSave);

        final BotanicalInfo result = botanicalInfoService.save(botanicalInfoToSave);

        Assertions.assertThat(botanicalInfoToSave).isEqualTo(result);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).save(botanicalInfoToSave);
    }


    @Test
    @DisplayName("Should get a botanical info by ID")
    void shouldGetBotanicalInfoById() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(botanicalInfoId);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(botanicalInfo));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        final BotanicalInfo result = botanicalInfoService.get(botanicalInfoId);

        Assertions.assertThat(botanicalInfo).isEqualTo(result);
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
    }


    @Test
    @DisplayName("Should return error when getting non-existing botanical info")
    void shouldThrowResourceNotFoundExceptionWhenGettingNonExistingBotanicalInfo() {
        final Long nonExistingBotanicalInfoId = 99L;

        Mockito.when(botanicalInfoRepository.findById(nonExistingBotanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.get(nonExistingBotanicalInfoId))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(nonExistingBotanicalInfoId);
    }


    @Test
    @DisplayName("Should delete a botanical info by ID")
    void shouldDeleteBotanicalInfoById() {
        final Long botanicalInfoId = 1L;
        final BotanicalInfo botanicalInfoToDelete = new BotanicalInfo();
        botanicalInfoToDelete.setId(botanicalInfoId);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(botanicalInfoToDelete));

        botanicalInfoService.delete(botanicalInfoId);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).deleteById(botanicalInfoId);
    }


    @Test
    @DisplayName("Should return error when deleting another user's botanical info")
    void shouldThrowForbiddenExceptionWhenDeletingAnotherUsersBotanicalInfo() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User ownerUser = new User();
        ownerUser.setId(2L);
        final BotanicalInfo botanicalInfoToDelete = new BotanicalInfo();
        botanicalInfoToDelete.setId(botanicalInfoId);
        botanicalInfoToDelete.setUserCreator(ownerUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(botanicalInfoToDelete));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        Assertions.assertThatThrownBy(() -> botanicalInfoService.delete(botanicalInfoId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.never()).deleteById(botanicalInfoId);
    }


    @Test
    @DisplayName("Should return error when deleting non-existing botanical info")
    void shouldThrowResourceNotFoundExceptionWhenDeletingNonExistingBotanicalInfo() {
        final Long nonExistingBotanicalInfoId = 99L;
        Mockito.when(botanicalInfoRepository.findById(nonExistingBotanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.delete(nonExistingBotanicalInfoId))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(nonExistingBotanicalInfoId);
        Mockito.verify(botanicalInfoRepository, Mockito.times(0)).deleteById(nonExistingBotanicalInfoId);
    }


    @Test
    @DisplayName("Should return error when getting another user's botanical info")
    void shouldThrowResourceNotFoundExceptionWhenGettingAnotherUsersBotanicalInfo() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User ownerUser = new User();
        ownerUser.setId(2L);
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(botanicalInfoId);
        botanicalInfo.setUserCreator(ownerUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(botanicalInfo));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        Assertions.assertThatThrownBy(() -> botanicalInfoService.get(botanicalInfoId))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
    }


    @Test
    @DisplayName("Should return all botanical info up to limit")
    void shouldReturnAllBotanicalInfoUpToLimit() {
        final int size = 5;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final List<BotanicalInfo> botanicalInfoList =
            Arrays.asList(new BotanicalInfo(), new BotanicalInfo(), new BotanicalInfo(), new BotanicalInfo(),
                          new BotanicalInfo()
            );
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findAll()).thenReturn(botanicalInfoList);

        final Set<BotanicalInfo> result = botanicalInfoService.getAll(size);

        Assertions.assertThat(result).hasSameElementsAs(new HashSet<>(botanicalInfoList));
        Mockito.verify(authenticatedUserService, Mockito.atLeast(5)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findAll();
    }


    @Test
    @DisplayName("Should return error on count of botanical info's plants when not existing")
    void shouldReturnErrorOnCountOfBotanicalInfosPlantsWhenNotExisting() {
        final Long nonExistingBotanicalInfoId = 99L;

        Mockito.when(botanicalInfoRepository.findById(nonExistingBotanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.countPlants(nonExistingBotanicalInfoId))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(nonExistingBotanicalInfoId);
    }


    @Test
    @DisplayName("Should set user creator correctly for newer botanical info")
    void shouldSetUserCreatorCorrectlyForNewerBotanicalInfo() {
        final BotanicalInfo botanicalInfoToSave = new BotanicalInfo();
        botanicalInfoToSave.setCreator(BotanicalInfoCreator.USER);
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.save(Mockito.any(BotanicalInfo.class))).thenAnswer(invocation -> {
            final BotanicalInfo savedBotanicalInfo = invocation.getArgument(0);
            Assertions.assertThat(savedBotanicalInfo.getUserCreator()).isEqualTo(authenticatedUser);
            return savedBotanicalInfo;
        });

        final BotanicalInfo result = botanicalInfoService.save(botanicalInfoToSave);

        Assertions.assertThat(result.getUserCreator()).isEqualTo(authenticatedUser);
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).save(Mockito.any(BotanicalInfo.class));
    }



    @Test
    @DisplayName("Should update botanical info")
    void shouldUpdateBotanicalInfo() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final BotanicalInfo existingBotanicalInfo = new BotanicalInfo();
        existingBotanicalInfo.setId(botanicalInfoId);
        existingBotanicalInfo.setUserCreator(authenticatedUser);
        final BotanicalInfo updatedBotanicalInfo = new BotanicalInfo();
        updatedBotanicalInfo.setId(botanicalInfoId);
        updatedBotanicalInfo.setUserCreator(authenticatedUser);
        updatedBotanicalInfo.setScientificName("Updated Scientific Name");
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(existingBotanicalInfo));
        Mockito.when(botanicalInfoRepository.save(updatedBotanicalInfo)).thenReturn(updatedBotanicalInfo);

        final BotanicalInfo result = botanicalInfoService.update(botanicalInfoId, updatedBotanicalInfo);

        Assertions.assertThat(result).isEqualTo(updatedBotanicalInfo);
        Mockito.verify(authenticatedUserService, Mockito.atLeast(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).save(updatedBotanicalInfo);
    }


    @Test
    @DisplayName("Should return error if updating non-existing botanical info")
    void shouldReturnErrorIfUpdatingNonExistingBotanicalInfo() {
        final Long nonExistingBotanicalInfoId = 99L;
        final BotanicalInfo updatedBotanicalInfo = new BotanicalInfo();
        updatedBotanicalInfo.setId(nonExistingBotanicalInfoId);
        updatedBotanicalInfo.setUserCreator(new User());
        Mockito.when(botanicalInfoRepository.findById(nonExistingBotanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(
                      () -> botanicalInfoService.update(nonExistingBotanicalInfoId, updatedBotanicalInfo))
                  .isInstanceOf(ResourceNotFoundException.class);

        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(nonExistingBotanicalInfoId);
        Mockito.verify(botanicalInfoRepository, Mockito.times(0)).save(updatedBotanicalInfo);
    }


    @Test
    @DisplayName("Should return error if updating botanical info of another user")
    void shouldReturnErrorIfUpdatingBotanicalInfoOfAnotherUser() {
        final Long botanicalInfoId = 1L;
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User ownerUser = new User();
        ownerUser.setId(2L);
        final BotanicalInfo existingBotanicalInfo = new BotanicalInfo();
        existingBotanicalInfo.setId(botanicalInfoId);
        existingBotanicalInfo.setUserCreator(ownerUser);
        final BotanicalInfo updatedBotanicalInfo = new BotanicalInfo();
        updatedBotanicalInfo.setId(botanicalInfoId);
        updatedBotanicalInfo.setUserCreator(ownerUser);
        updatedBotanicalInfo.setScientificName("Updated Scientific Name");
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(existingBotanicalInfo));

        Assertions.assertThatThrownBy(() -> botanicalInfoService.update(botanicalInfoId, updatedBotanicalInfo))
                  .isInstanceOf(UnauthorizedException.class);

        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findById(botanicalInfoId);
        Mockito.verify(botanicalInfoRepository, Mockito.times(0)).save(updatedBotanicalInfo);
    }


    @Test
    @DisplayName("Should check botanical info existence")
    void shouldCheckBotanicalInfoExistence() {
        final String species = "species";
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(1L);
        Mockito.when(botanicalInfoRepository.findAllBySpecies(species)).thenReturn(List.of(botanicalInfo));

        final boolean result = botanicalInfoService.existsSpecies(species);

        Assertions.assertThat(result).isTrue();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findAllBySpecies(species);
    }


    @Test
    @DisplayName("Should check botanical info existence false from species if owned by another user")
    void shouldCheckBotanicalInfoExistenceFalseFromSpeciesIfOwnedByAnotherUser() {
        final String species = "species";
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User ownerUser = new User();
        ownerUser.setId(2L);
        final BotanicalInfo existingBotanicalInfo = new BotanicalInfo();
        existingBotanicalInfo.setId(1L);
        existingBotanicalInfo.setUserCreator(ownerUser);
        existingBotanicalInfo.setSpecies("species");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findAllBySpecies(species)).thenReturn(List.of(existingBotanicalInfo));

        final boolean result = botanicalInfoService.existsSpecies(species);

        Assertions.assertThat(result).isFalse();
        Mockito.verify(authenticatedUserService, Mockito.times(1)).getAuthenticatedUser();
        Mockito.verify(botanicalInfoRepository, Mockito.times(1)).findAllBySpecies(species);
    }
}

package com.github.mdeluise.plantit.botanicalinfo.service;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import com.github.mdeluise.plantit.TestEnvironment;
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
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@WithMockUser(username = "user")
@Import(TestEnvironment.class)
class BotanicalInfoServiceTest {
    @Mock
    BotanicalInfoRepository botanicalInfoRepository;
    @Mock
    AuthenticatedUserService authenticatedUserService;
    @Mock
    ImageStorageService imageStorageService;
    @InjectMocks
    BotanicalInfoService botanicalInfoService;


    @Test
    @DisplayName("Partial scientific name search should work")
    void shouldReturnWithPartialScientificNameSearch() {
        final String partialScientificName = "this is the partial scientific name";
        final BotanicalInfo toReturn1 = new BotanicalInfo();
        toReturn1.setId(1L);
        final BotanicalInfo toReturn2 = new BotanicalInfo();
        toReturn2.setId(2L);
        final List<BotanicalInfo> toReturn = List.of(toReturn1, toReturn2);

        Mockito.when(botanicalInfoRepository.getByScientificNameOrSynonym(partialScientificName)).thenReturn(toReturn);

        Assertions.assertThat(botanicalInfoService.getByPartialScientificName(partialScientificName, 2))
                  .as("botanical info set is correct").hasSameElementsAs(toReturn);
    }


    @Test
    @DisplayName("Partial scientific name search with limit should work")
    void shouldReturnWithPartialScientificNameSearchWithLimit() {
        final String partialScientificName = "this is the partial scientific name";
        final BotanicalInfo toReturn1 = new BotanicalInfo();
        toReturn1.setId(1L);
        final BotanicalInfo toReturn2 = new BotanicalInfo();
        toReturn2.setId(2L);
        final List<BotanicalInfo> toReturn = List.of(toReturn1, toReturn2);

        Mockito.when(botanicalInfoRepository.getByScientificNameOrSynonym(partialScientificName)).thenReturn(toReturn);

        Assertions.assertThat(botanicalInfoService.getByPartialScientificName(partialScientificName, 1))
                  .as("botanical info set is correct").hasSameElementsAs(List.of(toReturn1));
    }


    @Test
    @DisplayName("Should return all botanical info")
    void shouldGetAll() {
        final BotanicalInfo toReturn1 = new BotanicalInfo();
        toReturn1.setId(1L);
        final BotanicalInfo toReturn2 = new BotanicalInfo();
        toReturn2.setId(2L);
        final List<BotanicalInfo> toReturn = List.of(toReturn1, toReturn2);

        Mockito.when(botanicalInfoRepository.findAll()).thenReturn(toReturn);

        Assertions.assertThat(botanicalInfoService.getAll(2)).as("botanical info set is correct")
                  .hasSameElementsAs(toReturn);
    }


    @Test
    @DisplayName("Should return all botanical info up to limit")
    void shouldGetAllUpToLimit() {
        final BotanicalInfo toReturn1 = new BotanicalInfo();
        toReturn1.setId(1L);
        final BotanicalInfo toReturn2 = new BotanicalInfo();
        toReturn2.setId(2L);
        final List<BotanicalInfo> toReturn = List.of(toReturn1, toReturn2);

        Mockito.when(botanicalInfoRepository.findAll()).thenReturn(toReturn);

        Assertions.assertThat(botanicalInfoService.getAll(1)).as("botanical info set is correct")
                  .hasSameElementsAs(List.of(toReturn1));
    }


    @Test
    @DisplayName("Should count botanical info's plants")
    void shouldCount() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long botanicalInfoIdToCountPlants = 1;
        final int plantNumber = 3;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(1L);
        final Set<Plant> botanicalInfoPlants = new HashSet<>();
        for (int i = 0; i < plantNumber; i++) {
            Plant plant = new Plant();
            plant.setId((long) i);
            plant.setOwner(authenticatedUser);
            botanicalInfoPlants.add(plant);
        }
        botanicalInfo.setPlants(botanicalInfoPlants);

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoIdToCountPlants)).thenReturn(Optional.of(botanicalInfo));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        Assertions.assertThat(botanicalInfoService.countPlants(botanicalInfoIdToCountPlants)).as("count is correct").isEqualTo(plantNumber);
    }


    @Test
    @DisplayName("Should count only owned botanical info's plants")
    void shouldCountOnlyOwnedPlants() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long botanicalInfoIdToCountPlants = 1;
        final int plantNumber = 3;
        final BotanicalInfo botanicalInfo = new BotanicalInfo();
        botanicalInfo.setId(1L);
        final Set<Plant> botanicalInfoPlants = new HashSet<>();
        for (int i = 0; i < plantNumber; i++) {
            final Plant plant = new Plant();
            plant.setId((long) i);
            plant.setOwner(authenticatedUser);
            botanicalInfoPlants.add(plant);
        }
        final Plant notOwnedPlant = new Plant();
        notOwnedPlant.setOwner(new User());
        botanicalInfoPlants.add(notOwnedPlant);
        botanicalInfo.setPlants(botanicalInfoPlants);

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoIdToCountPlants)).thenReturn(Optional.of(botanicalInfo));
        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);

        Assertions.assertThat(botanicalInfoService.countPlants(botanicalInfoIdToCountPlants)).as("count is correct").isEqualTo(plantNumber);
    }


    @Test
    @DisplayName("Should throw error on count botanical info's plants when not existing")
    void shouldReturnErrorWhenCountPlantsNotExisting() {
        final long botanicalInfoIdToCountPlants = 1;

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoIdToCountPlants)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.countPlants(botanicalInfoIdToCountPlants))
                  .as("Exception is correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should save botanical info")
    void shouldSave() {
        final BotanicalInfo toSave = new BotanicalInfo();
        toSave.setId(1L);
        toSave.setSpecies("species");

        Mockito.when(botanicalInfoRepository.save(toSave)).thenReturn(toSave);

        Assertions.assertThat(botanicalInfoService.save(toSave)).as("botanical info is correct").isEqualTo(toSave);
    }


    @Test
    @DisplayName("Should set creator correctly for newer botanical info")
    void shouldSetCreatorCorrectly() {
        final User owner = new User();
        owner.setId(1L);
        owner.setUsername("user 1");
        final BotanicalInfo toSave = new BotanicalInfo();
        toSave.setId(1L);
        toSave.setSpecies("species");
        toSave.setCreator(BotanicalInfoCreator.USER);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(owner);
        Mockito.when(botanicalInfoRepository.save(toSave)).thenReturn(toSave);

        Assertions.assertThat((botanicalInfoService.save(toSave)).getUserCreator())
                  .as("botanical info owner is correct").isEqualTo(owner);
    }


    @Test
    @DisplayName("Should get botanical info")
    void shouldGet() {
        final long botanicalInfoId = 1;
        final BotanicalInfo toGet = new BotanicalInfo();
        toGet.setId(botanicalInfoId);
        toGet.setSpecies("species");

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toGet));

        Assertions.assertThat(botanicalInfoService.get(botanicalInfoId)).as("botanical info is correct")
                  .isEqualTo(toGet);
    }


    @Test
    @DisplayName("Should return error if get non existing botanical info")
    void shouldReturnErrorWhenGetNonExistingBotanicalInfo() {
        final long botanicalInfoId = 1;

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.get(botanicalInfoId))
                  .as("Exception is correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error if get botanical info of another user")
    void shouldReturnErrorWhenGetBotanicalInfoOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final long botanicalInfoId = 1;
        final BotanicalInfo toGet = new BotanicalInfo();
        toGet.setId(botanicalInfoId);
        toGet.setCreator(BotanicalInfoCreator.USER);
        toGet.setUserCreator(creator);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> botanicalInfoService.get(botanicalInfoId))
                  .as("Exception is correct").isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should delete botanical info")
    void shouldDelete() {
        final long botanicalInfoId = 1;
        final BotanicalInfo toDelete = new BotanicalInfo();
        toDelete.setId(botanicalInfoId);

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toDelete));

        Assertions.assertThatNoException().isThrownBy(() -> botanicalInfoService.delete(botanicalInfoId));
    }


    @Test
    @DisplayName("Should return error if delete non existing botanical info")
    void shouldReturnErrorWhenDeleteNonExisting() {
        final long botanicalInfoId = 1;

        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.delete(botanicalInfoId))
                  .as("Exception is correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error if delete botanical info of another user")
    void shouldReturnErrorWhenDeleteOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final long botanicalInfoId = 1;
        final BotanicalInfo toGet = new BotanicalInfo();
        toGet.setId(botanicalInfoId);
        toGet.setCreator(BotanicalInfoCreator.USER);
        toGet.setUserCreator(creator);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> botanicalInfoService.delete(botanicalInfoId))
                  .as("Exception is correct").isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should update botanical info")
    void shouldUpdate() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final long botanicalInfoId = 1;
        final BotanicalInfo toUpdate = new BotanicalInfo();
        toUpdate.setId(botanicalInfoId);
        toUpdate.setUserCreator(authenticatedUser);
        final BotanicalInfo updated = new BotanicalInfo();
        updated.setSpecies("species");
        updated.setScientificName("this is the name");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toUpdate));
        Mockito.when(botanicalInfoRepository.existsById(botanicalInfoId)).thenReturn(true);
        Mockito.when(botanicalInfoRepository.save(updated)).thenReturn(updated);

        Assertions.assertThat(botanicalInfoService.update(botanicalInfoId, updated)).as("botanical info is correct")
            .isEqualTo(updated);
    }


    @Test
    @DisplayName("Should return error if update non existing botanical info")
    void shouldReturnErrorWhenUpdateNonExistingBotanicalInfo() {
        final long toUpdate = 1;
        final BotanicalInfo updated = new BotanicalInfo();
        updated.setId(toUpdate);
        updated.setSpecies("species");
        updated.setScientificName("this is the name");

        Mockito.when(botanicalInfoRepository.findById(toUpdate)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> botanicalInfoService.update(toUpdate, updated))
                  .as("Exception is correct").isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error if update botanical info of another user")
    void shouldReturnErrorWhenUpdateBotanicalInfoOfAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final long botanicalInfoId = 1;
        final BotanicalInfo toUpdate = new BotanicalInfo();
        toUpdate.setId(botanicalInfoId);
        toUpdate.setCreator(BotanicalInfoCreator.USER);
        toUpdate.setUserCreator(creator);
        final BotanicalInfo updated = new BotanicalInfo();
        updated.setId(botanicalInfoId);
        updated.setSpecies("species");
        updated.setScientificName("this is the name");

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findById(botanicalInfoId)).thenReturn(Optional.of(toUpdate));
        Mockito.when(botanicalInfoRepository.existsById(botanicalInfoId)).thenReturn(true);

        Assertions.assertThatThrownBy(() -> botanicalInfoService.update(botanicalInfoId,toUpdate))
                  .as("Exception is correct").isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should check botanical info existence from species")
    void shouldCheckTrueFromSpecies() {
        final String existingSpecies = "species 1";
        final String notExistingSpecies = "species 2";
        final BotanicalInfo toGet = new BotanicalInfo();
        toGet.setSpecies(existingSpecies);
        toGet.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(new User());
        Mockito.when(botanicalInfoRepository.findAllBySpecies(existingSpecies)).thenReturn(List.of(toGet));
        Mockito.when(botanicalInfoRepository.findAllBySpecies(notExistingSpecies)).thenReturn(List.of());

        SoftAssertions softly = new SoftAssertions();
        softly.assertThat(botanicalInfoService.existsSpecies(existingSpecies)).as("species exists").isTrue();
        softly.assertThat(botanicalInfoService.existsSpecies(existingSpecies)).as("species not exists").isFalse();
    }


    @Test
    @DisplayName("Should check botanical info existence false from species if owned by another user")
    void shouldCheckFalseFromSpeciesIfOwnedByAnotherUser() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User creator = new User();
        creator.setId(2L);
        final String species = "species";
        final BotanicalInfo toGet = new BotanicalInfo();
        toGet.setCreator(BotanicalInfoCreator.USER);
        toGet.setUserCreator(creator);
        toGet.setSpecies(species);
        toGet.setId(1L);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(botanicalInfoRepository.findAllBySpecies(species)).thenReturn(List.of(toGet));

        Assertions.assertThat(botanicalInfoService.existsSpecies(species)).as("species not exists").isFalse();
    }
}

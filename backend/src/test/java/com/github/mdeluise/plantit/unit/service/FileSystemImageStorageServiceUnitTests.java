package com.github.mdeluise.plantit.unit.service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.ImageRepository;
import com.github.mdeluise.plantit.image.ImageUtility;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.image.storage.FileSystemImageStorageService;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantRepository;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.io.CleanupMode;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.multipart.MultipartFile;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for FileSystemImageStorageService")
class FileSystemImageStorageServiceUnitTests {
    @TempDir(cleanup = CleanupMode.ALWAYS)
    private Path tmpDir;
    @Mock
    private ImageRepository imageRepository;
    @Mock
    private PlantImageRepository plantImageRepository;
    @Mock
    private PlantRepository plantRepository;
    @Mock
    private AuthenticatedUserService authenticatedUserService;
    private FileSystemImageStorageService fileSystemImageStorageService;


    @BeforeEach
    public void setup() {
        fileSystemImageStorageService =
            new FileSystemImageStorageService(tmpDir.toString(), imageRepository, plantImageRepository, plantRepository,
                                              10000000, authenticatedUserService
            );
    }


    @Test
    @DisplayName("Should save new plant image")
    void shouldSavePlantImage() {
        final byte[] validImageBytes = {0xa,0x2,0xf,(byte)0xff,(byte)0xff,(byte)0xff};
        final String name = "test-photo.jpg";
        final MultipartFile toSave = new MockMultipartFile(name, name, "image/jpg", validImageBytes);
        final long imageTargetId = 1;
        final Plant imageTarget = new Plant();
        imageTarget.setId(imageTargetId);

        fileSystemImageStorageService.save(toSave, imageTarget, null, "description");

        Assertions.assertThat(tmpDir.toFile().listFiles().length).as("number of file is correct").isEqualTo(1);
        ArgumentCaptor<PlantImage> argument = ArgumentCaptor.forClass(PlantImage.class);
        Mockito.verify(imageRepository).save(argument.capture());
        Assertions.assertThat(argument.getValue().getPath()).startsWith(tmpDir.toString());
    }


    @Test
    @DisplayName("Should save new botanical info image")
    void shouldSaveBotanicalInfoImage() {
        final String name = "test-photo.jpg";
        final MultipartFile toSave = new MockMultipartFile(name, name, "image/jpg", new byte[]{0, 1, 1, 0});
        final long imageTargetId = 1;
        final BotanicalInfo imageTarget = new BotanicalInfo();
        imageTarget.setId(imageTargetId);

        fileSystemImageStorageService.save(toSave, imageTarget, null, "description");

        Assertions.assertThat(tmpDir.toFile().listFiles().length).as("number of file is correct").isEqualTo(1);
        ArgumentCaptor<BotanicalInfoImage> argument = ArgumentCaptor.forClass(BotanicalInfoImage.class);
        Mockito.verify(imageRepository).save(argument.capture());
        Assertions.assertThat(argument.getValue().getPath()).startsWith(tmpDir.toString());
    }


    @Test
    @DisplayName("Should get")
    void shouldGet() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final String imageId = "42-42-42";
        final Plant target = new Plant();
        target.setOwner(authenticatedUser);
        final PlantImage toGet = new PlantImage();
        toGet.setId(imageId);
        toGet.setTarget(target);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThat(fileSystemImageStorageService.get(imageId)).as("image is correct").isEqualTo(toGet);
    }


    @Test
    @DisplayName("Should return error on get non existing")
    void shouldReturnErrorWhenGetNonExisting() {
        final String nonExistingImageId = "42-42-42";

        Mockito.when(imageRepository.findById(nonExistingImageId))
               .thenThrow(new ResourceNotFoundException(nonExistingImageId));

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.get(nonExistingImageId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error on get another user image")
    void shouldReturnErrorWhenGetAnotherUserImage() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final String imageId = "42-42-42";
        final Plant target = new Plant();
        target.setId(1L);
        target.setOwner(owner);
        final PlantImage toGet = new PlantImage();
        toGet.setId(imageId);
        toGet.setTarget(target);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.get(imageId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should get content")
    void shouldGetContent() throws IOException {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final String imageId = "42-42-42";
        final String imageFileName = "foo-bar.jpg";
        final Plant target = new Plant();
        target.setOwner(authenticatedUser);
        final PlantImage toGet = new PlantImage();
        final byte[] content = new byte[]{0, 0, 1, 1, 0};
        toGet.setId(imageId);
        toGet.setPath(tmpDir.resolve(imageFileName).toString());
        toGet.setTarget(target);

        final Path created = Files.createFile(tmpDir.resolve(imageFileName));
        final FileOutputStream writer = new FileOutputStream(created.toFile());
        writer.write(content);
        writer.close();

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThat(fileSystemImageStorageService.getContent(imageId)).as("content is correct")
                  .isEqualTo(content);
    }


    @Test
    @DisplayName("Should return error on get non existing image content")
    void shouldReturnErrorWhenGetNonExistingContent() {
        final String nonExistingImageId = "42-42-42";

        Mockito.when(imageRepository.findById(nonExistingImageId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.getContent(nonExistingImageId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error on get another user image content")
    void shouldReturnErrorWhenGetAnotherUserImageContent() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final String imageId = "42-42-42";
        final Plant target = new Plant();
        target.setId(1L);
        target.setOwner(owner);
        final PlantImage toGet = new PlantImage();
        toGet.setId(imageId);
        toGet.setTarget(target);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.getContent(imageId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should get thumbnail")
    void shouldGetThumbnail() throws IOException {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final String imageId = "42-42-42";
        final String imageFileName = "foo-bar.jpg";
        final Plant target = new Plant();
        target.setOwner(authenticatedUser);
        final PlantImage toGet = new PlantImage();
        final byte[] content = new byte[]{0, 0, 1, 1, 0};
        toGet.setId(imageId);
        toGet.setPath(tmpDir.resolve(imageFileName).toString());
        toGet.setTarget(target);

        final Path created = Files.createFile(tmpDir.resolve(imageFileName));
        final FileOutputStream writer = new FileOutputStream(created.toFile());
        writer.write(content);
        writer.close();

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThat(fileSystemImageStorageService.getThumbnail(imageId)).as("thumbnail is correct")
                  .isEqualTo(ImageUtility.compressImage(created.toFile(), .2f));
    }


    @Test
    @DisplayName("Should return error on get non existing image thumbnail")
    void shouldReturnErrorWhenGetNonExistingThumbnail() {
        final String nonExistingImageId = "42-42-42";

        Mockito.when(imageRepository.findById(nonExistingImageId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.getThumbnail(nonExistingImageId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should return error on get another user image thumbnail")
    void shouldReturnErrorWhenGetAnotherUserImageThumbnail() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final String imageId = "42-42-42";
        final Plant target = new Plant();
        target.setId(1L);
        target.setOwner(owner);
        final PlantImage toGet = new PlantImage();
        toGet.setId(imageId);
        toGet.setTarget(target);

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.getThumbnail(imageId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);
    }


    @Test
    @DisplayName("Should remove all")
    void shouldRemoveAll() throws IOException {
        final String imageId = "42-42-42";
        final String imageFileName = "foo-bar.jpg";
        final PlantImage toGet = new PlantImage();
        final byte[] content = new byte[]{0, 0, 1, 1, 0};
        toGet.setId(imageId);
        toGet.setPath(tmpDir.resolve(imageFileName).toString());

        for (int i = 0; i < 5; i++) {
            final Path created = Files.createFile(tmpDir.resolve(i + imageFileName));
            final FileOutputStream writer = new FileOutputStream(created.toFile());
            writer.write(content);
            writer.close();
        }

        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        fileSystemImageStorageService.removeAll();

        Assertions.assertThat(!tmpDir.toFile().exists()).as("directory is deleted");
        Mockito.verify(imageRepository, Mockito.times(1)).deleteAll();
    }


    @Test
    @DisplayName("Should remove")
    void shouldRemove() throws IOException {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final String imageId = "42-42-42";
        final String imageFileName = "foo-bar.jpg";
        final Plant target = new Plant();
        target.setOwner(authenticatedUser);
        final PlantImage toGet = new PlantImage();
        final byte[] content = new byte[]{0, 0, 1, 1, 0};
        toGet.setId(imageId);
        toGet.setPath(tmpDir.resolve(imageFileName).toString());
        toGet.setTarget(target);

        final Path created = Files.createFile(tmpDir.resolve(imageFileName));
        final FileOutputStream writer = new FileOutputStream(created.toFile());
        writer.write(content);
        writer.close();

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        fileSystemImageStorageService.remove(imageId);

        Assertions.assertThat(tmpDir.toFile().listFiles().length).as("file is deleted").isEqualTo(0);
        Mockito.verify(imageRepository, Mockito.times(1)).deleteById(imageId);
    }


    @Test
    @DisplayName("Should return error when remove another user image")
    void shouldReturnErrorWhenRemoveAnotherUserImage() throws IOException {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final User owner = new User();
        owner.setId(2L);
        final String imageId = "42-42-42";
        final String imageFileName = "foo-bar.jpg";
        final Plant target = new Plant();
        target.setOwner(owner);
        final PlantImage toGet = new PlantImage();
        final byte[] content = new byte[]{0, 0, 1, 1, 0};
        toGet.setId(imageId);
        toGet.setPath(tmpDir.resolve(imageFileName).toString());
        toGet.setTarget(target);

        final Path created = Files.createFile(tmpDir.resolve(imageFileName));
        final FileOutputStream writer = new FileOutputStream(created.toFile());
        writer.write(content);
        writer.close();

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(imageRepository.findById(imageId)).thenReturn(Optional.of(toGet));

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.remove(imageId)).as("exception is correct")
                  .isInstanceOf(UnauthorizedException.class);

        Assertions.assertThat(tmpDir.toFile().listFiles().length).as("file is not deleted").isEqualTo(1);
        Mockito.verify(imageRepository, Mockito.never()).deleteById(imageId);
    }


    @Test
    @DisplayName("Should return error when remove non existing image")
    void shouldReturnErrorWhenRemoveNonExistingImage() {
        final String nonExistingImageId = "42-42-42";

        Mockito.when(imageRepository.findById(nonExistingImageId)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> fileSystemImageStorageService.remove(nonExistingImageId)).as("exception is correct")
                  .isInstanceOf(ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should get all ids")
    void shouldGetAllIds() {
        final Plant target = new Plant();
        target.setId(1L);
        final List<String> wanted = List.of("1", "2", "3");

        Mockito.when(plantImageRepository.findAllIdsPlantByImageTargetOrderBySavedAtDesc(target)).thenReturn(wanted);

        Assertions.assertThat(fileSystemImageStorageService.getAllIds(target)).as("all ids are correct")
                  .hasSameElementsAs(wanted);
    }


    @Test
    @DisplayName("Should count")
    void shouldCount() {
        final User authenticatedUser = new User();
        authenticatedUser.setId(1L);
        final int countWanted = 42;

        Mockito.when(authenticatedUserService.getAuthenticatedUser()).thenReturn(authenticatedUser);
        Mockito.when(plantImageRepository.countByTargetOwner(authenticatedUser)).thenReturn(countWanted);

        Assertions.assertThat(fileSystemImageStorageService.count()).as("count is correct").isEqualTo(countWanted);
    }
}

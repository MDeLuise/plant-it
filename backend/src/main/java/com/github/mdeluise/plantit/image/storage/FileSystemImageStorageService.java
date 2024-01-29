package com.github.mdeluise.plantit.image.storage;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collection;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.exception.UnauthorizedException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.EntityImageImpl;
import com.github.mdeluise.plantit.image.ImageRepository;
import com.github.mdeluise.plantit.image.ImageTarget;
import com.github.mdeluise.plantit.image.ImageUtility;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantAvatarMode;
import com.github.mdeluise.plantit.plant.PlantRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
@SuppressWarnings("ClassDataAbstractionCoupling") // FIXME
public class FileSystemImageStorageService implements ImageStorageService {
    private final String rootLocation;
    private final ImageRepository imageRepository;
    private final PlantImageRepository plantImageRepository;
    private final PlantRepository plantRepository;
    private final int maxOriginImgSize;
    private final AuthenticatedUserService authenticatedUserService;
    private final Logger logger = LoggerFactory.getLogger(FileSystemImageStorageService.class);


    @Autowired
    @SuppressWarnings("ParameterNumber") //FIXME
    public FileSystemImageStorageService(@Value("${upload.location}") String rootLocation,
                                         ImageRepository imageRepository, PlantImageRepository plantImageRepository,
                                         PlantRepository plantRepository,
                                         @Value("${image.max_origin_size}") int maxOriginImgSize,
                                         AuthenticatedUserService authenticatedUserService) {
        this.rootLocation = rootLocation;
        this.imageRepository = imageRepository;
        this.plantImageRepository = plantImageRepository;
        this.plantRepository = plantRepository;
        this.maxOriginImgSize = maxOriginImgSize;
        this.authenticatedUserService = authenticatedUserService;
    }


    @Override
    public EntityImage save(MultipartFile file, ImageTarget linkedEntity, String description) {
        if (file.isEmpty()) {
            logger.error("File is empty");
            throw new StorageException("Failed to save empty file.");
        }
        String fileExtension;
        try {
            fileExtension = file.getContentType().split("/")[1];
        } catch (NullPointerException e) {
            logger.error("Error while extract file extension from file with content type " + file.getContentType());
            throw new StorageException("Could not retrieve file information", e);
        }
        try {
            InputStream fileInputStream = file.getInputStream();
            if (file.getBytes().length > maxOriginImgSize) { // default to 10 MB
                logger.info(String.format("File size (%s byte) exceed %s MB, compressing...",
                                          file.getBytes().length, maxOriginImgSize));
                fileInputStream = new ByteArrayInputStream(ImageUtility.compressImage(file.getResource().getFile()));
            }
            try {
                EntityImageImpl entityImage;
                if (linkedEntity instanceof BotanicalInfo b) {
                    entityImage = new BotanicalInfoImage();
                    ((BotanicalInfoImage) entityImage).setTarget(b);
                } else if (linkedEntity instanceof Plant p) {
                    entityImage = new PlantImage();
                    ((PlantImage) entityImage).setTarget(p);
                } else {
                    throw new UnsupportedOperationException("Could not find suitable class for linkedEntity");
                }
                final String fileName = String.format("%s/%s.%s", rootLocation, entityImage.getId(), fileExtension);
                final Path pathToFile = Path.of(fileName);
                createDestinationDirectoryIfNotExist(Path.of(rootLocation));
                Files.copy(fileInputStream, pathToFile);
                entityImage.setPath(String.format("%s/%s.%s", rootLocation, entityImage.getId(), fileExtension));
                entityImage.setDescription(description);
                return imageRepository.save(entityImage);
            } catch (IOException e) {
                logger.error("Error while saving file", e);
                throw new StorageException("Failed to save file.", e);
            }
        } catch (IOException e) {
            logger.error("Error while reading file", e);
            throw new StorageException("Could not read provided file.", e);
        }
    }


    private void createDestinationDirectoryIfNotExist(Path destinationPath) throws IOException {
        if (Files.exists(destinationPath)) {
            return;
        }
        logger.debug("Directory {} does not exist, creating it...", destinationPath);
        Files.createDirectories(destinationPath);
    }


    @Override
    public EntityImage save(String url, ImageTarget linkedEntity) throws MalformedURLException {
        if (!(linkedEntity instanceof BotanicalInfo)) {
            throw new UnsupportedOperationException("URL images can be linked only to Botanical Info entities");
        }
        try {
            new URL(url).toURI();
        } catch (URISyntaxException e) {
            logger.error("Provided URL not correct", e);
            throw new MalformedURLException(e.getMessage());
        }
        final BotanicalInfoImage entityImage = new BotanicalInfoImage();
        entityImage.setTarget((BotanicalInfo) linkedEntity);
        entityImage.setUrl(url);
        return imageRepository.save(entityImage);
    }


    @Override
    public EntityImage clone(String id, ImageTarget linkedEntity) {
        final EntityImage toClone = get(id);
        EntityImageImpl entityImage;
        if (linkedEntity instanceof BotanicalInfo b) {
            entityImage = new BotanicalInfoImage();
            ((BotanicalInfoImage) entityImage).setTarget(b);
        } else if (linkedEntity instanceof Plant p) {
            entityImage = new PlantImage();
            ((PlantImage) entityImage).setTarget(p);
        } else {
            throw new UnsupportedOperationException("Could not find suitable class for linkedEntity");
        }
        entityImage.setUrl(toClone.getUrl());
        if (toClone.getPath() != null) {
            final String resultPath = toClone.getPath().replace(toClone.getId(), entityImage.getId());
            try {
                Files.copy(Path.of(toClone.getPath()), Path.of(resultPath));
            } catch (IOException e) {
                logger.error("Error while saving file", e);
                throw new StorageException("Failed to save file.", e);
            }
        }
        return imageRepository.save(entityImage);
    }


    @Cacheable(value = "image", key = "{#id}")
    @Override
    public EntityImage get(String id) {
        final EntityImageImpl result =
            imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result instanceof PlantImage p &&
                p.getTarget().getOwner() != authenticatedUserService.getAuthenticatedUser()) {
            logger.warn("User not authorized to operate on image " + id);
            throw new UnauthorizedException();
        } else if (result instanceof BotanicalInfoImage b &&
                       !b.getTarget().isAccessibleToUser(authenticatedUserService.getAuthenticatedUser())) {
            logger.warn("User not authorized to operate on image " + id);
            throw new UnauthorizedException();
        }
        return result;
    }


    @Cacheable(value = "image-content", key = "{#id}")
    @Override
    public byte[] getContent(String id) {
        final EntityImage getContentFrom = get(id);
        if (getContentFrom.getPath() == null) {
            logger.warn("Trying to read an image that has no content but only URL");
            throw new UnsupportedOperationException(String.format("Image with id %s has no content (only URL)", id));
        }
        try {
            final File entityImageFile = new File(getContentFrom.getPath());
            if (!entityImageFile.exists() || !entityImageFile.canRead()) {
                logger.error("Error while reading image " + id + " permission deny");
                throw new StorageFileNotFoundException("Could not read image with id: " + id);
            }
            return Files.readAllBytes(entityImageFile.toPath());
        } catch (IOException e) {
            logger.error("Error while reading image " + id, e);
            throw new StorageFileNotFoundException("Could not read image with id: " + id, e);
        }
    }


    @Cacheable(value = "thumbnail", key = "{#id}")
    @Override
    public byte[] getThumbnail(String id) {
        final EntityImage getContentFrom = get(id);
        if (getContentFrom.getPath() == null) {
            logger.warn("Trying to read an image that has no content but only URL");
            throw new UnsupportedOperationException(String.format("Image with id %s has no content (only URL)", id));
        }
        try {
            final File entityImageFile = new File(getContentFrom.getPath());
            if (!entityImageFile.exists() || !entityImageFile.canRead()) {
                logger.error("Error while reading image " + id + " permission deny");
                throw new StorageFileNotFoundException("Could not read image with id: " + id);
            }
            return ImageUtility.compressImage(entityImageFile, .2f);
        } catch (IOException e) {
            logger.error("Error while reading image " + id, e);
            throw new StorageFileNotFoundException("Could not read image with id: " + id, e);
        }
    }


    @CacheEvict(cacheNames = {"image", "thumbnail", "image-content"}, allEntries = true)
    @Override
    public void removeAll() {
        FileSystemUtils.deleteRecursively(Path.of(rootLocation).toFile());
        imageRepository.deleteAll();
    }


    @Caching(
        evict = {
            @CacheEvict(cacheNames = {"image", "thumbnail", "image-content"}, key = "{#id}"),
            @CacheEvict(
                value = "plants",
                allEntries = true,
                beforeInvocation = true,
                condition = "@plantImageRepository.findById(#id).present and " +
                                "@plantImageRepository.findById(#id).get().avatarOf != null"
            )
        }
    )
    @Override
    // FIXME plantImageRepository and PlantImage should not be used,
    // maybe DeletePlantImageEntityAndFileCollaborator collaborator?
    public void remove(String id) {
        final EntityImage entityToDelete =
            imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (entityToDelete instanceof PlantImage p && p.getAvatarOf() != null) {
            final Plant toUpdate = p.getAvatarOf();
            toUpdate.setAvatarImage(null);
            toUpdate.setAvatarMode(PlantAvatarMode.NONE);
            plantRepository.save(toUpdate);
            p.setAvatarOf(null);
            plantImageRepository.save(p);
        }
        final String entityImagePath = get(id).getPath();
        if (entityImagePath != null) {
            final File toRemove = new File(entityImagePath);
            if (!toRemove.exists() || !toRemove.canRead()) {
                logger.error("Error while reading image " + id + " permission deny");
                throw new StorageFileNotFoundException("Could not read image with id: " + id);
            }
            if (!toRemove.delete()) {
                logger.error("Error while removing image " + id);
                throw new StorageException("Could not remove image with id " + id);
            }
        }
        imageRepository.deleteById(id);
    }


    @Override
    public void init() {
        try {
            Files.createDirectories(Path.of(rootLocation));
        } catch (IOException e) {
            throw new StorageException("Could not initialize storage", e);
        }
    }


    @Override
    public Collection<String> getAllIds(ImageTarget linkedEntity) {
        return plantImageRepository.findAllIdsPlantByImageTargetOrderBySavedAtDesc((Plant) linkedEntity);
    }


    @Override
    public int count() {
        return plantImageRepository.countByTargetOwner(authenticatedUserService.getAuthenticatedUser());
    }
}

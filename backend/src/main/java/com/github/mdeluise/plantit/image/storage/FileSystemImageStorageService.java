package com.github.mdeluise.plantit.image.storage;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.EntityImageImpl;
import com.github.mdeluise.plantit.image.ImageRepository;
import com.github.mdeluise.plantit.image.ImageTarget;
import com.github.mdeluise.plantit.image.ImageUtility;
import com.github.mdeluise.plantit.image.PlantImage;
import com.github.mdeluise.plantit.image.PlantImageRepository;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collection;

@Service
@SuppressWarnings("ClassDataAbstractionCoupling") // FIXME
public class FileSystemImageStorageService implements ImageStorageService {
    private final String rootLocation;
    private final ImageRepository imageRepository;
    private final PlantImageRepository plantImageRepository;
    private final int maxOriginImgSize;
    private final AuthenticatedUserService authenticatedUserService;


    @Autowired
    public FileSystemImageStorageService(@Value("${upload.location}") String rootLocation,
                                         ImageRepository imageRepository, PlantImageRepository plantImageRepository,
                                         @Value("${image.max_origin_size}") int maxOriginImgSize,
                                         AuthenticatedUserService authenticatedUserService) {
        this.rootLocation = rootLocation;
        this.imageRepository = imageRepository;
        this.plantImageRepository = plantImageRepository;
        this.maxOriginImgSize = maxOriginImgSize;
        this.authenticatedUserService = authenticatedUserService;
    }


    @Override
    public EntityImage save(MultipartFile file, ImageTarget linkedEntity) {
        if (file.isEmpty()) {
            throw new StorageException("Failed to save empty file.");
        }
        String fileExtension;
        try {
            fileExtension = file.getContentType().split("/")[1];
        } catch (NullPointerException e) {
            throw new StorageException("Could not retrieve file information", e);
        }
        try {
            InputStream fileInputStream = file.getInputStream();
            if (file.getBytes().length > maxOriginImgSize) { // default to 10 MB
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
                Files.copy(fileInputStream, pathToFile);
                entityImage.setPath(String.format("%s/%s.%s", rootLocation, entityImage.getId(), fileExtension));
                return imageRepository.save(entityImage);
            } catch (IOException e) {
                throw new StorageException("Failed to save file.", e);
            }
        } catch (IOException e) {
            throw new StorageException("Could not read provided file.", e);
        }
    }


    @Cacheable(
        value = "image", key = "{#id}"
    )
    @Override
    public EntityImage get(String id) {
        return imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    @Override
    public byte[] getContent(String id) {
        try {
            final File entityImageFile = new File(get(id).getPath());
            if (!entityImageFile.exists() || !entityImageFile.canRead()) {
                throw new StorageFileNotFoundException("Could not read image with id: " + id);
            }
            return Files.readAllBytes(entityImageFile.toPath());
        } catch (IOException e) {
            throw new StorageFileNotFoundException("Could not read image with id: " + id, e);
        }
    }


    @Override
    public void removeAll() {
        FileSystemUtils.deleteRecursively(Path.of(rootLocation).toFile());
        imageRepository.deleteAll();
    }


    @Override
    public void remove(String id) {
        final String entityImagePath = get(id).getPath();
        final File toRemove = new File(entityImagePath);
        if (!toRemove.exists() || !toRemove.canRead()) {
            throw new StorageFileNotFoundException("Could not read image with id: " + id);
        }
        if (!toRemove.delete()) {
            throw new StorageException("Could not remove image with id " + id);
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
        return plantImageRepository.findAllIdsPlantByImageTarget((Plant) linkedEntity);
    }


    @Override
    public int count() {
        return plantImageRepository.countByTargetOwner(authenticatedUserService.getAuthenticatedUser());
    }
}

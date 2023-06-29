package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.tracked.TrackedEntityService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;

@Service
public class ImageService {
    private final ImageRepository imageRepository;
    private final TrackedEntityImageRepository trackedEntityImageRepository;
    private final TrackedEntityService trackedEntityService;
    private final Logger logger = LoggerFactory.getLogger(ImageService.class);


    @Autowired
    public ImageService(ImageRepository imageRepository, TrackedEntityImageRepository trackedEntityImageRepository,
                        TrackedEntityService trackedEntityService) {
        this.imageRepository = imageRepository;
        this.trackedEntityImageRepository = trackedEntityImageRepository;
        this.trackedEntityService = trackedEntityService;
    }


    public AbstractImage saveBotanicalInfoImage(MultipartFile file) throws IOException {
        LocalBotanicalInfoImage localBotanicalInfoImage = new LocalBotanicalInfoImage();
        byte[] content = getBytes(file);
        localBotanicalInfoImage.setContent(content);
        return imageRepository.save(localBotanicalInfoImage);
    }


    @Cacheable(
        value = "image",
        key = "{#id}"
    )
    public AbstractImage get(@PathVariable("id") Long id) {
        return imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public void delete(Long id) {
        if (!imageRepository.existsById(id)) {
            throw new ResourceNotFoundException(id);
        }
        imageRepository.deleteById(id);
    }


    @Transactional
    public AbstractImage saveEntityImage(MultipartFile file, Long entityId) throws IOException {
        TrackedEntityImage trackedEntityImage = new TrackedEntityImage();
        trackedEntityImage.setAbstractTrackedEntity(trackedEntityService.get(entityId));
        byte[] content = getBytes(file);
        trackedEntityImage.setContent(content);
        return imageRepository.save(trackedEntityImage);
    }


    private byte[] getBytes(MultipartFile file) throws IOException {
        byte[] content = file.getBytes();
        final int originalSize = content.length;
        logger.debug("Image {} has size: {} byte", file.getOriginalFilename(), originalSize);
        if (content.length >= 2000000) { // 2MB
            File convFile = new File(System.getProperty("java.io.tmpdir") + "/" + file.getName());
            file.transferTo(convFile);
            content = ImageUtility.compressImage(20000000, convFile);
            logger.debug("Image {} compressed has size: {} byte ({}% compressed)",
                         file.getOriginalFilename(), content.length, content.length / originalSize * 100);
        }
        return content;
    }


    public Collection<Long> getAllIds(Long trackedEntityId) {
        final List<TrackedEntityImageRepository.TrackedEntityImageIdView> resultIds =
            trackedEntityImageRepository.findAllByAbstractTrackedEntity(trackedEntityService.get(trackedEntityId));
        return resultIds.stream().map(TrackedEntityImageRepository.TrackedEntityImageIdView::getId).toList();
    }
}

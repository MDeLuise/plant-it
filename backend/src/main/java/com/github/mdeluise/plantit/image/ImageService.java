package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;

@Service
public class ImageService {
    private final ImageRepository imageRepository;
    private final Logger logger = LoggerFactory.getLogger(ImageService.class);


    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }


    public AbstractImage save(MultipartFile file) throws IOException {
        LocalBotanicalInfoImage localBotanicalInfoImage = new LocalBotanicalInfoImage();
        byte[] content = file.getBytes();
        final int originalSize = content.length;
        logger.debug("Image {} has size: {} byte", file.getOriginalFilename(), originalSize);
        if (content.length > 50000) { // 50kB
            File convFile = new File(System.getProperty("java.io.tmpdir") + "/" + file.getName());
            file.transferTo(convFile);
            content = ImageUtility.compressImage(20000000, convFile);
            logger.debug("Image {} compressed has size: {} byte ({}% compressed)",
                         file.getOriginalFilename(), content.length, content.length / originalSize * 100);
        }
        localBotanicalInfoImage.setContent(content);
        return imageRepository.save(localBotanicalInfoImage);
    }


    public AbstractImage save(AbstractImage abstractImage) {
        return imageRepository.save(abstractImage);
    }


    public AbstractImage get(@PathVariable("id") Long id) {
        return imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }
}

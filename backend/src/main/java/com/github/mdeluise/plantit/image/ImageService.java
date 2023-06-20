package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class ImageService {
    private final ImageRepository imageRepository;


    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }


    public AbstractImage save(MultipartFile file) throws IOException {
        LocalBotanicalInfoImage localBotanicalInfoImage = new LocalBotanicalInfoImage();
        localBotanicalInfoImage.setContent(ImageUtility.compressImage(file.getBytes()));
        return imageRepository.save(localBotanicalInfoImage);
    }


    public AbstractImage save(AbstractImage abstractImage) {
        return imageRepository.save(abstractImage);
    }


    public AbstractImage get(@PathVariable("id") Long id) {
        final AbstractImage result = imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (result instanceof LocalBotanicalInfoImage l) {
            l.setContent(ImageUtility.decompressImage(l.getContent()));
        }
        return result;
    }
}

package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

@Service
public class ImageService {
    private final ImageRepository imageRepository;


    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }


    public AbstractImage getInfo(Long id) {
        return imageRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    @Cacheable(value = "images", key = "#id")
    public byte[] get(Long id) throws IOException {
        final AbstractImage imageInfo = getInfo(id);
        InputStream in = new FileInputStream(ResourceUtils.getFile("classpath:images/" + imageInfo.getName()));
        return IOUtils.toByteArray(in);
    }
}

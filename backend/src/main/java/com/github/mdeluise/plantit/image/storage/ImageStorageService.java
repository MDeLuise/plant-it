package com.github.mdeluise.plantit.image.storage;

import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.ImageTarget;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collection;

public interface ImageStorageService {
    void init();

    EntityImage save(MultipartFile file, ImageTarget linkedEntity);

    EntityImage get(String id);

    byte[] getContent(String id);

    void remove(String id);

    void removeAll();

    Collection<String> getAllIds(ImageTarget linkedEntity);

    int count();
}

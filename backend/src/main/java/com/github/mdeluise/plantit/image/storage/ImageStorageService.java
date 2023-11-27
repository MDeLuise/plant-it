package com.github.mdeluise.plantit.image.storage;

import java.net.MalformedURLException;
import java.util.Collection;

import com.github.mdeluise.plantit.image.EntityImage;
import com.github.mdeluise.plantit.image.ImageTarget;
import org.springframework.web.multipart.MultipartFile;

public interface ImageStorageService {
    void init();

    EntityImage save(MultipartFile file, ImageTarget linkedEntity, String description);

    EntityImage save(String url, ImageTarget linkedEntity) throws MalformedURLException;

    EntityImage clone(String id, ImageTarget linkedEntity);

    EntityImage get(String id);

    byte[] getContent(String id);

    void remove(String id);

    void removeAll();

    Collection<String> getAllIds(ImageTarget linkedEntity);

    int count();

    byte[] getThumbnail(String id);
}

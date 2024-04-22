package com.github.mdeluise.plantit;

import com.github.mdeluise.plantit.image.EntityImageImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/*
 * FIXME
 * This class is needed due to upgrade to 0.5.0 version of the project.
 * In 0.5.0 version a new field called "contentType" is added.
 * If no action is done, all uploaded photos would not be displayable.
 *
 * This class can be removed after upgrade to 0.5.0 version of the project.
 *
 */
public class MigratorTo050 {
    private static final Logger LOGGER = LoggerFactory.getLogger(MigratorTo050.class);

    public static void fillMissingImageType(EntityImageImpl toFill) {
        LOGGER.debug("Adding missing content type to image {} ..", toFill.getId());
        toFill.setUrl(null);
        final String contentType = getContentType(toFill.getPath());
        toFill.setContentType(contentType);
    }


    private static String getContentType(String fileName) {
        final String extension = getFileExtension(fileName);
        return switch (extension.toLowerCase()) {
            case "jpg", "jpeg" -> "image/jpeg";
            case "png" -> "image/png";
            case "gif" -> "image/gif";
            default -> "application/octet-stream";
        };
    }


    private static String getFileExtension(String fileName) {
        final int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex != -1 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1);
        }
        return "";
    }
}

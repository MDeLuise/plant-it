package com.github.mdeluise.plantit.image;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;

public class ImageUtility {
    public static byte[] compressImage(File data) throws IOException {
        return compressImage(data, 0.8f);
    }


    public static byte[] compressImage(File data, float quality) throws IOException {
        final String fileExtension = getFileExtension(data);
        final String filePath =
            String.format("%s/%s_compressed.%s", System.getProperty("java.io.tmpdir"), data.getName(), fileExtension);
        final File compressedImageFile = new File(filePath);
        final OutputStream os = new FileOutputStream(compressedImageFile);

        final Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName(fileExtension);
        final ImageWriter writer = writers.next();

        final ImageOutputStream ios = ImageIO.createImageOutputStream(os);
        writer.setOutput(ios);

        final ImageWriteParam param = writer.getDefaultWriteParam();

        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
        param.setCompressionQuality(quality);

        final BufferedImage image = ImageIO.read(data);
        writer.write(null, new IIOImage(image, null, null), param);

        os.close();
        ios.close();
        writer.dispose();

        final FileInputStream fl = new FileInputStream(compressedImageFile);
        byte[] arr = new byte[(int) compressedImageFile.length()];
        fl.read(arr);
        fl.close();
        return arr;
    }

    public static String getFileExtension(File file) {
        final String fileName = file.getName();
        final int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex != -1 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1);
        } else {
            throw new UnsupportedOperationException(String.format("File %s does not have an extension", file.getName()));
        }
    }
}

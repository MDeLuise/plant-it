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
        File compressedImageFile =
            new File(System.getProperty("java.io.tmpdir") + "/" + data.getName() + "_compressed.jpg");
        OutputStream os = new FileOutputStream(compressedImageFile);

        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
        ImageWriter writer = writers.next();

        ImageOutputStream ios = ImageIO.createImageOutputStream(os);
        writer.setOutput(ios);

        ImageWriteParam param = writer.getDefaultWriteParam();

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
}

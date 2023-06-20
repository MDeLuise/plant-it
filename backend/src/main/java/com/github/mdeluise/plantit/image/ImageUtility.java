package com.github.mdeluise.plantit.image;

public class ImageUtility {
    public static byte[] compressImage(byte[] data) {

//        Deflater deflater = new Deflater();
//        deflater.setLevel(Deflater.BEST_COMPRESSION);
//        deflater.setInput(data);
//        deflater.finish();
//
//        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
//        byte[] tmp = new byte[4 * 1024];
//        while (!deflater.finished()) {
//            int size = deflater.deflate(tmp);
//            outputStream.write(tmp, 0, size);
//        }
//        try {
//            outputStream.close();
//        } catch (Exception e) {
//        }
//        return outputStream.toByteArray();
        return data;
    }


    public static byte[] decompressImage(byte[] data) {
//        Inflater inflater = new Inflater();
//        inflater.setInput(data);
//        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
//        byte[] tmp = new byte[4 * 1024];
//        try {
//            while (!inflater.finished()) {
//                int count = inflater.inflate(tmp);
//                outputStream.write(tmp, 0, count);
//            }
//            outputStream.close();
//        } catch (Exception exception) {
//        }
//        return outputStream.toByteArray();
        return data;
    }
}

package com.github.mdeluise.plantit.proxy;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import io.swagger.v3.oas.annotations.Hidden;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/proxy")
@Tag(name = "Image proxy", description = "Proxy for displaying images")
@Hidden
public class ImageProxyController {

    @GetMapping
    public void proxyImage(@RequestParam String url, HttpServletResponse response)
        throws IOException, URISyntaxException {
        final URL imageUrl = (new URI(url)).toURL();
        final HttpURLConnection connection = (HttpURLConnection) imageUrl.openConnection();
        connection.setRequestMethod("GET");

        final String contentType = connection.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendError(HttpStatus.BAD_REQUEST.value(), "The provided URL does not point to a valid image.");
            return;
        }

        response.setContentType(contentType);
        try (InputStream inputStream = connection.getInputStream()) {
            final byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                response.getOutputStream().write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            response.sendError(HttpStatus.INTERNAL_SERVER_ERROR.value(), "Failed to proxy the image.");
        }
    }
}

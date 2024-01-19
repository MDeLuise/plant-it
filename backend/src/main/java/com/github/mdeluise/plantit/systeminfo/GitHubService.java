package com.github.mdeluise.plantit.systeminfo;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class GitHubService {
    private final String gitHubApiUrl = "https://api.github.com/repos/MDeLuise/plant-it/releases/latest";
    private final HttpClient httpClient;
    private final Logger logger = LoggerFactory.getLogger(GitHubService.class);


    @Autowired
    public GitHubService(HttpClient httpClient) {
        this.httpClient = httpClient;
    }


    @Cacheable(value = "latest-version")
    public GitHubReleaseInfo getLatestVersion() throws IOException, InterruptedException {
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(gitHubApiUrl)).build();

        HttpResponse<String> response;
        try {
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            logger.error("Error while fetching latest version from GitHub", e);
            throw e;
        }

        if (response.statusCode() == 200) {
            final ObjectMapper objectMapper = new ObjectMapper();
            final Map<String, Object> resultMap = objectMapper.readValue(response.body(), Map.class);
            final GitHubReleaseInfo result = new GitHubReleaseInfo();
            result.setBody(resultMap.get("body").toString());
            result.setTagName(resultMap.get("tag_name").toString());
            return result;
        } else {
            logger.error("Fetch latest version from GitHub return error code {} ({})", response.statusCode(),
                         response.body()
            );
            return new GitHubReleaseInfo();
        }
    }
}

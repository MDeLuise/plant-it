package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.exception.InfoExtractionException;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
public class TrefleRequestMaker {
    private final String token;
    private final String baseEndpoint = "https://trefle.io/api/v1";
    private final Logger logger = LoggerFactory.getLogger(TrefleRequestMaker.class);


    @Autowired
    public TrefleRequestMaker(@Value("${trefle.key}") String token) {
        this.token = token;
    }


    public Optional<BotanicalInfo> fetchInfo(String plantScientificName) throws InfoExtractionException {
        final Page<BotanicalInfo> result = fetchInfoFromPartial(plantScientificName, Pageable.ofSize(1));
        if (result.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(result.getContent().get(0));
    }


    public Page<BotanicalInfo> fetchInfoFromPartial(String partialPlantScientificName, Pageable pageable) throws InfoExtractionException {
        logger.debug("Fetching info for \"{}\" from Trefle", partialPlantScientificName);
        final String encodedPartialName = URLEncoder.encode(partialPlantScientificName, StandardCharsets.UTF_8);
        final String url = String.format("%s/species/search?q=%s&limit=%s&page=%s&token=%s",
                                         baseEndpoint, encodedPartialName, pageable.getPageSize(),
                                         pageable.getPageNumber() + 1, token);
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                                         .uri(URI.create(url))
                                         .GET()
                                         .build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();
        List<BotanicalInfo> botanicalInfos = new ArrayList<>();
        responseJson.get("data").getAsJsonArray().forEach(plantResult -> {
            BotanicalInfo botanicalInfo = new BotanicalInfo();
            try {
                fillTrefleInfo(plantResult, botanicalInfo);
                botanicalInfos.add(botanicalInfo);
            } catch (UnsupportedOperationException ignore) {
            }
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillTrefleInfo(JsonElement plantResult, BotanicalInfo botanicalInfo) {
        botanicalInfo.setSpecies(plantResult.getAsJsonObject().get("scientific_name").getAsString());
        botanicalInfo.setScientificName(plantResult.getAsJsonObject().get("scientific_name").getAsString());
        botanicalInfo.setFamily(plantResult.getAsJsonObject().get("family").getAsString());
        botanicalInfo.setGenus(plantResult.getAsJsonObject().get("genus").getAsString());
        final JsonElement imageElement = plantResult.getAsJsonObject().get("image_url");
        if (!imageElement.isJsonNull() && !imageElement.getAsString().equals("null")) {
            fillImage(botanicalInfo, plantResult.getAsJsonObject().get("image_url").getAsString());
        }
    }


    public Page<BotanicalInfo> fetchAll(Pageable pageable) {
        logger.debug("Fetching all info from Trefle");
        final String url = String.format("%s/species/search?limit=%s&page=%s&token=%s&q=*",
                                         baseEndpoint, pageable.getPageSize(), pageable.getPageNumber() + 1, token);
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                                         .uri(URI.create(url))
                                         .GET()
                                         .build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();
        List<BotanicalInfo> botanicalInfos = new ArrayList<>();
        responseJson.get("data").getAsJsonArray().forEach(plantResult -> {
            BotanicalInfo botanicalInfo = new BotanicalInfo();
            fillTrefleInfo(plantResult, botanicalInfo);
            botanicalInfos.add(botanicalInfo);
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillImage(BotanicalInfo botanicalInfo, String imageUrl) throws InfoExtractionException {
        final BotanicalInfoImage abstractEntityImage = new BotanicalInfoImage();
        abstractEntityImage.setUrl(imageUrl);
        botanicalInfo.setImage(abstractEntityImage);
    }

}

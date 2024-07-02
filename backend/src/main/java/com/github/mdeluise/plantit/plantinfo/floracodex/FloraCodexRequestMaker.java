package com.github.mdeluise.plantit.plantinfo.floracodex;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
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

@SuppressWarnings("ClassDataAbstractionCoupling")
@Component
public class FloraCodexRequestMaker {
    private final String token;
    private final String baseEndpoint;
    private final Logger logger = LoggerFactory.getLogger(FloraCodexRequestMaker.class);


    @Autowired
    public FloraCodexRequestMaker(@Value("${floracodex.url}") String domain,
                                  @Value("${floracodex.key}") String token) {
        this.baseEndpoint = domain + "/v1";
        this.token = token;
    }


    public Page<BotanicalInfo> fetchInfoFromPartial(String partialPlantScientificName, Pageable pageable)
        throws InfoExtractionException {
        logger.debug("Fetching info for \"{}\" from FloraCodex", partialPlantScientificName);
        final String encodedPartialName = URLEncoder.encode(partialPlantScientificName, StandardCharsets.UTF_8);
        final String url =
            String.format("%s/species/search?q=%s&limit=%s&key=%s", baseEndpoint, encodedPartialName,
                          pageable.getPageSize(), token
            );
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();
        final List<BotanicalInfo> botanicalInfos = new ArrayList<>();
        responseJson.get("data").getAsJsonArray().forEach(plantResult -> {
            if (plantResult.getAsJsonObject().get("rank").getAsString().equals("SPECIES")) {
                final BotanicalInfo botanicalInfo = new BotanicalInfo();
                botanicalInfo.setCreator(BotanicalInfoCreator.FLORA_CODEX);
                try {
                    fillFloraCodexInfo(plantResult, botanicalInfo);
                    botanicalInfos.add(botanicalInfo);
                } catch (UnsupportedOperationException e) {
                    logger.error("Error while retrieving info about species", e);
                }
            }
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillFloraCodexInfo(JsonElement plantResult, BotanicalInfo botanicalInfo) {
        final JsonObject plantJson = plantResult.getAsJsonObject();
        botanicalInfo.setExternalId(plantJson.get("id").getAsString());
        botanicalInfo.setSpecies(plantJson.get("scientific_name").getAsString());
        botanicalInfo.setFamily(plantJson.get("family").getAsString());
        botanicalInfo.setGenus(plantJson.get("genus").getAsString());
        if (!isJsonValueNull(plantJson, "image_url")) {
            fillImage(botanicalInfo, plantJson.get("image_url").getAsString());
        }
    }



    private boolean isJsonValueNull(JsonObject jsonObject, String key) {
        if (jsonObject.get(key) == null || jsonObject.get(key).isJsonNull()) {
            return true;
        }
        try {
            return jsonObject.get(key).getAsString().equals("null");
        } catch (UnsupportedOperationException ignored) {
            return false;
        }
    }


    public Page<BotanicalInfo> fetchAll(Pageable pageable) {
        logger.debug("Fetching all info from FloraCodex");
        final String url =
            String.format("%s/species/search?limit=%s&key=%s", baseEndpoint, pageable.getPageSize(),
                          token
            );
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();
        List<BotanicalInfo> botanicalInfos = new ArrayList<>();
        responseJson.get("data").getAsJsonArray().forEach(plantResult -> {
            if (plantResult.getAsJsonObject().get("rank").getAsString().equals("SPECIES")) {
                BotanicalInfo botanicalInfo = new BotanicalInfo();
                botanicalInfo.setCreator(BotanicalInfoCreator.FLORA_CODEX);
                fillFloraCodexInfo(plantResult, botanicalInfo);
                botanicalInfos.add(botanicalInfo);
            }
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillImage(BotanicalInfo botanicalInfo, String imageUrl) throws InfoExtractionException {
        final BotanicalInfoImage abstractEntityImage = new BotanicalInfoImage();
        abstractEntityImage.setUrl(imageUrl);
        abstractEntityImage.setId(null);
        botanicalInfo.setImage(abstractEntityImage);
    }
}

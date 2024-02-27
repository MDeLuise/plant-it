package com.github.mdeluise.plantit.plantinfo.trafle;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoCreator;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfo;
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

@Component
public class TrefleRequestMaker {
    private final String token;
    private final String domain = "https://trefle.io";
    private final String baseEndpoint = domain + "/api/v1";
    private final Logger logger = LoggerFactory.getLogger(TrefleRequestMaker.class);


    @Autowired
    public TrefleRequestMaker(@Value("${trefle.key}") String token) {
        this.token = token;
    }


    public Page<BotanicalInfo> fetchInfoFromPartial(String partialPlantScientificName, Pageable pageable)
        throws InfoExtractionException {
        logger.debug("Fetching info for \"{}\" from Trefle", partialPlantScientificName);
        final String encodedPartialName = URLEncoder.encode(partialPlantScientificName, StandardCharsets.UTF_8);
        final String url =
            String.format("%s/species/search?q=%s&limit=%s&page=%s&token=%s", baseEndpoint, encodedPartialName,
                          pageable.getPageSize(), pageable.getPageNumber() + 1, token
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
            final BotanicalInfo botanicalInfo = new BotanicalInfo();
            botanicalInfo.setCreator(BotanicalInfoCreator.TREFLE);
            try {
                fillTrefleInfo(plantResult, botanicalInfo);
                botanicalInfos.add(botanicalInfo);
            } catch (UnsupportedOperationException e) {
                logger.error("Error while retrieving info about species", e);
            }
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillTrefleInfo(JsonElement plantResult, BotanicalInfo botanicalInfo) {
        final JsonObject plantJson = plantResult.getAsJsonObject();
        botanicalInfo.setExternalId(plantJson.get("id").getAsString());
        botanicalInfo.setSpecies(plantJson.get("scientific_name").getAsString());
        botanicalInfo.setFamily(plantJson.get("family").getAsString());
        botanicalInfo.setGenus(plantJson.get("genus").getAsString());
        if (!isJsonValueNull(plantJson, "image_url")) {
            fillImage(botanicalInfo, plantJson.get("image_url").getAsString());
        }
        fillPlantCare(botanicalInfo, plantJson);
        fillSynonyms(botanicalInfo, getSynonymsJson(plantResult.getAsJsonObject()));
    }



    private void fillPlantCare(BotanicalInfo botanicalInfo, JsonObject plantJson) {
        final JsonObject growthJson = getPlantGrowthJson(plantJson);
        final PlantCareInfo plantCareInfo = getPlantCare(growthJson);
        botanicalInfo.setPlantCareInfo(plantCareInfo);
    }


    private PlantCareInfo getPlantCare(JsonObject growthJson) {
        final PlantCareInfo plantCareInfo = new PlantCareInfo();
        if (!isJsonValueNull(growthJson, "light")) {
            plantCareInfo.setLight(growthJson.get("light").getAsInt());
        }
        if (!isJsonValueNull(growthJson, "ph_minimum")) {
            plantCareInfo.setPhMin(growthJson.get("ph_minimum").getAsDouble());
        }
        if (!isJsonValueNull(growthJson, "ph_maximum")) {
            plantCareInfo.setPhMax(growthJson.get("ph_maximum").getAsDouble());
        }
        if (!isJsonValueNull(growthJson, "minimum_temperature") &&
                !isJsonValueNull(growthJson.get("minimum_temperature").getAsJsonObject(), "deg_c")) {
            plantCareInfo.setMinTemp(
                growthJson.get("minimum_temperature").getAsJsonObject().get("deg_c").getAsDouble());
        }
        if (!isJsonValueNull(growthJson, "maximum_temperature") &&
                !isJsonValueNull(growthJson.get("maximum_temperature").getAsJsonObject(), "deg_c")) {
            plantCareInfo.setMaxTemp(
                growthJson.get("maximum_temperature").getAsJsonObject().get("deg_c").getAsDouble());
        }
        if (!isJsonValueNull(growthJson, "soil_humidity")) {
            plantCareInfo.setPhMin(growthJson.get("soil_humidity").getAsDouble());
        }
        return plantCareInfo;
    }


    private void fillSynonyms(BotanicalInfo botanicalInfo, JsonObject plantJson) {
        final Set<String> synonyms = getSynonyms(plantJson);
        botanicalInfo.setSynonyms(synonyms);
    }


    private Set<String> getSynonyms(JsonObject plantJson) {
        final Set<String> synonyms = new HashSet<>();
        plantJson.get("synonyms").getAsJsonArray()
                 .forEach(synonym -> synonyms.add(synonym.getAsJsonObject().get("name").getAsString()));
        if (!isJsonValueNull(plantJson, "common_name")) {
            synonyms.add(plantJson.get("common_name").getAsString());
        }
        if (plantJson.get("common_names").getAsJsonObject().has("en")) {
            plantJson.get("common_names").getAsJsonObject().get("en").getAsJsonArray()
                     .forEach(synonym -> synonyms.add(synonym.getAsString()));
        }
        return synonyms;
    }


    private boolean isJsonValueNull(JsonObject jsonObject, String key) {
        if (jsonObject.get(key).isJsonNull()) {
            return true;
        }
        try {
            return jsonObject.get(key).getAsString().equals("null");
        } catch (UnsupportedOperationException ignored) {
            return false;
        }
    }


    protected JsonObject getPlantGrowthJson(JsonObject plantJson) {
        final String link = plantJson.get("links").getAsJsonObject().get("self").getAsString();
        final String url = String.format("%s%s?token=%s", domain, link, token);
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();

        try {
            final JsonElement data = responseJson.get("data").getAsJsonObject().get("growth").getAsJsonObject();
            return data.getAsJsonObject();
        } catch (IndexOutOfBoundsException e) {
            logger.error(
                String.format("Error while retrieving growth of species %s from Trefle.", plantJson.get("id")));
            return null;
        }
    }


    private JsonObject getSynonymsJson(JsonObject searchSpeciesJson) {
        final String link = searchSpeciesJson.get("links").getAsJsonObject().get("self").getAsString();
        final String url = String.format("%s%s?token=%s", domain, link, token);
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();

        try {
            final JsonElement data = responseJson.get("data").getAsJsonObject();
            return data.getAsJsonObject();
        } catch (IndexOutOfBoundsException e) {
            logger.error(
                String.format("Error while retrieving species json for %s from Trefle.", searchSpeciesJson.get("id")));
            return null;
        }
    }


    public Page<BotanicalInfo> fetchAll(Pageable pageable) {
        logger.debug("Fetching all info from Trefle");
        final String url =
            String.format("%s/species/search?limit=%s&page=%s&token=%s&q=*", baseEndpoint, pageable.getPageSize(),
                          pageable.getPageNumber() + 1, token
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
            BotanicalInfo botanicalInfo = new BotanicalInfo();
            botanicalInfo.setCreator(BotanicalInfoCreator.TREFLE);
            fillTrefleInfo(plantResult, botanicalInfo);
            botanicalInfos.add(botanicalInfo);
        });
        return new PageImpl<>(botanicalInfos);
    }


    private void fillImage(BotanicalInfo botanicalInfo, String imageUrl) throws InfoExtractionException {
        final BotanicalInfoImage abstractEntityImage = new BotanicalInfoImage();
        abstractEntityImage.setUrl(imageUrl);
        abstractEntityImage.setId(null);
        botanicalInfo.setImage(abstractEntityImage);
    }


    protected String getExternalId(String species) {
        final String encodedSpecies = URLEncoder.encode(species, StandardCharsets.UTF_8);
        final String url =
            String.format("%s/species/search?limit=1&page=1&token=%s&q=%s", baseEndpoint, token, encodedSpecies);
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();

        try {
            final JsonElement data = responseJson.get("data").getAsJsonArray().get(0);
            return data.getAsJsonObject().get("id").getAsString();
        } catch (IndexOutOfBoundsException e) {
            logger.error(String.format("Error while retrieving external_id of species %s from Trefle.", species));
            return null;
        }
    }


    public PlantCareInfo getPlantCare(BotanicalInfo toUpdate) {
        final String url = String.format("%s/species/%s?token=%s", baseEndpoint, toUpdate.getExternalId(), token);
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();

        try {
            final JsonObject data = responseJson.get("data").getAsJsonObject().get("growth").getAsJsonObject();
            return getPlantCare(data);
        } catch (IndexOutOfBoundsException e) {
            logger.error(
                String.format("Error while retrieving growth of species %s from Trefle.", toUpdate.getExternalId()));
            return null;
        }
    }


    public Set<String> getSynonyms(BotanicalInfo toUpdate) {
        final String url = String.format("%s/species/%s?token=%s", baseEndpoint, toUpdate.getExternalId(), token);
        final HttpClient client = HttpClient.newHttpClient();
        final HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build();

        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new InfoExtractionException(e);
        }
        final JsonObject responseJson = JsonParser.parseString(response.body()).getAsJsonObject();

        try {
            final JsonObject data = responseJson.get("data").getAsJsonObject();
            return getSynonyms(data);
        } catch (IndexOutOfBoundsException e) {
            logger.error(
                String.format("Error while retrieving growth of species %s from Trefle.", toUpdate.getExternalId()));
            return null;
        }
    }
}

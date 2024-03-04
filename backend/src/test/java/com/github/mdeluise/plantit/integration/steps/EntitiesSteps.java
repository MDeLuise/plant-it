package com.github.mdeluise.plantit.integration.steps;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoService;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfo;
import com.github.mdeluise.plantit.botanicalinfo.care.PlantCareInfoDTO;
import com.github.mdeluise.plantit.image.BotanicalInfoImage;
import com.github.mdeluise.plantit.image.storage.ImageStorageService;
import com.github.mdeluise.plantit.integration.StepData;
import com.github.mdeluise.plantit.plant.Plant;
import com.github.mdeluise.plantit.plant.PlantDTO;
import com.github.mdeluise.plantit.plant.PlantService;
import com.github.mdeluise.plantit.plant.PlantState;
import com.github.mdeluise.plantit.plant.info.PlantInfo;
import com.github.mdeluise.plantit.plant.info.PlantInfoDTO;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

public class EntitiesSteps {
    final int port;
    final String botanicalInfoPath = "/botanical-info";
    final String plantPath = "/plant";
    final String imagePath = "/image";
    final MockMvc mockMvc;
    final StepData stepData;
    final ObjectMapper objectMapper;
    final BotanicalInfoService botanicalInfoService;
    final PlantService plantService;
    final ImageStorageService imageStorageService;
    final String imageLocation;


    public EntitiesSteps(@Value("${server.port}") int port, MockMvc mockMvc, StepData stepData,
                         ObjectMapper objectMapper, BotanicalInfoService botanicalInfoService,
                         PlantService plantService, ImageStorageService imageStorageService,
                         @Value("${upload.location}") String imageLocation) {
        this.port = port;
        this.mockMvc = mockMvc;
        this.stepData = stepData;
        this.objectMapper = objectMapper;
        this.botanicalInfoService = botanicalInfoService;
        this.plantService = plantService;
        this.imageStorageService = imageStorageService;
        this.imageLocation = imageLocation;
    }


    @Given("user requests all botanical info")
    public void getAllBotanicalInfo() throws Exception {
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.get(String.format("http://localhost:%s%s", port, botanicalInfoPath))
                                  .contentType(MediaType.APPLICATION_JSON)).andReturn();
        stepData.setResponse(result);
    }


    @Given("user requests all botanical info with partial scientific name {string}")
    public void getAllBotanicalInfoWithPartialName(String partialName) throws Exception {
        final MvcResult result =
            mockMvc.perform(MockMvcRequestBuilders.get(
                String.format("http://localhost:%s%s/partial/%s", port, botanicalInfoPath, partialName))
                                                  .contentType(MediaType.APPLICATION_JSON))
                   .andReturn();
        stepData.setResponse(result);
    }


    @Given("user requests count of plants for a botanical info with id {string}")
    public void getCountOfPlants(String botanicalInfoId) throws Exception {
        final MvcResult result =
            mockMvc.perform(MockMvcRequestBuilders.get(
                String.format("http://localhost:%s%s/%s/_count", port, botanicalInfoPath, botanicalInfoId))
                                                  .contentType(MediaType.APPLICATION_JSON))
                   .andReturn();
        stepData.setResponse(result);
    }


    @Given("user requests count of all botanical info")
    public void getCountOfAllBotanicalInfo() throws Exception {
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.get(String.format("http://localhost:%s%s/_count", port, botanicalInfoPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())).andReturn();
        stepData.setResponse(result);
    }


    @When("user adds new botanical info")
    public void createUserNewBotanicalInfo(DataTable table) throws Exception {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final String extractedSynonyms = parameters.get("synonyms");
        final Set<String> synonyms;
        if (extractedSynonyms != null) {
            synonyms = new HashSet<>(Arrays.asList(extractedSynonyms.split(",")));
        } else {
            synonyms = Set.of();
        }
        final BotanicalInfoDTO botanicalInfoDTO = new BotanicalInfoDTO();
        botanicalInfoDTO.setSynonyms(synonyms);
        botanicalInfoDTO.setFamily(parameters.get("family"));
        botanicalInfoDTO.setGenus(parameters.get("genus"));
        botanicalInfoDTO.setSpecies(parameters.get("species"));
        botanicalInfoDTO.setCreator(parameters.get("creator"));
        botanicalInfoDTO.setExternalId(parameters.get("externalId"));
        botanicalInfoDTO.setImageId(parameters.get("image_id"));
        botanicalInfoDTO.setImageUrl(parameters.get("image_url"));
        botanicalInfoDTO.setImageContentType(parameters.get("image_content_type"));
        if (parameters.get("image_content") != null) {
            botanicalInfoDTO.setImageContent(Base64.getDecoder().decode(parameters.get("image_content")));
        }
        if (stepData.contains("plantCareInfoDTO")) {
            botanicalInfoDTO.setPlantCareInfo((PlantCareInfoDTO) stepData.get("plantCareInfoDTO"));
        }

        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.post(String.format("http://localhost:%s%s", port, botanicalInfoPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())
                                  .content(objectMapper.writeValueAsString(botanicalInfoDTO))).andReturn();
        stepData.setResponse(result);
        if (HttpStatusCode.valueOf(result.getResponse().getStatus()).is2xxSuccessful()) {
            final BotanicalInfoDTO createdBotanicalInfo =
                objectMapper.readValue(result.getResponse().getContentAsString(), BotanicalInfoDTO.class);
            stepData.put("lastBotanicalInfo", createdBotanicalInfo);
        }
    }


    @When("user updates botanical info {string}")
    public void updateBotanicalInfo(String botanicalInfoName, DataTable table) throws Exception {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final String extractedSynonyms = parameters.get("synonyms");
        final Set<String> synonyms;
        if (extractedSynonyms != null) {
            synonyms = new HashSet<>(Arrays.asList(extractedSynonyms.split(",")));
        } else {
            synonyms = Set.of();
        }
        final BotanicalInfoDTO botanicalInfoDTO = new BotanicalInfoDTO();
        botanicalInfoDTO.setSynonyms(synonyms);
        botanicalInfoDTO.setFamily(parameters.get("family"));
        botanicalInfoDTO.setGenus(parameters.get("genus"));
        botanicalInfoDTO.setSpecies(parameters.get("species"));
        botanicalInfoDTO.setCreator(parameters.get("creator"));
        botanicalInfoDTO.setExternalId(parameters.get("externalId"));
        botanicalInfoDTO.setImageId(parameters.get("image_id"));
        botanicalInfoDTO.setImageUrl(parameters.get("image_url"));
        botanicalInfoDTO.setImageContentType(parameters.get("image_content_type"));
        if (parameters.get("image_content") != null) {
            botanicalInfoDTO.setImageContent(Base64.getDecoder().decode(parameters.get("image_content")));
        }
        if (stepData.contains("plantCareInfoDTO")) {
            botanicalInfoDTO.setPlantCareInfo((PlantCareInfoDTO) stepData.get("plantCareInfoDTO"));
        }

        final Long toUpdate = getBotanicalInfoFromScientificName(botanicalInfoName).getId();

        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.put(String.format("http://localhost:%s%s/%s", port, botanicalInfoPath, toUpdate))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())
                                  .content(objectMapper.writeValueAsString(botanicalInfoDTO))).andReturn();
        stepData.setResponse(result);
        if (HttpStatusCode.valueOf(result.getResponse().getStatus()).is2xxSuccessful()) {
            final BotanicalInfoDTO createdBotanicalInfo =
                objectMapper.readValue(result.getResponse().getContentAsString(), BotanicalInfoDTO.class);
            stepData.put("lastBotanicalInfo", createdBotanicalInfo);
        }
    }


    @When("using this plant info")
    public void setPlantInfo(DataTable table) throws Exception {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);

        final PlantInfoDTO plantInfoDTO = new PlantInfoDTO();
        plantInfoDTO.setStartDate(parseDate(parameters.get("startDate")));
        plantInfoDTO.setPersonalName(parameters.get("personalName"));
        plantInfoDTO.setEndDate(parseDate(parameters.get("endDate")));
        plantInfoDTO.setState(PlantState.valueOf(parameters.get("state")));
        plantInfoDTO.setNote(parameters.get("note"));
        plantInfoDTO.setPurchasedPrice(parseNumber(Double.class, parameters.get("purchasedPrice")));

        plantInfoDTO.setCurrencySymbol(parameters.get("currencySymbol"));
        plantInfoDTO.setSeller(parameters.get("seller"));
        plantInfoDTO.setLocation(parameters.get("location"));

        stepData.put("plantInfoDTO", plantInfoDTO);
    }


    private <T extends Number> T parseNumber(Class<T> numClass, String value) throws Exception {
        if (value == null) {
            return null;
        }
        return numClass.getDeclaredConstructor(String.class).newInstance(value);
    }


    private Date parseDate(String dateString) throws ParseException {
        if (dateString == null) {
            return null;
        }
        final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.parse(dateString);
    }


    @When("user adds new plant")
    public void createNewPlant(DataTable table) throws Exception {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);

        final PlantDTO plantDTO = new PlantDTO();
        plantDTO.setAvatarImageId(parameters.get("avatar_id"));
        plantDTO.setAvatarImageUrl(parameters.get("avatar_url"));
        plantDTO.setAvatarMode(parameters.get("avatar_mode"));
        final long botanicalInfoId = getBotanicalInfoFromScientificName(parameters.get("botanical_info")).getId();
        plantDTO.setBotanicalInfoId(botanicalInfoId);

        if (stepData.contains("plantInfoDTO")) {
            plantDTO.setInfo((PlantInfoDTO) stepData.get("plantInfoDTO"));
        }

        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.post(String.format("http://localhost:%s%s", port, plantPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())
                                  .content(objectMapper.writeValueAsString(plantDTO))).andReturn();

        if (HttpStatusCode.valueOf(result.getResponse().getStatus()).is2xxSuccessful()) {
            stepData.setResponse(result);
            final PlantDTO createdPlant =
                objectMapper.readValue(result.getResponse().getContentAsString(), PlantDTO.class);
            stepData.put("lastPlant", createdPlant);
        }
    }


    private BotanicalInfo getBotanicalInfoFromScientificName(String scientificName) {
        return botanicalInfoService.getInternal(scientificName);
    }


    @When("user requests count of all plants")
    public void userRequestsCountOfAllPlants() throws Exception {
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.get(String.format("http://localhost:%s%s/_count", port, plantPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())).andReturn();
        stepData.setResponse(result);
    }


    @When("user delete species {string}")
    public void userDeleteSpecies(String speciesName) throws Exception {
        final Long toDelete = getBotanicalInfoFromScientificName(speciesName).getId();
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.delete(String.format("http://localhost:%s%s/%s", port, botanicalInfoPath, toDelete))
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())
                                  .contentType(MediaType.APPLICATION_JSON)).andReturn();
        stepData.setResponse(result);
    }


    @And("there is/are {int} image(s) in upload folder")
    public void imagesNumberInUploadFolderIs(int expected) {
        Assertions.assertThat(new File(imageLocation).listFiles().length).isEqualTo(expected);
    }


    @When("user updates plant {string}")
    public void userUpdatesPlant(String plantName, DataTable table) throws Exception {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);

        final PlantDTO plantDTO = new PlantDTO();
        plantDTO.setAvatarImageId(parameters.get("avatar_id"));
        plantDTO.setAvatarImageUrl(parameters.get("avatar_url"));
        plantDTO.setAvatarMode(parameters.get("avatar_mode"));
        final long botanicalInfoId = getBotanicalInfoFromScientificName(parameters.get("botanical_info")).getId();
        plantDTO.setBotanicalInfoId(botanicalInfoId);

        if (stepData.contains("plantInfoDTO")) {
            plantDTO.setInfo((PlantInfoDTO) stepData.get("plantInfoDTO"));
        }

        final Long toUpdateId = getPlantFromName(plantName).getId();

        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.put(String.format("http://localhost:%s%s/%s", port, plantPath, toUpdateId))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt())
                                  .content(objectMapper.writeValueAsString(plantDTO))).andReturn();
        stepData.setResponse(result);
    }


    private Plant getPlantFromName(String name) {
        return plantService.getInternal(name);
    }


    @Then("plant {string} has this info")
    public void plantHasThisInfo(String plantName, DataTable table) throws Exception {
        final PlantInfo toCheck = plantService.getInternal(plantName).getInfo();
        // Don't know why... If not doing this, they are Timestamp and not Date, so equal fails
        toCheck.setStartDate(Date.from(toCheck.getStartDate().toInstant()));
        toCheck.setEndDate(Date.from(toCheck.getEndDate().toInstant()));


        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final PlantInfo wanted = new PlantInfo();
        wanted.setStartDate(parseDate(parameters.get("startDate")));
        wanted.setPersonalName(parameters.get("personalName"));
        wanted.setEndDate(parseDate(parameters.get("endDate")));
        wanted.setNote(parameters.get("note"));
        wanted.setPurchasedPrice(parseNumber(Double.class, parameters.get("purchasedPrice")));
        wanted.setPlantState(PlantState.valueOf(parameters.get("state")));
        wanted.setCurrencySymbol(parameters.get("currencySymbol"));
        wanted.setSeller(parameters.get("seller"));
        wanted.setLocation(parameters.get("location"));

        Assertions.assertThat(toCheck).isEqualTo(wanted);
    }


    @Then("plant {string} is")
    public void plantIs(String plantName, DataTable table) {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final Plant toCheck = plantService.getInternal(plantName);
        final Long botanicalInfoId = getBotanicalInfoFromScientificName(parameters.get("botanical_info")).getId();

        Assertions.assertThat(toCheck.getAvatarMode().toString()).isEqualTo(parameters.get("avatar_mode"));
        Assertions.assertThat(toCheck.getBotanicalInfo().getId()).isEqualTo(botanicalInfoId);
    }



    @Then("species {string} is")
    public void botanicalInfoIs(String botanicalInfoName, DataTable table) {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final BotanicalInfo toCheck = getBotanicalInfoFromScientificName(botanicalInfoName);

        Assertions.assertThat(toCheck.getSpecies()).isEqualTo(parameters.get("species"));
        Assertions.assertThat(toCheck.getExternalId()).isEqualTo(parameters.get("external_id"));
        Assertions.assertThat(toCheck.getFamily()).isEqualTo(parameters.get("family"));
        Assertions.assertThat(toCheck.getGenus()).isEqualTo(parameters.get("genus"));
        Assertions.assertThat(toCheck.getScientificName()).isEqualTo(parameters.get("scientific_name"));
        Assertions.assertThat(toCheck.getCreator().toString()).isEqualTo(parameters.get("creator"));
        if (parameters.get("synonyms") != null) {
            Assertions.assertThat(toCheck.getSynonyms()).containsExactlyInAnyOrderElementsOf(
                Arrays.stream(parameters.get("synonyms").split(",")).toList());
        } else {
            Assertions.assertThat(toCheck.getSynonyms()).hasSize(0);
        }
    }


    @Then("species {string} has this care")
    public void botanicalInfoCareIs(String botanicalInfoName, DataTable table) {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final PlantCareInfo toCheck = getBotanicalInfoFromScientificName(botanicalInfoName).getPlantCareInfo();

        if (parameters.get("light") != null) {
            Assertions.assertThat(toCheck.getLight()).isEqualTo(Integer.parseInt(parameters.get("light")));
        } else {
            Assertions.assertThat(toCheck.getLight()).isNull();
        }
        if (parameters.get("humidity") != null) {
            Assertions.assertThat(toCheck.getHumidity()).isEqualTo(Integer.parseInt(parameters.get("humidity")));
        } else {
            Assertions.assertThat(toCheck.getHumidity()).isNull();
        }
        if (parameters.get("min_temp") != null) {;
            Assertions.assertThat(toCheck.getMinTemp()).isEqualTo(Double.parseDouble(parameters.get("min_temp")));
        } else {
            Assertions.assertThat(toCheck.getMinTemp()).isNull();
        }
        if (parameters.get("max_temp") != null) {
            Assertions.assertThat(toCheck.getMaxTemp()).isEqualTo(Double.parseDouble(parameters.get("max_temp")));
        } else {
            Assertions.assertThat(toCheck.getMaxTemp()).isNull();
        }
        if (parameters.get("ph_min") != null) {
            Assertions.assertThat(toCheck.getPhMin()).isEqualTo(Double.parseDouble(parameters.get("ph_min")));
        } else {
            Assertions.assertThat(toCheck.getPhMin()).isNull();
        }
        if (parameters.get("ph_max") != null) {
            Assertions.assertThat(toCheck.getPhMax()).isEqualTo(Double.parseDouble(parameters.get("ph_max")));
        } else {
            Assertions.assertThat(toCheck.getPhMax()).isNull();
        }
    }


    @Then("using this species care")
    public void setSpeciesCare(DataTable table) {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);

        final PlantCareInfoDTO careInfoDTO = new PlantCareInfoDTO();
        if (parameters.get("light") != null) {
            careInfoDTO.setLight(Integer.parseInt(parameters.get("light")));
        }
        if (parameters.get("humidity") != null) {
            careInfoDTO.setHumidity(Integer.parseInt(parameters.get("humidity")));
        }
        if (parameters.get("min_temp") != null) {;
            careInfoDTO.setMinTemp(Double.parseDouble(parameters.get("min_temp")));
        }
        if (parameters.get("max_temp") != null) {
            careInfoDTO.setMaxTemp(Double.parseDouble(parameters.get("max_temp")));
        }
        if (parameters.get("ph_min") != null) {
            careInfoDTO.setPhMin(Double.parseDouble(parameters.get("ph_min")));
        }
        if (parameters.get("ph_max") != null) {
            careInfoDTO.setPhMax(Double.parseDouble(parameters.get("ph_max")));
        }

        stepData.put("plantCareInfoDTO", careInfoDTO);
    }


    @Then("species {string} has this image")
    public void botanicalInfoHasImage(String botanicalInfoName, DataTable table) {
        final Map<String, String> parameters = table.transpose().asMap(String.class, String.class);
        final BotanicalInfoImage toCheck = getBotanicalInfoFromScientificName(botanicalInfoName).getImage();

        if (parameters.get("image_id") != null) {
            Assertions.assertThat(toCheck.getId()).isEqualTo(parameters.get("image_id"));
        }
        if (parameters.get("image_url") != null) {
            Assertions.assertThat(toCheck.getUrl()).isEqualTo(parameters.get("image_url"));
        }
        if (parameters.get("image_content") != null) {
            final byte[] expected = imageStorageService.getContentInternal(toCheck.getId());
            Assertions.assertThat(expected)
                      .isEqualTo(Base64.getDecoder().decode(parameters.get("image_content")));
        } else {
            try {
                imageStorageService.getContentInternal(toCheck.getId());
                Assertions.assertThat(false).isTrue();
            } catch (UnsupportedOperationException ignored) {
                Assertions.assertThat(true).isTrue();
            }

        }
    }


    @Then("species {string} has no image")
    public void botanicalInfoHasNoImage(String botanicalInfoName) {
        final BotanicalInfoImage toCheck = getBotanicalInfoFromScientificName(botanicalInfoName).getImage();
        Assertions.assertThat(toCheck).isNull();
    }
}

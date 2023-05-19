package com.github.mdeluise.plantit.integration.steps;

public class IntegrationSteps {
//    private final SubscriptionService subscriptionService;
//    private final VideoService videoService;
//    private final VideoScraper videoScraper;
//    private final VideoFeedExtractor videoFeedExtractor;
//    private final UserService userService;
//    private final MockMvc mockMvc;
//    private final StepData stepData;
//    private final ObjectMapper objectMapper;
    private final String signupEndpoint = "/authentication/signup";
    private final String loginEndpoint = "/authentication/login";
    private final String subscriptionEndpoint = "/subscription";
    private final String videoEndpoint = "/video";


//    private record ChannelVideoWrapper(String channelId, Video video) {
//    }
//
//
//    public IntegrationSteps(SubscriptionService subscriptionService, VideoService videoService,
//                            DummyVideoFeedExtractor videoFeedScraper, VideoScraper videoScraper, UserService userService,
//                            MockMvc mockMvc, StepData stepData, ObjectMapper objectMapper) {
//        this.subscriptionService = subscriptionService;
//        this.videoService = videoService;
//        this.videoScraper = videoScraper;
//        this.videoFeedExtractor = videoFeedScraper;
//        this.userService = userService;
//        this.mockMvc = mockMvc;
//        this.stepData = stepData;
//        this.objectMapper = objectMapper;
//    }
//
//
//    @When("call GET {string}")
//    public void callGet(String url) throws Exception {
//        stepData.setResponse(mockMvc.perform(MockMvcRequestBuilders.get(url).contentType(MediaType.APPLICATION_JSON)
//                                                                   .header(HttpHeaders.AUTHORIZATION,
//                                                                           stepData.getJwt().orElse("")
//                                                                   )).andReturn());
//    }
//
//
//    @When("call POST {string} with body {string}")
//    public void callPostWithBody(String url, String body) throws Exception {
//        stepData.setResponse(mockMvc.perform(MockMvcRequestBuilders.post(url).contentType(MediaType.APPLICATION_JSON)
//                                                                   .header(HttpHeaders.AUTHORIZATION,
//                                                                           stepData.getJwt().orElse("")
//                                                                   ).content(body)).andReturn());
//    }
//
//
//    @When("call PUT {string} with body {string}")
//    public void callPutWithBody(String url, String body) throws Exception {
//        stepData.setResponse(mockMvc.perform(MockMvcRequestBuilders.get(url).contentType(MediaType.APPLICATION_JSON)
//                                                                   .header(HttpHeaders.AUTHORIZATION,
//                                                                           stepData.getJwt().orElse("")
//                                                                   ).content(body)).andReturn());
//    }
//
//
//    @When("call DELETE {string} with body {string}")
//    public void callDeleteWithBody(String url, String body) throws Exception {
//        stepData.setResponse(mockMvc.perform(MockMvcRequestBuilders.delete(url).contentType(MediaType.APPLICATION_JSON)
//                                                                   .header(HttpHeaders.AUTHORIZATION,
//                                                                           stepData.getJwt().orElse("")
//                                                                   ).content(body)).andReturn());
//    }
//
//
//    @Then("receive status code of {int}")
//    public void theClientReceivesStatusCode(int expectedStatus) {
//        Assert.assertEquals(expectedStatus, stepData.getResponseCode());
//    }
//
//
//    @Then("the count of subscriptions is {int}")
//    public void countSubscriptionsForUsers(int expectedCount) throws Exception {
//        callGet(subscriptionEndpoint);
//        Assert.assertEquals(expectedCount, stepData.getResponseCode());
//    }
//
//
//    @Then("the count of video is {int}")
//    public void countVideo(int expectedCount) throws Exception {
//        getAllTheVideo();
//        stepData.getResultAction().andExpect(MockMvcResultMatchers.jsonPath("$.numberOfElements").value(expectedCount));
//    }
//
//
//    @ParameterType("(?:\\d+,\\s*)*\\d+")
//    public List<Long> listOfLongs(String arg) {
//        return Arrays.stream(arg.split(",\\s?")).sequential().map(Long::parseLong).collect(Collectors.toList());
//    }
//
//
//    @And("cleanup the environment")
//    @Transactional
//    public void cleanupTheEnvironment() {
//        subscriptionService.removeAll();
//        videoService.removeAll();
//        userService.removeAll();
//        stepData.cleanup();
//    }
//
//
//    @When("remove subscription(s) {listOfLongs}")
//    public void removeSubscriptions(List<Long> subscriptionIds) throws Exception {
//        for (Long subscriptionId : subscriptionIds) {
//            callDeleteWithBody(subscriptionEndpoint + "/" + subscriptionId, "{}");
//            Assert.assertEquals(HttpStatus.OK.value(), stepData.getResponseCode());
//        }
//    }
//
//
//    @Given("the following users")
//    public void theFollowingUsers(List<User> userList) throws Exception {
//        for (User user : userList) {
//            SignupRequest signupRequest = new SignupRequest(user.getUsername(), user.getPassword());
//            callPostWithBody(signupEndpoint, objectMapper.writeValueAsString(signupRequest));
//            Assert.assertEquals(HttpStatus.OK.value(), stepData.getResponseCode());
//        }
//    }
//
//
//    @DataTableType
//    public User userEntry(Map<String, String> entry) {
//        User user = new User();
//        user.setUsername(entry.get("username"));
//        user.setPassword(entry.get("password"));
//        return user;
//    }
//
//
//    @Given("the authenticated user with username {string} and password {string}")
//    public void login(String username, String password) throws Exception {
//        LoginRequest loginRequest = new LoginRequest(username, password);
//        callPostWithBody(loginEndpoint, objectMapper.writeValueAsString(loginRequest));
//        Assert.assertEquals(HttpStatus.OK.value(), stepData.getResponseCode());
//
//        // This should be done without parsing the response, using ModelMapper as:
//        // modelMapper.map(stepData.getResponse(), UserInfoResponse.class)
//        // but, the UserInfoResponse.class is a record, and ModelMapper does not support they yet
//        Pattern pattern = Pattern.compile("(value\":)(\"[^\"]+\")");
//        Matcher matcher = pattern.matcher(stepData.getResponse());
//        if (matcher.find()) {
//            String jwt = matcher.group(2).replaceAll("^\"+", "").replaceAll("\"+$", "");
//            stepData.setJwt(jwt);
//        }
//    }
//
//
//    @And("the subscription to channel with id {string}")
//    public void subscribeToChannel(String channelId) throws Exception {
//        SubscriptionDTO subscriptionDto = new SubscriptionDTO();
//        subscriptionDto.setChannelId(channelId);
//        callPostWithBody(subscriptionEndpoint, objectMapper.writeValueAsString(subscriptionDto));
//        Assert.assertEquals(HttpStatus.OK.value(), stepData.getResponseCode());
//    }
//
//
//    @When("get all the video")
//    public void getAllTheVideo() throws Exception {
//        stepData.setResultActions(mockMvc.perform(
//            MockMvcRequestBuilders.get(videoEndpoint).contentType(MediaType.APPLICATION_JSON)
//                                  .header(HttpHeaders.AUTHORIZATION, stepData.getJwt().orElse(""))));
//    }
//
//
//    @And("wait the scraping")
//    public void waitTheScraping() {
//        videoScraper.saveNewVideo();
//    }
//
//
//    @And("the following channelVideo")
//    public void theFollowingChannelVideo(List<ChannelVideoWrapper> channelVideoList) {
//        for (ChannelVideoWrapper channelVideo : channelVideoList) {
//            ((DummyVideoFeedExtractor) videoFeedExtractor).addVideoForChannel(
//                channelVideo.channelId(), channelVideo.video());
//        }
//    }
//
//
//    @DataTableType
//    public ChannelVideoWrapper videoEntry(Map<String, String> entry) {
//        Video video = new Video();
//        Channel channel = new Channel();
//        channel.setId(entry.get("channel id"));
//        video.setChannel(channel);
//        video.setId(entry.get("video id"));
//        video.setTitle(entry.get("video title"));
//        if (entry.get("published at") != null) {
//            video.setPublishedAt(new Date());
//            // videoDto.setPublishedAt(Date.parse(entry.get("published at")));
//        } else {
//            video.setPublishedAt(new Date());
//        }
//        video.setThumbnailLink(entry.get("thumbnail link"));
//        video.setView(Long.parseLong(entry.get("view")));
//
//        return new ChannelVideoWrapper(entry.get("channel id"), video);
//    }
}

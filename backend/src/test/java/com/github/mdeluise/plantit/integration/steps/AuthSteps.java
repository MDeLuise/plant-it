package com.github.mdeluise.plantit.integration.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.authentication.payload.request.LoginRequest;
import com.github.mdeluise.plantit.authentication.payload.request.SignupRequest;
import com.github.mdeluise.plantit.authentication.payload.response.UserInfoResponse;
import com.github.mdeluise.plantit.integration.StepData;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;


public class AuthSteps {
    final int port;
    final String authPath = "/authentication";
    final MockMvc mockMvc;
    final StepData stepData;
    final ObjectMapper objectMapper;


    public AuthSteps(@Value("${server.port}") int port, MockMvc mockMvc, StepData stepData, ObjectMapper objectMapper) {
        this.port = port;
        this.mockMvc = mockMvc;
        this.stepData = stepData;
        this.objectMapper = objectMapper;
    }


    @When("a user signup with username {string}, password {string}, email {string}")
    public void theClientLoginWithUsernameAndPassword(String username, String password, String email) throws Exception {
        final SignupRequest signupRequest = new SignupRequest(username, password, email);
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.post(String.format("http://localhost:%s%s/signup", port, authPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .content(objectMapper.writeValueAsString(signupRequest))
        ).andReturn();
        stepData.setResponse(result);
    }


    @When("a user login with username {string} and password {string}")
    public void theClientLoginWithUsernameAndPassword(String username, String password) throws Exception {
        final LoginRequest loginRequest = new LoginRequest(username, password);
        final MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.post(String.format("http://localhost:%s%s/login", port, authPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .content(objectMapper.writeValueAsString(loginRequest))
        ).andReturn();
        stepData.setResponse(result);
        if (result.getResponse().getStatus() == 200) {
            final UserInfoResponse loginResponse =
                objectMapper.readValue(result.getResponse().getContentAsString(), UserInfoResponse.class);
            stepData.setJwt(loginResponse.jwt().value());
        }
    }
}

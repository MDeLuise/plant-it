package com.github.mdeluise.plantit.integration.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.authentication.payload.request.LoginRequest;
import com.github.mdeluise.plantit.authentication.payload.response.UserInfoResponse;
import io.cucumber.java.en.Given;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;


public class AuthenticationSteps {
    final String authPath = "/authentication";
    final MockMvc mockMvc;
    final StepData stepData;
    final int port;
    final ObjectMapper objectMapper;


    public AuthenticationSteps(@Value("${server.port}") int port, MockMvc mockMvc, StepData stepData,
                               ObjectMapper objectMapper) {
        this.port = port;
        this.mockMvc = mockMvc;
        this.stepData = stepData;
        this.objectMapper = objectMapper;
    }


    @Given("login with username {string} and password {string}")
    public void theClientLoginWithUsernameAndPassword(String username, String password) throws Exception {
        LoginRequest loginRequest = new LoginRequest(username, password);
        MvcResult result = mockMvc.perform(
            MockMvcRequestBuilders.post(String.format("http://localhost:%s%s/login", port, authPath))
                                  .contentType(MediaType.APPLICATION_JSON)
                                  .content(objectMapper.writeValueAsString(loginRequest))).andReturn();
        stepData.setResponse(result);
        if (result.getResponse().getStatus() == 200) {
            UserInfoResponse loginResponse =
                objectMapper.readValue(result.getResponse().getContentAsString(), UserInfoResponse.class);
            stepData.setJwt(loginResponse.jwt().value());
        }
    }
}

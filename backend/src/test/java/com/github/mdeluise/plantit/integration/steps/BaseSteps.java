package com.github.mdeluise.plantit.integration.steps;

import java.io.UnsupportedEncodingException;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mdeluise.plantit.integration.StepData;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import org.assertj.core.api.Assertions;
import org.springframework.http.HttpStatus;
import org.springframework.test.web.servlet.MockMvc;

public class BaseSteps {
    final MockMvc mockMvc;
    final StepData stepData;
    final ObjectMapper objectMapper;


    public BaseSteps(MockMvc mockMvc, StepData stepData, ObjectMapper objectMapper) {
        this.mockMvc = mockMvc;
        this.stepData = stepData;
        this.objectMapper = objectMapper;
    }


    @Then("response is ok")
    public void responseIsOk() {
        Assertions.assertThat(stepData.getResponseCode()).isEqualTo(HttpStatus.OK.value());
    }


    @Then("response is not ok")
    public void responseIsNotOk() {
        Assertions.assertThat(stepData.getResponseCode()).isNotEqualTo(HttpStatus.OK.value());
    }


    @And("response message contains {string}")
    public void responseMessageContains(String message) throws UnsupportedEncodingException {
        Assertions.assertThat(stepData.getResponse().contains(message)).isTrue();
    }


    @Then("response is {string}")
    public void responseIs(String expected) throws UnsupportedEncodingException {
        Assertions.assertThat(stepData.getResponse()).isEqualTo(expected);
    }
}

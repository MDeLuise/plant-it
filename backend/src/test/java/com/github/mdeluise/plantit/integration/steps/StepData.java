package com.github.mdeluise.plantit.integration.steps;

import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;

import java.io.UnsupportedEncodingException;
import java.util.Optional;

@Component
public class StepData {
    private ResultActions resultActions;
    private MockHttpServletResponse response;
    private Optional<String> jwt = Optional.empty();


    public void setResponse(MvcResult resultActions) {
        this.response = resultActions.getResponse();
        this.resultActions = null;
    }


    public Optional<String> getJwt() {
        return jwt;
    }


    public void setJwt(String value) {
        this.jwt = Optional.of("Bearer " + value);
    }


    public int getResponseCode() {
        return response.getStatus();
    }


    public String getResponse() throws UnsupportedEncodingException {
        return response.getContentAsString();
    }


    public void setResultActions(ResultActions resultActions) {
        this.resultActions = resultActions;
        this.response = resultActions.andReturn().getResponse();
    }


    public ResultActions getResultAction() {
        return resultActions;
    }


    public void cleanup() {
        this.resultActions = null;
        this.response = null;
        this.jwt = Optional.empty();
    }
}

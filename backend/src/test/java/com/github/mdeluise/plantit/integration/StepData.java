package com.github.mdeluise.plantit.integration;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;

@Component
public class StepData {
    private final Map<String, Object> map = new HashMap<>();


    public void setResponse(MvcResult resultActions) {
        map.put("response", resultActions.getResponse());
        map.remove("resultActions");
    }


    public String getJwt() {
        return (String) map.get("jwt");
    }


    public void setJwt(String value) {
        map.put("jwt", "Bearer " + value);
    }


    public int getResponseCode() {
        return ((MockHttpServletResponse) map.get("response")).getStatus();
    }


    public String getResponse() throws UnsupportedEncodingException {
        return ((MockHttpServletResponse) map.get("response")).getContentAsString();
    }


    public void setResultActions(ResultActions resultActions) {
        map.put("resultActions", resultActions);
        map.put("response", resultActions.andReturn().getResponse());
    }


    public ResultActions getResultAction() {
        return (ResultActions) map.get("resultActions");
    }


    public Object get(String key) {
        return map.get(key);
    }


    public boolean contains(String key) {
        return map.containsKey(key);
    }


    public void put(String key, Object value) {
        map.put(key, value);
    }


    public void delete(String key) {
        map.remove(key);
    }


    public void cleanup() {
        this.map.clear();
    }
}
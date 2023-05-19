package com.github.mdeluise.plantit.integration;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
    features = "classpath:features",
    glue = {
        "com.github.mdeluise.plantit.integration",
        "com.github.mdeluise.plantit.integration.steps"
    },
    plugin = {"pretty"}
)
public class IntegrationRunnerTest {
}

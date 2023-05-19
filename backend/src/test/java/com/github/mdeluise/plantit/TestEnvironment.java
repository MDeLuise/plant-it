package com.github.mdeluise.plantit;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.module.paramnames.ParameterNamesModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.stereotype.Component;

@Component
public class TestEnvironment {
    @Bean
    public ObjectMapper objectMapper() {
        // not only return new ObjectMapper() because if so, since in the test only some classes
        // are @Import, it will lead to error with Instant conversion in ModelMapper
        return JsonMapper.builder().addModule(new ParameterNamesModule()).addModule(new Jdk8Module())
                         .addModule(new JavaTimeModule()).build();

    }


    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
}

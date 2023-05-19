package com.github.mdeluise.plantit;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import org.modelmapper.ModelMapper;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Plant-it REST API", version = "1.0",
        description = "<h1>Introduction</h1>" + "<p>Plant-it is a self-hosted, open " + "source, ...</p>",
        license = @License(name = "Apache 2.0", url = "https://www.apache.org/licenses/LICENSE-2.0"),
        contact = @Contact(name = "GitHub page", url = "https://github.com/MDeLuise/plant-it")
    ), security = {@SecurityRequirement(name = "bearerAuth")}, servers = {
    @Server(description = "Production", url = "http://localhost:8080/api"),
    @Server(description = "Developer", url = "http://localhost:8085/api")
}
)
@SecurityScheme(
    name = "bearerAuth", type = SecuritySchemeType.HTTP, bearerFormat = "JWT", scheme = "bearer",
    in = SecuritySchemeIn.HEADER
)
@EnableScheduling
@EnableMethodSecurity
@EnableCaching
public class ApplicationConfig {
    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
}

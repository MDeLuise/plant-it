package com.github.mdeluise.plantit;

import com.github.mdeluise.plantit.plantinfo.trafle.TrefleMigrator;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.servers.ServerVariable;
import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import redis.embedded.RedisServer;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Plant-it REST API", version = "1.0",
        description = "<h1>Introduction</h1>" + "<p>Plant-it is a self-hosted, open " +
                          "source, gardening companion app.</p>",
        license = @License(name = "GPL 3.0", url = "https://www.gnu.org/licenses/gpl-3.0.en.html"),
        contact = @Contact(name = "GitHub page", url = "https://github.com/MDeLuise/plant-it")
    ), security = {@SecurityRequirement(name = "bearerAuth")}, servers = {
    @Server(description = "Localhost", url = "/api"),
    @Server(
        description = "Custom",
        url = "{protocol}://{host}:{port}/{basePath}",
        variables = {
            @ServerVariable(name = "protocol", defaultValue = "http", allowableValues = {"http", "https"}),
            @ServerVariable(name = "host", defaultValue = "localhost"),
            @ServerVariable(name = "port", defaultValue = "8085"),
            @ServerVariable(name = "basePath", defaultValue = "api")
        })
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
    private final Logger logger = LoggerFactory.getLogger(ApplicationConfig.class);

    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }


    @Bean
    @Profile(value = "dev")
    public CommandLineRunner initEmbeddedCache(@Value("${spring.data.redis.port}") int port) {
        return args -> {
            RedisServer redisServer = new RedisServer(port);
            redisServer.start();
        };
    }


    @Bean
    public CommandLineRunner fillExternalIds(@Value("${trefle.key}") String trefleKey, TrefleMigrator trefleMigrator) {
        return args -> {
            if (trefleKey == null || trefleKey.isBlank()) {
                logger.info("trefle key not provided. Skipping entities update.");
                return;
            }
            logger.info("trefle key provided. Starting entities update...");
            trefleMigrator.fillMissingExternalIds();
        };
    }
}

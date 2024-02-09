package com.github.mdeluise.plantit;

import java.io.IOException;
import java.net.http.HttpClient;

import com.github.mdeluise.plantit.notification.otp.OtpService;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
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
import jakarta.annotation.PreDestroy;
import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
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
    private final OtpService otpService;
    private final TemporaryPasswordService temporaryPasswordService;
    private RedisServer redisServer;
    private final Logger logger = LoggerFactory.getLogger(ApplicationConfig.class);


    @Autowired
    public ApplicationConfig(OtpService otpService, TemporaryPasswordService temporaryPasswordService) {
        this.otpService = otpService;
        this.temporaryPasswordService = temporaryPasswordService;
    }


    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }


    @Bean
    @Profile(value = "dev")
    public CommandLineRunner initEmbeddedCache(@Value("${spring.data.redis.port}") int port) {
        return args -> {
            redisServer = new RedisServer(port);
            redisServer.start();
        };
    }


    @PreDestroy
    public void stopRedisServer() throws IOException {
        if (redisServer != null) {
            logger.debug("Stopping embedded redis...");
            try {
                redisServer.stop();
            } catch (IOException e) {
                logger.error("Error while stopping embedded redis instance", e);
                throw e;
            }
        }
    }


    @Bean
    public HttpClient httpClient() {
        return HttpClient.newHttpClient();
    }


    @CacheEvict(allEntries = true, cacheNames = {"latest-version"})
    @Scheduled(fixedDelay = 86400000) // 1 day
    public void cacheEvict() {
    }


    @Scheduled(fixedDelay = 28800000) // 8 hours
    public void removeExpired() {
        otpService.removeExpired();
        temporaryPasswordService.removeExpired();
    }


    @Bean
    public CommandLineRunner fillExternalInfo(@Value("${update_existing}") boolean update,
                                              @Value("${trefle.key}") String trefleKey, TrefleMigrator trefleMigrator) {
        return args -> {
            if (!update) {
                logger.info("UPDATE_EXISTING flag set to false. Skipping update of existing species.");
                return;
            }
            if (trefleKey == null || trefleKey.isBlank()) {
                logger.info(
                    "UPDATE_EXISTING flag set to true but trefle key not provided. Skipping update of existing " +
                        "species.");
                return;
            }
            logger.info("trefle key provided. Starting update of existing species...");
            trefleMigrator.fillMissingExternalInfo();
        };
    }
}

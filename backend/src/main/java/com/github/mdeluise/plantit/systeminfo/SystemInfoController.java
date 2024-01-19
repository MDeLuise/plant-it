package com.github.mdeluise.plantit.systeminfo;

import java.io.IOException;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/info")
@Tag(name = "Info", description = "Endpoints for system info")
@SecurityRequirements()
public class SystemInfoController {
    private final String version;
    private final GitHubService gitHubService;


    public SystemInfoController(@Value("${app.version}") String version, GitHubService gitHubService) {
        this.version = version;
        this.gitHubService = gitHubService;
    }


    @GetMapping("/ping")
    @Operation(
        summary = "Ping the service", description = "Check if the service is running."
    )
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }


    @GetMapping("/version")
    @Operation(
        summary = "System version", description = "Get the version of the system."
    )
    public ResponseEntity<SystemVersionInfo> getVersion() throws IOException, InterruptedException {
        final GitHubReleaseInfo latestVersion = gitHubService.getLatestVersion();

        final SystemVersionInfo systemVersionInfo = new SystemVersionInfo();
        systemVersionInfo.setCurrentVersion(version);
        systemVersionInfo.setLatestVersion(latestVersion.getTagName());
        systemVersionInfo.setLatest(version.equals(latestVersion.getTagName()));
        systemVersionInfo.setLatestReleaseNote(latestVersion.getBody());

        return ResponseEntity.ok(systemVersionInfo);
    }
}

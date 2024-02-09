package com.github.mdeluise.plantit.systeminfo;

import java.io.IOException;

import com.github.mdeluise.plantit.notification.email.EmailServiceProvider;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/info")
@Tag(name = "Info", description = "Endpoints for system info")
@SecurityRequirements()
public class SystemInfoController {
    private final SystemVersionService systemVersionService;
    private final EmailServiceProvider emailServiceProvider;


    @Autowired
    public SystemInfoController(SystemVersionService systemVersionService, EmailServiceProvider emailServiceProvider) {
        this.systemVersionService = systemVersionService;
        this.emailServiceProvider = emailServiceProvider;
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
        final SystemVersionInfo result = systemVersionService.getLatestVersion();
        return ResponseEntity.ok(result);
    }


    @GetMapping("/smtp")
    @Operation(
        summary = "SMTP configuration", description = "Check if the system use an SMTP server or not"
    )
    public ResponseEntity<Boolean> useSmtp() {
        return ResponseEntity.ok(emailServiceProvider.get().isPresent());
    }
}

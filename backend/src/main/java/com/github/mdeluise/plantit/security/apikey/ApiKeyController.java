package com.github.mdeluise.plantit.security.apikey;

import java.util.Collection;
import java.util.List;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api-key")
@Tag(name = "API Key", description = "Endpoints for API Key")
public class ApiKeyController {
    private final UserService userService;
    private final ApiKeyService apiKeyService;
    private final ApiKeyDTOConverter apiKeyDTOConverter;


    @Autowired
    public ApiKeyController(UserService userService, ApiKeyService apiKeyService,
                            ApiKeyDTOConverter apiKeyDTOConverter) {
        this.userService = userService;
        this.apiKeyService = apiKeyService;
        this.apiKeyDTOConverter = apiKeyDTOConverter;
    }


    @PostMapping("/")
    @Operation(
        summary = "Create a new API Key", description = "Create a new API Key."
    )
    public ResponseEntity<String> createNewApiKey(@RequestParam(required = false) String name) {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        final String username = authentication.getName();
        final User user = userService.get(username);
        final String result = apiKeyService.createNew(user, name);
        return ResponseEntity.ok().body(result);
    }


    @DeleteMapping("/{id}")
    @Operation(
        summary = "Delete an API Key", description = "Delete an API Key."
    )
    public ResponseEntity<String> removeApiKey(@PathVariable("id") Long apiKeyId) {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        final String username = authentication.getName();
        final User user = userService.get(username);
        apiKeyService.remove(user, apiKeyId);
        return ResponseEntity.ok().body("Api Key correctly removed.");
    }


    @GetMapping("/")
    @Operation(
        summary = "Get all the API Key", description = "Get all the API Key."
    )
    public ResponseEntity<Collection<ApiKeyDTO>> getAllApiKey() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        final String username = authentication.getName();
        final User user = userService.get(username);
        final List<ApiKeyDTO> result = apiKeyService.getAll(user).stream().map(apiKeyDTOConverter::convertToDTO).toList();
        return ResponseEntity.ok().body(result);
    }


    @GetMapping("/{id}")
    @Operation(
        summary = "Get a single API Key", description = "Get a single API Key, according to the `id` parameter."
    )
    public ResponseEntity<ApiKeyDTO> getApiKey(@PathVariable("id") Long id) {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        final String username = authentication.getName();
        final User user = userService.get(username);
        final ApiKeyDTO result = apiKeyDTOConverter.convertToDTO(apiKeyService.get(user, id));
        return ResponseEntity.ok().body(result);
    }


    @GetMapping("/name/{name}")
    @Operation(
        summary = "Get a single API Key by name",
        description = "Get a single API Key, according to the `name` parameter."
    )
    public ResponseEntity<ApiKeyDTO> getApiKeyByName(@PathVariable("name") String name) {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        final String username = authentication.getName();
        final User user = userService.get(username);
        final ApiKeyDTO result = apiKeyDTOConverter.convertToDTO(apiKeyService.get(user, name));
        return ResponseEntity.ok().body(result);
    }
}

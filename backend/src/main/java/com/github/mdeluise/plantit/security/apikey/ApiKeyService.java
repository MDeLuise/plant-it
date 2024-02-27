package com.github.mdeluise.plantit.security.apikey;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Collection;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ApiKeyService {
    private final ApiKeyRepository repository;


    @Autowired
    public ApiKeyService(ApiKeyRepository repository) {
        this.repository = repository;
    }


    public String createNew(User user, String name) {
        final String apiKeyValue = generateNewApiKeyValue();
        final ApiKey apiKey = new ApiKey();
        apiKey.setUser(user);
        apiKey.setValue(apiKeyValue);
        apiKey.setName(name != null ? name : generateApiKeyName(user));
        final ApiKey saved = repository.save(apiKey);
        return saved.getValue();
    }


    private String generateNewApiKeyValue() {
        final SecureRandom random = new SecureRandom();
        final byte[] bytes = new byte[64];
        random.nextBytes(bytes);
        return Base64.getEncoder().encodeToString(bytes);
    }


    private String generateApiKeyName(User user) {
        return String.format("%s_key_%s", user.getUsername(), System.currentTimeMillis());
    }


    public void remove(User user, Long id) {
        final ApiKey toRemove = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!user.getApiKeys().contains(toRemove)) {
            throw new ResourceNotFoundException(id);
        }
        user.removeApiKey(toRemove);
    }


    public ApiKey get(User user, Long id) {
        final ApiKey toReturn = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!toReturn.getUser().equals(user)) {
            throw new ResourceNotFoundException(id);
        }
        return toReturn;
    }


    public ApiKey get(User user, String name) {
        return repository.findByUserAndName(user, name).orElseThrow(() -> new ResourceNotFoundException("name", name));
    }


    public Collection<ApiKey> getAll(User user) {
        return repository.findByUser(user);
    }


    public User getUserFromApiKey(String apiKeyValue) {
        final ApiKey apiKey =
            repository.findByValue(apiKeyValue).orElseThrow(() -> new ResourceNotFoundException("value", apiKeyValue));
        return apiKey.getUser();
    }


    public boolean exist(String apiKeyValue) {
        return repository.existsByValue(apiKeyValue);
    }
}

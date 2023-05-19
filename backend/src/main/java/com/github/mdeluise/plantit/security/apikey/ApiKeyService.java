package com.github.mdeluise.plantit.security.apikey;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.codehaus.plexus.util.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Collection;

@Service
public class ApiKeyService {
    private final ApiKeyRepository repository;


    @Autowired
    public ApiKeyService(ApiKeyRepository repository) {
        this.repository = repository;
    }


    public String createNew(User user, String name) {
        String apiKeyValue = generateNewApiKeyValue();
        ApiKey apiKey = new ApiKey();
        apiKey.setUser(user);
        apiKey.setValue(apiKeyValue);
        apiKey.setName(name != null ? name : generateApiKeyName(user));
        ApiKey saved = repository.save(apiKey);
        return saved.getValue();
    }


    private String generateNewApiKeyValue() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[64];
        random.nextBytes(bytes);
        return new String(Base64.encodeBase64(bytes));
    }


    private String generateApiKeyName(User user) {
        return String.format("%s_key_%s", user.getUsername(), System.currentTimeMillis());
    }


    public void remove(User user, Long id) {
        ApiKey toRemove = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!user.getApiKeys().contains(toRemove)) { // FIXME add admin case
            throw new ResourceNotFoundException(id);
        }
        user.removeApiKey(toRemove);
    }


    public ApiKey get(User user, Long id) {
        ApiKey toReturn = repository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        if (!toReturn.getUser().equals(user)) { // FIXME add admin case
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
        ApiKey apiKey =
            repository.findByValue(apiKeyValue).orElseThrow(() -> new ResourceNotFoundException("value", apiKeyValue));
        return apiKey.getUser();
    }


    public boolean exist(String apiKeyValue) {
        return repository.existsByValue(apiKeyValue);
    }
}

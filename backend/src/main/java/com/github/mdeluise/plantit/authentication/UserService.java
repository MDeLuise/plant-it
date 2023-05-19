package com.github.mdeluise.plantit.authentication;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder encoder;


    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder encoder) {
        this.userRepository = userRepository;
        this.encoder = encoder;
    }


    public User get(String username) {
        return userRepository.findByUsername(username)
                             .orElseThrow(() -> new ResourceNotFoundException("username", username));
    }


    public User get(Long id) {
        return userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
    }


    public List<User> getAll() {
        return userRepository.findAll();
    }


    public User save(String username, String plainPassword) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(plainPassword);
        return save(user);
    }


    @Transactional
    public User update(Long id, User updatedUser) {
        User toUpdate = userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException(id));
        toUpdate.setUsername(updatedUser.getUsername());
        toUpdate.setPassword(updatedUser.getPassword());
        return userRepository.save(toUpdate);
    }


    public void remove(Long id) {
        userRepository.deleteById(id);
    }


    @Transactional
    public User save(User entityToSave) {
        entityToSave.setPassword(encoder.encode(entityToSave.getPassword()));
        return userRepository.save(entityToSave);
    }


    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }


    public void removeAll() {
        userRepository.deleteAll();
    }


    public long count() {
        return userRepository.count();
    }
}

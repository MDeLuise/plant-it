package com.github.mdeluise.plantit.authentication;

import java.util.List;
import javax.naming.AuthenticationException;

import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

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
        if (updatedUser.getUsername() != null && !updatedUser.getUsername().isBlank() &&
                !updatedUser.getUsername().equals(toUpdate.getUsername())) {
            toUpdate.setUsername(updatedUser.getUsername());
        }
        if (updatedUser.getPassword() != null && !updatedUser.getPassword().isBlank() &&
                !updatedUser.getPassword().equals(toUpdate.getPassword())) {
            toUpdate.setPassword(updatedUser.getPassword());
        }
        return userRepository.save(toUpdate);
    }


    public void updatePassword(Long userId, String currentPassword, String newPassword) throws AuthenticationException {
        User toUpdate = userRepository.findById(userId).orElseThrow(() -> new ResourceNotFoundException(userId));
        if (!encoder.matches(currentPassword, toUpdate.getPassword())) {
            throw new AuthenticationException("Current password does not match");
        }
        if (newPassword != null && !newPassword.isBlank() && !newPassword.equals(toUpdate.getPassword())) {
            final String encodedNewPassword = encoder.encode(newPassword);
            toUpdate.setPassword(encodedNewPassword);
            userRepository.save(toUpdate);
        }
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

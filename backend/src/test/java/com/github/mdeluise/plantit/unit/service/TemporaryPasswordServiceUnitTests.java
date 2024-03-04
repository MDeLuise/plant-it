package com.github.mdeluise.plantit.unit.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserRepository;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import com.github.mdeluise.plantit.notification.password.TemporaryPassword;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordGenerator;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordRepository;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
@DisplayName("Unit tests for TemporaryPasswordService")
class TemporaryPasswordServiceUnitTests {
    @Mock
    private TemporaryPasswordRepository temporaryPasswordRepository;
    @Mock
    private TemporaryPasswordGenerator temporaryPasswordGenerator;
    @Mock
    private UserRepository userRepository;
    @InjectMocks
    private TemporaryPasswordService temporaryPasswordService;


    @Test
    @DisplayName("Should generate and save new temporary password")
    void shouldGenerateAndSaveNewTemporaryPassword() {
        final String username = "testUser";
        final String generatedPassword = "generatedPassword";
        final Date expiration = new Date();
        final TemporaryPassword temporaryPassword = new TemporaryPassword();
        temporaryPassword.setUsername(username);
        temporaryPassword.setPlainPassword(generatedPassword);
        temporaryPassword.setExpiration(expiration);
        Mockito.when(userRepository.findByUsername(username)).thenReturn(Optional.of(new User()));
        Mockito.when(temporaryPasswordGenerator.generateTemporaryPassword(30, username)).thenReturn(temporaryPassword);

        final String result = temporaryPasswordService.generateNew(username);

        Assertions.assertThat(result).isEqualTo(generatedPassword);
        Mockito.verify(temporaryPasswordRepository).save(Mockito.any(TemporaryPassword.class));
    }


    @Test
    @DisplayName("Should throw error when generating temporary password for non-existing user")
    void shouldThrowResourceNotFoundExceptionWhenGeneratingTemporaryPasswordForNonExistingUser() {
        final String username = "nonExistingUser";
        Mockito.when(userRepository.findByUsername(username)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> temporaryPasswordService.generateNew(username)).isInstanceOf(
            ResourceNotFoundException.class);
    }


    @Test
    @DisplayName("Should remove expired temporary passwords")
    void shouldRemoveExpiredTemporaryPasswords() {
        final TemporaryPassword expiredPassword1 = new TemporaryPassword();
        expiredPassword1.setUsername("username1");
        expiredPassword1.setPlainPassword("password1");
        expiredPassword1.setExpiration(new Date(System.currentTimeMillis() - 10000));
        final TemporaryPassword expiredPassword2 = new TemporaryPassword();
        expiredPassword2.setUsername("username2");
        expiredPassword2.setPlainPassword("password2");
        expiredPassword2.setExpiration(new Date(System.currentTimeMillis() - 20000));
        final List<TemporaryPassword> expiredPasswords = new ArrayList<>();
        expiredPasswords.add(expiredPassword1);
        expiredPasswords.add(expiredPassword2);
        Mockito.when(temporaryPasswordRepository.findAll()).thenReturn(expiredPasswords);

        temporaryPasswordService.removeExpired();

        Mockito.verify(temporaryPasswordRepository, Mockito.times(1)).delete(expiredPassword1);
        Mockito.verify(temporaryPasswordRepository, Mockito.times(1)).delete(expiredPassword2);
    }


    @Test
    @DisplayName("Should remove specific temporary password by username")
    void shouldRemoveTemporaryPasswordByUsername() {
        final String username = "toBeRemovedUser";
        Mockito.when(temporaryPasswordRepository.findById(username)).thenReturn(Optional.of(new TemporaryPassword()));

        temporaryPasswordService.remove(username);

        Mockito.verify(temporaryPasswordRepository, Mockito.times(1)).deleteById(username);
    }


    @Test
    @DisplayName("Should return temporary password by username")
    void shouldReturnTemporaryPasswordByUsername() {
        final String username = "existingUser";
        final TemporaryPassword temporaryPassword = new TemporaryPassword();
        temporaryPassword.setUsername(username);
        temporaryPassword.setPlainPassword("password");
        temporaryPassword.setExpiration(new Date());
        Mockito.when(temporaryPasswordRepository.findById(username)).thenReturn(Optional.of(temporaryPassword));

        final Optional<TemporaryPassword> result = temporaryPasswordService.get(username);

        Assertions.assertThat(result).isPresent().contains(temporaryPassword);
    }


    @Test
    @DisplayName("Should return empty optional when getting non-existing temporary password")
    void shouldReturnEmptyOptionalWhenGettingNonExistingTemporaryPassword() {
        final String nonExistingUsername = "nonExistingUser";
        Mockito.when(temporaryPasswordRepository.findById(nonExistingUsername)).thenReturn(Optional.empty());

        final Optional<TemporaryPassword> result = temporaryPasswordService.get(nonExistingUsername);

        Assertions.assertThat(result).isEmpty();
    }


    @Test
    @DisplayName("Should throw error when removing non-existing temporary password")
    void shouldThrowResourceNotFoundExceptionWhenRemovingNonExistingTemporaryPassword() {
        final String nonExistingUsername = "nonExistingUser";
        Mockito.when(temporaryPasswordRepository.findById(nonExistingUsername)).thenReturn(Optional.empty());

        Assertions.assertThatThrownBy(() -> temporaryPasswordService.remove(nonExistingUsername)).isInstanceOf(
            ResourceNotFoundException.class);
    }
}

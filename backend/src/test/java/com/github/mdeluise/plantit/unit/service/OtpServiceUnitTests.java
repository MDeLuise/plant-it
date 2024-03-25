package com.github.mdeluise.plantit.unit.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.github.mdeluise.plantit.authentication.UserRepository;
import com.github.mdeluise.plantit.notification.otp.Otp;
import com.github.mdeluise.plantit.notification.otp.OtpGenerator;
import com.github.mdeluise.plantit.notification.otp.OtpRepository;
import com.github.mdeluise.plantit.notification.otp.OtpService;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@DisplayName("Unit tests for OtpService")
class OtpServiceUnitTests {
    @Mock
    private OtpRepository otpRepository;
    @Mock
    private OtpGenerator otpGenerator;
    @Mock
    private UserRepository userRepository;
    @InjectMocks
    private OtpService otpService;


    @Test
    @DisplayName("Should generate and save new OTP")
    void shouldGenerateAndSaveNewOtp() {
        final String email = "test@example.com";
        final Otp generatedOtp = new Otp();
        generatedOtp.setCode("123456");
        final Date expiration = new Date();
        generatedOtp.setExpiration(expiration);

        Mockito.when(otpGenerator.generateOTP(6, 30, email)).thenReturn(generatedOtp);
        Mockito.when(otpRepository.save(generatedOtp)).thenReturn(generatedOtp);

        final String result = otpService.generateNew(email);

        Assertions.assertThat(result).isEqualTo("123456");
        Mockito.verify(otpRepository).save(generatedOtp);
    }


    @Test
    @DisplayName("Should check existence and expiration of OTP then remove")
    void shouldCheckExistenceAndExpirationThenRemove() {
        final String otpCode = "123456";
        final Otp otp = new Otp();
        otp.setCode(otpCode);
        otp.setExpiration(new Date(System.currentTimeMillis() + 10000));

        Mockito.when(otpRepository.findByCode(otpCode)).thenReturn(Optional.of(otp));

        boolean result = otpService.checkExistenceAndExpirationThenRemove(otpCode);

        Assertions.assertThat(result).isTrue();
        Mockito.verify(otpRepository).delete(otp);
    }


    @Test
    @DisplayName("Should return false when checking non-existing OTP")
    void shouldReturnFalseWhenCheckingNonExistingOtp() {
        final String nonExistingOtpCode = "999999";
        Mockito.when(otpRepository.findById(nonExistingOtpCode)).thenReturn(Optional.empty());

        boolean result = otpService.checkExistenceAndExpirationThenRemove(nonExistingOtpCode);

        Assertions.assertThat(result).isFalse();
        Mockito.verify(otpRepository, Mockito.never()).delete(Mockito.any(Otp.class));
    }


    @Test
    @DisplayName("Should remove expired OTPs")
    void shouldRemoveExpiredOtps() {
        final Otp expiredOtp1 = new Otp();
        expiredOtp1.setCode("expired1");
        expiredOtp1.setExpiration(new Date(System.currentTimeMillis() - 10000));
        final Otp expiredOtp2 = new Otp();
        expiredOtp2.setCode("expired2");
        expiredOtp2.setExpiration(new Date(System.currentTimeMillis() - 20000));
        final List<Otp> expiredOtps = new ArrayList<>();
        expiredOtps.add(expiredOtp1);
        expiredOtps.add(expiredOtp2);

        Mockito.when(otpRepository.findAll()).thenReturn(expiredOtps);

        otpService.removeExpired();

        Mockito.verify(otpRepository, Mockito.times(1)).delete(expiredOtp1);
        Mockito.verify(otpRepository, Mockito.times(1)).delete(expiredOtp2);
    }


    @Test
    @DisplayName("Should remove specific OTP by code")
    void shouldRemoveOtpByCode() {
        final String otpCode = "123456";

        otpService.remove(otpCode);

        Mockito.verify(otpRepository, Mockito.times(1)).deleteByCode(otpCode);
    }
}

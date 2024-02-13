package com.github.mdeluise.plantit.notification.otp;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import org.springframework.stereotype.Component;

@Component
public class OtpGenerator {
    private final String otpChars = "0123456789";
    private final SecureRandom random = new SecureRandom();


    public Otp generateOTP(int length, int expireMins, String email) {
        final Otp otp = new Otp();
        otp.setEmail(email);
        final StringBuilder otpCode = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            otpCode.append(otpChars.charAt(random.nextInt(otpChars.length())));
        }
        otp.setCode(otpCode.toString());
        final LocalDateTime currentDateTime = LocalDateTime.now();
        final LocalDateTime newDateTime = currentDateTime.plusMinutes(expireMins);
        otp.setExpiration(Date.from(newDateTime.atZone(ZoneId.systemDefault()).toInstant()));
        return otp;
    }
}

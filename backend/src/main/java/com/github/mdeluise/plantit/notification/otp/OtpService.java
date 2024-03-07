package com.github.mdeluise.plantit.notification.otp;

import java.util.Date;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OtpService {
    private final OtpRepository otpRepository;
    private final OtpGenerator otpGenerator;
    private final Logger logger = LoggerFactory.getLogger(OtpService.class);


    @Autowired
    public OtpService(OtpRepository otpRepository, OtpGenerator otpGenerator) {
        this.otpRepository = otpRepository;
        this.otpGenerator = otpGenerator;
    }


    public boolean checkExistenceAndExpirationThenRemove(String otp) {
        final Optional<Otp> optionalOtp = otpRepository.findByCode(otp);
        if (optionalOtp.isEmpty()) {
            logger.debug("OTP {} does not exist", otp);
            return false;
        }
        final Otp retirevedOtp = optionalOtp.get();
        final boolean result = retirevedOtp.getExpiration().after(new Date());
        otpRepository.delete(retirevedOtp);
        return result;
    }


    public String generateNew(String email) {
        final Otp otp = otpGenerator.generateOTP(6, 30, email);
        logger.info("Generated OTP for email {} with expiration {}", email, otp.getExpiration());
        return otpRepository.save(otp).getCode();
    }


    public void removeExpired() {
        otpRepository.findAll().forEach(otp -> {
            if (otp.getExpiration().before(new Date())) {
                logger.debug("OTP {} expired at {}, removing...", otp.getCode(), otp.getExpiration());
                otpRepository.delete(otp);
            }
        });
    }


    public void remove(String otpCode) {
        otpRepository.deleteByCode(otpCode);
    }
}

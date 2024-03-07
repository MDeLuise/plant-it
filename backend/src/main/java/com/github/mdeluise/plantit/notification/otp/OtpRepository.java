package com.github.mdeluise.plantit.notification.otp;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OtpRepository extends JpaRepository<Otp, String> {
    Optional<Otp> findByCode(String code);

    void deleteByCode(String code);
}

package com.github.mdeluise.plantit.plant;

import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantRepository extends JpaRepository<Plant, Long> {
    Optional<Plant> findByInfoPersonalName(String name);

    Page<Plant> findAllByOwner(User user, Pageable pageable);

    Long countByOwner(User user);

    boolean existsByOwnerAndInfoPersonalName(User user, String personalName);
}

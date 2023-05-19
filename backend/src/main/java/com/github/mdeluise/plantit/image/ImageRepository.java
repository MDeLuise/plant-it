package com.github.mdeluise.plantit.image;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ImageRepository extends JpaRepository<EntityImageImpl, String> {
}

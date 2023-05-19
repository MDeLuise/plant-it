package com.github.mdeluise.plantit.diary;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DiaryRepository extends JpaRepository<Diary, Long> {
    Page<Diary> findAllByOwner(User user, Pageable pageable);

    Optional<Diary> findByOwnerAndTarget(User user, Plant plant);
}

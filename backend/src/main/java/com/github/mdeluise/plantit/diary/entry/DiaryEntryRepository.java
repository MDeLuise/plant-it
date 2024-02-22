package com.github.mdeluise.plantit.diary.entry;

import java.util.Optional;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.diary.Diary;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DiaryEntryRepository extends JpaRepository<DiaryEntry, Long> {
    Optional<DiaryEntry> findFirstByDiaryTargetAndType(Plant target, DiaryEntryType type);

    Page<DiaryEntry> findAllByDiaryOwner(User user, Pageable pageable);

    Page<DiaryEntry> findAllByDiaryOwnerAndDiary(User user, Diary diary, Pageable pageable);

    Long countByDiaryOwner(User user);

    Long countByDiaryOwnerAndDiaryTargetId(User authenticatedUser, Long plantId);

    Optional<DiaryEntry> findFirstByDiaryOwnerAndDiaryTargetIdAndTypeOrderByDateDesc(User user, Long id,
                                                                                     DiaryEntryType diaryEntryType);
}

package com.github.mdeluise.plantit.reminder;

import java.util.List;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReminderRepository extends JpaRepository<Reminder, Long> {
    List<Reminder> findAllByEnabledTrue();

    List<Reminder> findAllByTargetOwner(User user);

    List<Reminder> findAllByTargetAndTargetOwner(Plant target, User owner);
}

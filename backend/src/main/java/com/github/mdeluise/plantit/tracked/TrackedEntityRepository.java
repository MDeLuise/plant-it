package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.tracked.state.State;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrackedEntityRepository extends JpaRepository<AbstractTrackedEntity, Long> {
    Page<AbstractTrackedEntity> findAllByOwner(User user, Pageable pageable);

    Page<AbstractTrackedEntity> findAllByOwnerAndState(User user, State state, Pageable pageable);

    Page<AbstractTrackedEntity> findAllByOwnerAndType(User user, TrackedEntityType type, Pageable pageable);
}

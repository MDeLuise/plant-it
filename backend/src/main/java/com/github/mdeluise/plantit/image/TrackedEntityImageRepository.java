package com.github.mdeluise.plantit.image;

import com.github.mdeluise.plantit.tracked.AbstractTrackedEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TrackedEntityImageRepository extends JpaRepository<TrackedEntityImage, Long> {

    interface TrackedEntityImageIdView {
        Long getId();
    }

    List<TrackedEntityImageIdView> findAllByAbstractTrackedEntity(AbstractTrackedEntity abstractTrackedEntity);
}

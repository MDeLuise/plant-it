package com.github.mdeluise.plantit.image;

import java.util.List;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PlantImageRepository extends JpaRepository<PlantImage, String> {
    // Bugged due to the inheritance
    //List<PlantImage> findAllByPlantImageTarget(Plant target);

    @Query("SELECT i.id FROM PlantImage i WHERE i.target = ?1 ORDER BY i.savedAt DESC")
    List<String> findAllIdsPlantByImageTargetOrderBySavedAtDesc(Plant target);

    Integer countByTargetOwner(User user);
}

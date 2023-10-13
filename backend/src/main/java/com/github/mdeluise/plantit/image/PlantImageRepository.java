package com.github.mdeluise.plantit.image;

import java.util.List;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.plant.Plant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PlantImageRepository extends JpaRepository<PlantImage, String> {
    // Bugged due to the inheritance
    //List<PlantImage> findAllByPlantImageTarget(Plant target);

    @Query("SELECT i.id from PlantImage i where i.target = ?1")
    List<String> findAllIdsPlantByImageTarget(Plant target);

    Integer countByTargetOwner(User user);
}

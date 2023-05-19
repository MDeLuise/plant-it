package com.github.mdeluise.plantit.authorization.permission;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PermissionRepository extends JpaRepository<Permission, Long> {
    Optional<Permission> findByTypeAndResourceClassNameAndResourceId(
        com.github.mdeluise.plantit.authorization.permission.PType type,
        String resourceClassName,
        String resourceId);
}

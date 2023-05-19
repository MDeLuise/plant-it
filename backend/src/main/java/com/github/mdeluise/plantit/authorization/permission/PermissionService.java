package com.github.mdeluise.plantit.authorization.permission;

import com.github.mdeluise.plantit.authentication.User;
import com.github.mdeluise.plantit.authentication.UserRepository;
import com.github.mdeluise.plantit.exception.ResourceNotFoundException;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Optional;

@Service
public class PermissionService {
    private final com.github.mdeluise.plantit.authorization.permission.PermissionRepository permissionRepository;
    private final UserRepository userRepository;


    @Autowired
    public PermissionService(
        com.github.mdeluise.plantit.authorization.permission.PermissionRepository permissionRepository, UserRepository userRepository) {
        this.permissionRepository = permissionRepository;
        this.userRepository = userRepository;
    }


    public Permission getOrCreate(Permission permission) {
        Optional<Permission> alreadySavedPermission =
            permissionRepository.findByTypeAndResourceClassNameAndResourceId(
                permission.getType(), permission.getResourceClass(), permission.getResourceId()
            );
        return alreadySavedPermission.orElse(permissionRepository.save(permission));
    }


    public void remove(Permission permission) {
        Hibernate.initialize(permission.getUsers());
        for (User user : permission.getUsers()) {
            user.removePermission(permission);
            userRepository.save(user);
        }
        permissionRepository.delete(permission);
    }


    public Collection<Permission> getAll() {
        return permissionRepository.findAll();
    }


    public Permission get(Permission permission) {
        return permissionRepository.findByTypeAndResourceClassNameAndResourceId(permission.getType(),
                                                                                permission.getResourceClassName(),
                                                                                permission.getResourceId())
                                   .orElseThrow(() -> new ResourceNotFoundException(permission));
    }


    public void removeAll() {
        permissionRepository.deleteAll();
    }
}

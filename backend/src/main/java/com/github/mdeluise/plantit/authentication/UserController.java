package com.github.mdeluise.plantit.authentication;

import io.swagger.v3.oas.annotations.Hidden;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;

import java.util.Collection;
import java.util.List;

//@RestController
//@RequestMapping("/user")
@Tag(name = "User", description = "Endpoints for CRUD operations on users")
@Hidden
public class UserController {
    private final UserService userService;


    //@Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }


    @GetMapping
    @Operation(
        summary = "Get all Users", description = "Get all the User."
    )
    public ResponseEntity<Collection<User>> findAll() {
        List<User> allUsers = userService.getAll();
        return ResponseEntity.ok(allUsers);
    }


    @GetMapping("/{id}")
    @Operation(
        summary = "Get a single User", description = "Get the details of a given User, according to the `id` parameter."
    )
    public ResponseEntity<User> find(
        @Parameter(description = "The ID of the User on which to perform the operation") @PathVariable("id") Long id) {
        return new ResponseEntity<>(userService.get(id), HttpStatus.OK);
    }


    @PutMapping("/{id}")
    @Operation(
        summary = "Update a single User",
        description = "Update the details of a given User, according to the `id` parameter." +
                          "Please note that some fields may be readonly for integrity purposes."
    )
    public ResponseEntity<User> update(User updatedEntity, @Parameter(
        description = "The ID of the User on which to perform the operation"
    ) @PathVariable Long id) {
        return new ResponseEntity<>(userService.update(id, updatedEntity), HttpStatus.OK);
    }


    @DeleteMapping("/{id}")
    @Operation(
        summary = "Delete a single User", description = "Delete the given User, according to the `id` parameter."
    )
    public void remove(
        @Parameter(description = "The ID of the User on which to perform the operation") @PathVariable("id") Long id) {
        userService.remove(id);
    }
}

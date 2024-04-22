package com.github.mdeluise.plantit.authentication;

import javax.naming.AuthenticationException;

import com.github.mdeluise.plantit.authentication.payload.request.ChangeEmailRequest;
import com.github.mdeluise.plantit.authentication.payload.request.ChangePasswordRequest;
import com.github.mdeluise.plantit.authentication.payload.request.ChangeUsernameRequest;
import com.github.mdeluise.plantit.common.AuthenticatedUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@Tag(name = "User", description = "Endpoints for CRUD operations on users")
public class UserController {
    private final UserService userService;
    private final AuthenticatedUserService authenticatedUserService;
    private final UserDTOConverter userDtoConverter;


    @Autowired
    public UserController(UserService userService, AuthenticatedUserService authenticatedUserService,
                          UserDTOConverter userDtoConverter) {
        this.userService = userService;
        this.authenticatedUserService = authenticatedUserService;
        this.userDtoConverter = userDtoConverter;
    }


    @GetMapping
    @Operation(
        summary = "Get the User details", description = "Get the details of the authenticated User."
    )
    public ResponseEntity<UserDTO> getDetail() {
        final User result = authenticatedUserService.getAuthenticatedUser();
        return new ResponseEntity<>(userDtoConverter.convertToDTO(result), HttpStatus.OK);
    }


    @PutMapping("/_password")
    @Operation(
        summary = "Update a User's password", description = "Update the password of the authenticated User"
    )
    public ResponseEntity<String> updatePassword(@RequestBody ChangePasswordRequest changePasswordRequest)
        throws AuthenticationException {
        final Long idOfUserToUpdate = authenticatedUserService.getAuthenticatedUser().getId();
        userService.updatePassword(idOfUserToUpdate, changePasswordRequest.currentPassword(),
                                   changePasswordRequest.newPassword()
        );
        return ResponseEntity.ok("updated");
    }


    @DeleteMapping
    @Operation(
        summary = "Delete a single User", description = "Delete the authenticated User."
    )
    public void remove() {
        final Long toRemove = authenticatedUserService.getAuthenticatedUser().getId();
        userService.remove(toRemove);
    }


    @PutMapping("/_username")
    @Operation(
        summary = "Update a user's username", description = "Update the username of the authenticated User"
    )
    public ResponseEntity<String> updateUsername(@RequestBody ChangeUsernameRequest changeUsernameRequest)
        throws AuthenticationException {
        final Long idOfUserToUpdate = authenticatedUserService.getAuthenticatedUser().getId();
        userService.updateUsername(
            idOfUserToUpdate, changeUsernameRequest.password(), changeUsernameRequest.newUsername());
        return ResponseEntity.ok("updated");
    }


    @PutMapping("/_email")
    @Operation(
        summary = "Update a user's email", description = "Update the email of the authenticated User"
    )
    public ResponseEntity<String> updateEmail(@RequestBody ChangeEmailRequest changeEmailRequest)
        throws AuthenticationException {
        final Long idOfUserToUpdate = authenticatedUserService.getAuthenticatedUser().getId();
        userService.updateEmail(idOfUserToUpdate, changeEmailRequest.password(), changeEmailRequest.newEmail());
        return ResponseEntity.ok("updated");
    }
}

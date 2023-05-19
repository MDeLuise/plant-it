package com.github.mdeluise.plantit.authentication;

import com.github.mdeluise.plantit.authentication.payload.request.LoginRequest;
import com.github.mdeluise.plantit.authentication.payload.request.SignupRequest;
import com.github.mdeluise.plantit.authentication.payload.response.MessageResponse;
import com.github.mdeluise.plantit.authentication.payload.response.UserInfoResponse;
import com.github.mdeluise.plantit.exception.MaximumNumberOfUsersReachedExceptions;
import com.github.mdeluise.plantit.security.jwt.JwtTokenInfo;
import com.github.mdeluise.plantit.security.jwt.JwtWebUtil;
import com.github.mdeluise.plantit.security.services.UserDetailsImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/authentication")
@Tag(name = "Authentication", description = "Endpoints for authentication")
public class AuthController {
    private final AuthenticationManager authManager;
    private final JwtWebUtil jwtWebUtil;
    private final UserService userService;
    private final int maxAllowedUsers;


    @Autowired
    public AuthController(AuthenticationManager authManager, JwtWebUtil jwtWebUtil, UserService userService,
                          @Value("${users.max}") int maxAllowedUsers) {
        this.authManager = authManager;
        this.jwtWebUtil = jwtWebUtil;
        this.userService = userService;
        this.maxAllowedUsers = maxAllowedUsers;
    }


    @PostMapping("/login")
    @Operation(
        summary = "Username and password login",
        description = "Login using username and password."
    )
    @SecurityRequirements()
    public ResponseEntity<UserInfoResponse> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(loginRequest.username(), loginRequest.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        JwtTokenInfo jwtCookie = jwtWebUtil.generateJwt(userDetails);

        return ResponseEntity.ok()
                             .body(new UserInfoResponse(userDetails.getId(), userDetails.getUsername(), jwtCookie));
    }


    @PostMapping("/signup")
    @Operation(
        summary = "Signup",
        description = "Create a new account."
    )
    @SecurityRequirements()
    public ResponseEntity<MessageResponse> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (maxAllowedUsers > 0 && userService.count() >= maxAllowedUsers) {
            throw new MaximumNumberOfUsersReachedExceptions();
        }
        if (userService.existsByUsername(signUpRequest.username())) {
            return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
        }

        userService.save(signUpRequest.username(), signUpRequest.password());
        return ResponseEntity.ok(new MessageResponse("User registered successfully."));
    }


    @PostMapping("/refresh")
    @Operation(
        summary = "Refresh the authentication token",
        description = "Refresh the given authentication token."
    )
    public ResponseEntity<JwtTokenInfo> refreshAuthToken(HttpServletRequest httpServletRequest) {
        String expiredToken = jwtWebUtil.getJwtTokenFromRequest(httpServletRequest);
        return ResponseEntity.ok().body(jwtWebUtil.refreshToken(expiredToken));
    }
}

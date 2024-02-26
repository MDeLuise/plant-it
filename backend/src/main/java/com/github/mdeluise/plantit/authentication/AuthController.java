package com.github.mdeluise.plantit.authentication;

import com.github.mdeluise.plantit.authentication.payload.request.LoginRequest;
import com.github.mdeluise.plantit.authentication.payload.request.SignupRequest;
import com.github.mdeluise.plantit.authentication.payload.response.MessageResponse;
import com.github.mdeluise.plantit.authentication.payload.response.UserInfoResponse;
import com.github.mdeluise.plantit.exception.MaximumNumberOfUsersReachedExceptions;
import com.github.mdeluise.plantit.notification.email.EmailException;
import com.github.mdeluise.plantit.notification.email.EmailService;
import com.github.mdeluise.plantit.notification.otp.OtpService;
import com.github.mdeluise.plantit.notification.password.TemporaryPasswordService;
import com.github.mdeluise.plantit.security.jwt.JwtTokenInfo;
import com.github.mdeluise.plantit.security.jwt.JwtWebUtil;
import com.github.mdeluise.plantit.security.services.UserDetailsImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PathVariable;
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
    private final EmailService emailService;
    private final OtpService otpService;
    private final TemporaryPasswordService temporaryPasswordService;
    private final Logger logger = LoggerFactory.getLogger(AuthController.class);


    @Autowired
    @SuppressWarnings("ParameterNumber")
    public AuthController(AuthenticationManager authManager, JwtWebUtil jwtWebUtil, UserService userService,
                          @Value("${users.max}") int maxAllowedUsers, EmailService emailService,
                          OtpService otpService, TemporaryPasswordService temporaryPasswordService) {
        this.authManager = authManager;
        this.jwtWebUtil = jwtWebUtil;
        this.userService = userService;
        this.maxAllowedUsers = maxAllowedUsers;
        this.emailService = emailService;
        this.otpService = otpService;
        this.temporaryPasswordService = temporaryPasswordService;
    }


    @PostMapping("/login")
    @Operation(
        summary = "Username and password login", description = "Login using username and password."
    )
    @SecurityRequirements()
    public ResponseEntity<UserInfoResponse> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        final Authentication authentication = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(loginRequest.username(), loginRequest.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);

        final UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        final JwtTokenInfo jwtCookie = jwtWebUtil.generateJwt(userDetails);
        final UserInfoResponse response =
            new UserInfoResponse(userDetails.getId(), userDetails.getUsername(), jwtCookie);
        return ResponseEntity.ok().body(response);
    }


    @PostMapping("/signup")
    @Operation(
        summary = "Signup", description = "Create a new account."
    )
    @SecurityRequirements()
    public ResponseEntity<MessageResponse> registerUser(@Valid @RequestBody SignupRequest signUpRequest)
        throws EmailException {
        if (maxAllowedUsers > 0 && userService.count() >= maxAllowedUsers) {
            throw new MaximumNumberOfUsersReachedExceptions();
        }
        if (userService.existsByUsername(signUpRequest.username())) {
            return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
        }

        if (emailService.isEnabled()) {
            emailService.sendOtpMessage(signUpRequest.username(), signUpRequest.email());
            return ResponseEntity.accepted().body(new MessageResponse("Signup request pending verification"));
        }

        userService.save(signUpRequest.username(), signUpRequest.password(), signUpRequest.email());
        return ResponseEntity.ok(new MessageResponse("User registered successfully."));
    }


    @PostMapping("/signup/otp/{otpCode}")
    @Operation(
        summary = "Signup with OTP code", description = "Create a new account using a provided OTP code."
    )
    @SecurityRequirements()
    public ResponseEntity<MessageResponse> registerUserWithOTP(@Valid @RequestBody SignupRequest signUpRequest,
                                                               @PathVariable String otpCode) {
        if (maxAllowedUsers > 0 && userService.count() >= maxAllowedUsers) {
            throw new MaximumNumberOfUsersReachedExceptions();
        }
        if (userService.existsByUsername(signUpRequest.username())) {
            return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
        }

        if (otpService.checkExistenceAndExpirationThenRemove(otpCode)) {
            userService.save(signUpRequest.username(), signUpRequest.password(), signUpRequest.email());
            return ResponseEntity.ok(new MessageResponse("User registered successfully."));
        }
        final String errorMessage =
            "Your OTP code is either invalid or has expired. Please ensure that you have entered the correct code and" +
                " try again. If you believe this is an error, you can request a new OTP code by initiating the signup" +
                " process again";
        return ResponseEntity.badRequest().body(new MessageResponse(errorMessage));
    }


    @PostMapping("/refresh")
    @Operation(
        summary = "Refresh the authentication token", description = "Refresh the given authentication token."
    )
    public ResponseEntity<JwtTokenInfo> refreshAuthToken(HttpServletRequest httpServletRequest) {
        final String expiredToken = jwtWebUtil.getJwtTokenFromRequest(httpServletRequest);
        return ResponseEntity.ok().body(jwtWebUtil.refreshToken(expiredToken));
    }


    @PostMapping("/password/reset/{username}")
    @Operation(
        summary = "Initiates the password reset process",
        description = "Start the process of resetting the user password"
    )
    public ResponseEntity<String> resetPassword(@PathVariable String username) throws EmailException {
        if (!emailService.isEnabled()) {
            final String temporaryPassword = temporaryPasswordService.generateNew(username);
            logger.info("Temporary password for user {} is {}. Login with this temporary password.", username,
                        temporaryPassword
            );
            return ResponseEntity.ok(
                "Password reset instructions have been printed into the server log. Contact the administrator in " +
                    "order to get it if needed.");
        }
        final User user = userService.get(username);
        emailService.sendTemporaryPasswordMessage(username, user.getEmail());
        return ResponseEntity.ok("Password reset instructions have been sent to your email address.");
    }
}

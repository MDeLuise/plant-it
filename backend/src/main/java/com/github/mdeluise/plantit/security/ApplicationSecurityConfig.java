package com.github.mdeluise.plantit.security;

import com.github.mdeluise.plantit.security.apikey.ApiKeyFilter;
import com.github.mdeluise.plantit.security.jwt.JwtTokenFilter;
import com.github.mdeluise.plantit.security.services.PasswordUserDetailsService;
import com.github.mdeluise.plantit.security.services.TemporaryPasswordUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@EnableWebSecurity
@Configuration
public class ApplicationSecurityConfig {
    private final JwtTokenFilter jwtTokenFilter;
    private final ApiKeyFilter apiKeyFilter;


    @Autowired
    public ApplicationSecurityConfig(JwtTokenFilter jwtTokenFilter, ApiKeyFilter apiKeyFilter) {
        this.jwtTokenFilter = jwtTokenFilter;
        this.apiKeyFilter = apiKeyFilter;
    }


    @Bean
    public AuthenticationProvider passwordAuthProvider(PasswordUserDetailsService passwordUserDetailsService) {
        final DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(passwordUserDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }


    @Bean
    public AuthenticationProvider temporaryPasswordAuthProvider(
        TemporaryPasswordUserDetailsService temporaryPasswordUserDetailsService) {
        final DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(temporaryPasswordUserDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }


    @Bean
    @SuppressWarnings("LineLength")
    public AuthenticationManager authManager(HttpSecurity http, AuthenticationProvider passwordAuthProvider,
                                             AuthenticationProvider temporaryPasswordAuthProvider) throws Exception {
        return http.getSharedObject(AuthenticationManagerBuilder.class).authenticationProvider(passwordAuthProvider)
                   .authenticationProvider(temporaryPasswordAuthProvider).parentAuthenticationManager(null) // see https://stackoverflow.com/questions/27956378/infinte-loop-when-bad-credentials-are-entered-in-spring-security-form-login
                   .build();
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }


    @Bean
    public SecurityFilterChain configure(HttpSecurity http, AuthenticationManager authenticationManager)
        throws Exception {
        final String[] authWhitelist = {
            // REST authentication endpoint
            "/authentication/**",
            "/info/**",
            // Swagger UI v3 (OpenAPI)
            "/v3/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/webjars/swagger-ui/**",
            // h2 endpoint
            "/",
            "/h2-console/**"
        };

        http.cors();
        http.csrf()
            .disable();
        http.sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        http.authorizeHttpRequests()
            .requestMatchers(authWhitelist)
            .permitAll()
            .anyRequest()
            .authenticated();

        http.headers()
            .frameOptions()
            .sameOrigin();
        // http.csrf().ignoringRequestMatchers("/api/h2-console/**");

        http.authenticationManager(authenticationManager);

        http.addFilterBefore(jwtTokenFilter, UsernamePasswordAuthenticationFilter.class);

        http.addFilterBefore(apiKeyFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }


    @Bean
    public WebMvcConfigurer corsConfigurer(@Value("${server.cors.allowed-origins}") String allowedOrigins) {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins(allowedOrigins)
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTION");
            }
        };
    }
}

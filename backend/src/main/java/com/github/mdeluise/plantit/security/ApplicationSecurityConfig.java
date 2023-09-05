package com.github.mdeluise.plantit.security;

import com.github.mdeluise.plantit.security.apikey.ApiKeyFilter;
import com.github.mdeluise.plantit.security.jwt.JwtTokenFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
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
    private final UserDetailsService userDetailsService;
    private final ApiKeyFilter apiKeyFilter;


    @Autowired
    public ApplicationSecurityConfig(UserDetailsService userDetailsService,
                                     JwtTokenFilter jwtTokenFilter, ApiKeyFilter apiKeyFilter) {
        this.userDetailsService = userDetailsService;
        this.jwtTokenFilter = jwtTokenFilter;
        this.apiKeyFilter = apiKeyFilter;
    }


    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }


    @Bean
    public AuthenticationManager authenticationManager(
        AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }


    @Bean
    public SecurityFilterChain configure(HttpSecurity http) throws Exception {
        final String[] AUTH_WHITELIST = {
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
        http.csrf().disable();
        http.sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        http.authorizeHttpRequests()
            .requestMatchers(AUTH_WHITELIST).permitAll()
            .anyRequest().authenticated();

        http.headers().frameOptions().sameOrigin();
        // http.csrf().ignoringRequestMatchers("/api/h2-console/**");

        http.authenticationProvider(authenticationProvider());

        http.addFilterBefore(
            jwtTokenFilter, UsernamePasswordAuthenticationFilter.class);

        http.addFilterBefore(
            apiKeyFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }


    @Bean
    @Profile("dev")
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

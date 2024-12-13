package com.devsecops;

import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@EnableWebSecurity
public class WebSecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        //http.csrf(csrf -> csrf.disable());
        // otherwise integration tests fail.The issue arises because Spring Security is enabled,
        // and even though you haven't explicitly configured authentication, the default behavior of
        // Spring Security requires some form of authorization for all endpoints.
        http.csrf(csrf -> csrf.disable()) // Disable CSRF for simplicity in this context
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/increment/**").permitAll() // Allow public access to specific endpoints
                        .anyRequest().permitAll() // Require authentication for other endpoints
                );
        return http.build();
    }
}
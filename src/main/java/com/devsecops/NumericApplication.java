package com.devsecops;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@SpringBootApplication
public class NumericApplication {

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.authorizeHttpRequests(security -> security
						.requestMatchers("/increment/**").permitAll()
				.anyRequest().authenticated());

		return http.build();
	}

	public static void main(String[] args) {
		SpringApplication.run(NumericApplication.class, args);
	}

}

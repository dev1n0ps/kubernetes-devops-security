package com.devsecops;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class WebSecurityConfigTest {

    @Autowired
    private ApplicationContext applicationContext;

    @Test
    void testSecurityFilterChainBeanExists() {
        // Check that the SecurityFilterChain bean is present in the context
        SecurityFilterChain securityFilterChain = applicationContext.getBean(SecurityFilterChain.class);
        assertThat(securityFilterChain).isNotNull();
    }

    @Test
    void testWebSecurityConfigAnnotation() {
        // Ensure that @EnableWebSecurity is present on the class
        EnableWebSecurity annotation = WebSecurityConfig.class.getAnnotation(EnableWebSecurity.class);
        assertThat(annotation).isNotNull();
    }
}


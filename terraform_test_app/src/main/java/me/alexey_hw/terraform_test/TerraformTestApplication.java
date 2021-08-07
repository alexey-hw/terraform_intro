package me.alexey_hw.terraform_test;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories
//@EntityScan("me.alexey_hw.terraform_test")
public class TerraformTestApplication {

	public static void main(String[] args) {
		SpringApplication.run(TerraformTestApplication.class, args);
	}

}

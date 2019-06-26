package mulesoft.performance.corepaas;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class PerfServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(PerfServiceApplication.class, args);
	}

}

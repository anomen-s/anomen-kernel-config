#include <gpiod.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#define GPIO_CHIP   "/dev/gpiochip0"  // GPIO chip device
#define GPIO_LINE   25  // GPIO pin number

// chatgpt

int background_task() {
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int value = 0;

    // Open GPIO chip
    chip = gpiod_chip_open(GPIO_CHIP);
    if (!chip) {
        perror("Failed to open GPIO chip");
        return 1;
    }

    // Get GPIO line
    line = gpiod_chip_get_line(chip, GPIO_LINE);
    if (!line) {
        perror("Failed to get GPIO line");
        gpiod_chip_close(chip);
        return 1;
    }

    // Request GPIO line as output
    if (gpiod_line_request_output(line, "gpio_blink25", 0) < 0) {
        perror("Failed to set GPIO line as output");
        gpiod_chip_close(chip);
        return 1;
    }

    // Toggle GPIO every second
    while (1) {
        value = !value;  // Toggle value (0 -> 1, 1 -> 0)
        gpiod_line_set_value(line, value);
        // printf("GPIO %d set to %d\n", GPIO_LINE, value);
        sleep(1);
    }

    // Cleanup (unreachable in infinite loop, but good practice)
    gpiod_line_release(line);
    gpiod_chip_close(chip);
    
    return 0;
}


int main() {
    pid_t pid = fork();
    
    if (pid < 0) {
        perror("Fork failed");
        exit(1);
    }
    
    if (pid > 0) {
        // Parent process exits immediately
        printf("Background task started. Parent process exiting.\n");
        exit(0);
    }
    
    // Child process runs the background task
    setsid(); // Create a new session to detach from terminal
    background_task();
    
    return 0;
}

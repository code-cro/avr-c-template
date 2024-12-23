# Microcontroller and Clock Frequency
MCU = atmega328p
F_CPU = 16000000UL

# Compiler and Flags
CC = avr-gcc
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os

# Object Copy for HEX File Generation
OBJCOPY = avr-objcopy

# avrdude Configuration
AVRDUDE = avrdude
AVRDUDEFLAGS = -c arduino -p $(MCU) -P /dev/ttyUSB0 -b 115200

# Project Settings
TARGET = main
SRC_DIR = src
BUILD_DIR = build

# Source Files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

# Rules
all: $(TARGET).hex

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).elf: $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

upload: all
	$(AVRDUDE) $(AVRDUDEFLAGS) -U flash:w:$(TARGET).hex:i

clean:
	rm -rf $(BUILD_DIR) $(TARGET).elf $(TARGET).hex

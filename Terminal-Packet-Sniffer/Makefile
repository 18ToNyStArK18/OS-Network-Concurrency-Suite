# Compiler
CC = gcc

# Compiler flags for warnings and debugging
CFLAGS = -Wall -g

# Libraries to link against (THIS IS THE IMPORTANT PART)
LIBS = -lpcap

# The name of the final executable
EXECUTABLE = cshark

# Find all C source files
SOURCES = $(wildcard *.c)
OBJECTS = $(SOURCES:.c=.o)

# Default target
all: $(EXECUTABLE)

# The linking rule - notice the $(LIBS) at the end
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(EXECUTABLE) $(OBJECTS) $(LIBS)

# Rule to compile .c files into .o files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Cleanup rule
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

.PHONY: all clean



HIPCC := hipcc
#SRC ?= vector_add.hip
SRC ?= normalized_vector.hip
TARGET := $(basename $(SRC))

#CXXFLAGS := -O2

.PHONY: all run clean

all: $(TARGET) run

$(TARGET): $(SRC)
	mkdir -p target
	$(HIPCC) $(CXXFLAGS) -o target/$@ $<

run: $(TARGET)
	./target/$(TARGET)

clean:
	rm -f $(TARGET)

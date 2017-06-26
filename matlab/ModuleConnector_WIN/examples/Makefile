OS := $(shell uname -s)
$(info OS: $(OS))

GXX_FLAGS += --std=gnu++11 -Wall -Werror

ifeq ($(OS),$(filter $(OS),Linux Darwin))
        ifeq ($(OS),Linux)
		MODULE_CONNECTOR_LIB=../lib/libModuleConnector64.so
        else # Mac
		MODULE_CONNECTOR_LIB=../lib/libModuleConnector64.dylib
        endif
else # Windows
	MODULE_CONNECTOR_LIB=../lib/libModuleConnector64.dll
endif

.PHONY: all
all: ping ping_x4m300 record read_recording playback_recording presence_single
	echo "done"

ping_x4m300: ping_x4m300.cpp ${MODULE_CONNECTOR_LIB}
	g++ ${GXX_FLAGS} -I../include $^ -o $@

presence_single: presence_single.cpp ${MODULE_CONNECTOR_LIB}
	g++ ${GXX_FLAGS} -I../include $^ -o $@

ping: ping.o ${MODULE_CONNECTOR_LIB}
	g++ $^ -o $@

ping.o: ping.cpp
	g++ ${GXX_FLAGS} -I../include -c $< -o $@

record: record.o ${MODULE_CONNECTOR_LIB}
	g++ $^ -o $@

record.o: record.cpp
	g++ ${GXX_FLAGS} -I../include -c $< -o $@

read_recording: read_recording.o ${MODULE_CONNECTOR_LIB}
	g++ $^ -o $@

read_recording.o: read_recording.cpp
	g++ ${GXX_FLAGS} -I../include -c $< -o $@

playback_recording: playback_recording.o ${MODULE_CONNECTOR_LIB}
	g++ $^ -o $@

playback_recording.o: playback_recording.cpp
	g++ ${GXX_FLAGS} -I../include -c $< -o $@

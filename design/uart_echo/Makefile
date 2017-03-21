PROJECT_NAME:=uart_echo

SOURCES:=uart_echo.v uart.v uart_tx.v uart_rx.v
TOP_FILE:=uart_echo_iceZUM_alhambra.v
TOP_MODULE:=$(patsubst %.v,%,$(TOP_FILE))

ROOT_DIR:=../..
REPORT_DIR:=$(ROOT_DIR)/$(UART_ECHO_REPORT_DIR)
NET_DIR:=$(ROOT_DIR)/$(UART_ECHO_NET_DIR)
BITFILE_DIR:=$(ROOT_DIR)/$(UART_ECHO_BIT_DIR)
PLACE_ROUTE_DIR:=$(ROOT_DIR)/$(UART_ECHO_ROUTE_DIR)
COMPILE_DIR:=$(ROOT_DIR)/$(COMPILE_DIR)

ICE40_SYNTH_REPORT:=synthesis_ice40.txt
ICE40_PLACE_REPORT:=place_route_ice40.txt
ICE40_ASC:=route_ice40.asc
ICE40_BIT:=bitfile_ice40.bin
COMPILED_FILE:=$(PROJECT_NAME).comp

COMPILED_FILES:=$(patsubst %.v,$(COMPILE_DIR)/%.comp,$(SOURCES))

################################################################################
# Compilation
################################################################################
compile: $(COMPILED_FILES)

$(COMPILE_DIR)/%.comp: %.v
	@echo "	COMPILE $<"
	@iverilog $< -y . -o $@ 


################################################################################
# Physical implementation
################################################################################
all_ice40: synthesis_ice40 place_route_ice40 bitfile_ice40

synthesis_ice40: 
	@echo "	SYNTHESIZE $(PROJECT_NAME) for iceZUM alhambra board"	
	@yosys -p 'synth_ice40 -blif $(NET_DIR)/ice40.blif -top $(TOP_MODULE)' $(TOP_FILE) $(SOURCES) > $(REPORT_DIR)/$(ICE40_SYNTH_REPORT)

place_route_ice40:
	@echo "	PLACE & ROUTE $(PROJECT_NAME) for iceZUM alhambra board"
	@arachne-pnr -p constraints/icezum_alhambra.pcf $(NET_DIR)/ice40.blif -o $(PLACE_ROUTE_DIR)/$(ICE40_ASC) 2> $(REPORT_DIR)/$(ICE40_PLACE_REPORT)

bitfile_ice40:
	@echo "	BITFILE of $(PROJECT_NAME) for iceZUM alhambra board"
	@icepack $(PLACE_ROUTE_DIR)/$(ICE40_ASC) $(BITFILE_DIR)/$(ICE40_BIT)

clean_files:
	@rm -rf $(REPORT_DIR)/*.txt
	@rm -rf $(NET_DIR)/*.v $(NET_DIR)/*.blif
	@rm -rf $(PLACE_ROUTE_DIR)/*.asc
	@rm -rf $(BITFILE_DIR)/*.bin

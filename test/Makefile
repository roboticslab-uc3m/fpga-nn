# Source files and projects must be specified here
SOURCES:=perceptron_top_tb.v perceptron_comm_controller_tb.v uart_echo_tb.v uart_tb.v uart_tx_tb.v uart_rx_tb.v perceptron_tb.v
PROJECTS:=uart_echo uart perceptron

ROOT_DIR:=..
SIM_DIR:=$(ROOT_DIR)/$(SIMULATION_DIR)
TB_COMPILE_DIR:=$(ROOT_DIR)/$(TESTBENCH_COMPILE_DIR)
DESIGN_DIR:=$(ROOT_DIR)/$(DESIGN_DIR)

# Contains all the files in SOURCES with the appropiate path
COMPILED_FILES:=$(patsubst %.v,$(TB_COMPILE_DIR)/%.comp,$(SOURCES))

# Used to specify "libraries" so iverilog can find the referenced sources
# contains a list of paths in the form "-y <path1> -y <path2>..."
PROJECTS_PATHS:=$(patsubst %,-y $(DESIGN_DIR)/%,$(PROJECTS))


compile: $(COMPILED_FILES)

$(TB_COMPILE_DIR)/%.comp: %.v
	@echo "	COMPILE $<"
	@iverilog $< $(PROJECTS_PATHS) -o $@

clean_files:
	@rm -rf $(REPORT_DIR)/*.txt
	@rm -rf $(NET_DIR)/*.v $(NET_DIR)/*.blif
	@rm -rf $(PLACE_ROUTE_DIR)/*.asc
	@rm -rf $(BITFILE_DIR)/*.bin


export XILINX_TOOLS_DIR:=/opt/Xilinx/ISE/14.7/ISE_DS/ISE/bin/lin64

export XST:=$(XILINX_TOOLS_DIR)/xst
export NGDBUILD:=$(XILINX_TOOLS_DIR)/ngdbuild
export MAP:=$(XILINX_TOOLS_DIR)/map
export PAR:=$(XILINX_TOOLS_DIR)/par
export BITGEN:=$(XILINX_TOOLS_DIR)/bitgen

export SIMULATION_DIR:=sim_config
export COMPILE_DIR:=build/compile
export DESIGN_DIR:=design
export TESTBENCH_COMPILE_DIR:=$(COMPILE_DIR)/testbench
export BUILD_DIR:=build

################################################################################
# Xilinx design flow directory 
# (so there are no xilinx flow files created elsewhere)
################################################################################
export XIL_FLOW_DIR:=build/xilinx
export ROOT_DIR_FROM_XIL:=../..


################################################################################
# Project related definitions
################################################################################
export PERCEPTRON_BUILD_DIR:=build/perceptron
export PERCEPTRON_REPORT_DIR:=$(PERCEPTRON_BUILD_DIR)/report
export PERCEPTRON_BIT_DIR:=$(PERCEPTRON_BUILD_DIR)/bitfile
export PERCEPTRON_NET_DIR:=$(PERCEPTRON_BUILD_DIR)
export PERCEPTRON_ROUTE_DIR:=$(PERCEPTRON_BUILD_DIR)
export PERCEPTRON_PROJECT_DIR:=$(DESIGN_DIR)/perceptron/project
export PERCEPTRON_SOURCE_DIR:=$(DESIGN_DIR)/perceptron

export UART_BUILD_DIR:=build/uart
export UART_REPORT_DIR:=$(UART_BUILD_DIR)/report
export UART_BIT_DIR:=$(UART_BUILD_DIR)/bitfile
export UART_NET_DIR:=$(UART_BUILD_DIR)
export UART_ROUTE_DIR:=$(UART_BUILD_DIR)
export UART_PROJECT_DIR:=$(DESIGN_DIR)/uart/project
export UART_SOURCE_DIR:=$(DESIGN_DIR)/uart

export UART_ECHO_BUILD_DIR:=build/uart_echo
export UART_ECHO_REPORT_DIR:=$(UART_ECHO_BUILD_DIR)/report
export UART_ECHO_BIT_DIR:=$(UART_ECHO_BUILD_DIR)/bitfile
export UART_ECHO_NET_DIR:=$(UART_ECHO_BUILD_DIR)
export UART_ECHO_ROUTE_DIR:=$(UART_ECHO_BUILD_DIR)
export UART_ECHO_PROJECT_DIR:=$(DESIGN_DIR)/uart_echo/project
export UART_ECHO_SOURCE_DIR:=$(DESIGN_DIR)/uart_echo

help:
	@echo ""
	@echo " The available commands are:"
	@echo "	- clean			--> Remove the build hierarchy complete"
	@echo "	- compile_tests		--> Compile all the testbenches"
	@echo "	- simulate_<test>	--> Simulate <test> and show the result on gtkwave"
	@echo "	- <proyect>_icezum40	--> Generate the bitstream of <proyect> for the iceZUM alhambra board"
	@echo "	- <proyect>_spartan3e	--> Generate the bitstream of <proyect> for the digilent nexys 2 board"
	@echo ""
	@echo " <test> => Any file from the test directory"
	@echo " <proyect> => perceptron uart_echo"
	@echo ""

clean:
	@rm -rf $(BUILD_DIR)

compile_tests: | create_build_hierarchy
	@$(MAKE) -C test compile

simulate_%: 
	@$(MAKE) -C test $@
	

create_build_hierarchy:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(SIMULATION_DIR)
	@mkdir -p $(COMPILE_DIR)
	@mkdir -p $(TESTBENCH_COMPILE_DIR)
	@mkdir -p $(XIL_FLOW_DIR)

clean_compile:
	@rm -rf $(TESTBENCH_COMPILE_DIR)/*.comp
	@rm -rf $(COMPILE_DIR)/*.comp

clean_simulation:
	@rm -rf $(SIMULATION_DIR)/*

################################################################################
# Perceptron project
################################################################################
#perceptron_compile: | create_build_hierarchy
#	@$(MAKE) -C design/perceptron compile

perceptron_icezum40: | create_perceptron_hierarchy
	@$(MAKE) -C design/perceptron all_ice40

perceptron_xilinx7: | create_perceptron_hierarchy
	@$(MAKE) -C design/perceptron all_xil7

perceptron_spartan3e: | create_perceptron_hierarchy
	@$(MAKE) -C design/perceptron all_spartan3e

clean_perceptron:
	@rm -rf $(PERCEPTRON_BUILD_DIR)

create_perceptron_hierarchy: | create_build_hierarchy
	@mkdir -p $(PERCEPTRON_BUILD_DIR)
	@mkdir -p $(PERCEPTRON_REPORT_DIR)
	@mkdir -p $(PERCEPTRON_BIT_DIR)


################################################################################
# UART project
################################################################################
#uart_compile: | create_build_hierarchy
#	@$(MAKE) -C design/uart compile

#uart_icezum40: | create_uart_hierarchy
#	@$(MAKE) -C design/uart all_ice40

clean_uart:
	@rm -rf $(UART_BUILD_DIR)

create_uart_hierarchy: | create_build_hierarchy
	@mkdir -p $(UART_BUILD_DIR)
	@mkdir -p $(UART_REPORT_DIR)
	@mkdir -p $(UART_BIT_DIR)


################################################################################
# UART_echo project
################################################################################
#uart_compile: | create_build_hierarchy
#	@$(MAKE) -C design/uart compile

uart_echo_icezum40: | create_uart_echo_hierarchy
	@$(MAKE) -C design/uart_echo all_ice40

clean_uart_echo:
	@rm -rf $(UART_ECHO_BUILD_DIR)

create_uart_echo_hierarchy: | create_build_hierarchy
	@mkdir -p $(UART_ECHO_BUILD_DIR)
	@mkdir -p $(UART_ECHO_REPORT_DIR)
	@mkdir -p $(UART_ECHO_BIT_DIR)


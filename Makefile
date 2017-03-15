export SIMULATION_DIR:=build/simulation
export COMPILE_DIR:=build/compile
export DESIGN_DIR:=design
export TESTBENCH_COMPILE_DIR:=$(COMPILE_DIR)/testbench
export BUILD_DIR:=build

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


clean:
	@rm -rf $(BUILD_DIR)

compile_tests: | create_build_hierarchy
	@$(MAKE) -C test compile

simulate_all: | create_build_hierarchy
	

create_build_hierarchy:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(SIMULATION_DIR)
	@mkdir -p $(COMPILE_DIR)
	@mkdir -p $(TESTBENCH_COMPILE_DIR)

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

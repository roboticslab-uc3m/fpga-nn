export SIMULATION_DIR:=build/simulation

export PERCEPTRON_BUILD_DIR:=build/perceptron
export PERCEPTRON_REPORT_DIR:=$(PERCEPTRON_BUILD_DIR)/report
export PERCEPTRON_BIT_DIR:=$(PERCEPTRON_BUILD_DIR)/bitfile
export PERCEPTRON_NET_DIR:=$(PERCEPTRON_BUILD_DIR)
export PERCEPTRON_ROUTE_DIR:=$(PERCEPTRON_BUILD_DIR)
exprot PERCEPTRON_PROJECT_DIR:=design/perceptron/project
export PERCEPTRON_SOURCE_DIR:=design/perceptron

export UART_BUILD_DIR:=build/uart
export UART_REPORT_DIR:=$(UART_BUILD_DIR)/report
export UART_BIT_DIR:=$(UART_BUILD_DIR)/bitfile
export UART_NET_DIR:=$(UART_BUILD_DIR)
export UART_ROUTE_DIR:=$(UART_BUILD_DIR)
exprot UART_PROJECT_DIR:=design/uart/project
export UART_SOURCE_DIR:=design/uart


all: uart_icezum40 perceptron_icezum40


clean_all: uart_clean perceptron_clean


################################################################################
# Perceptron project
################################################################################

perceptron_simulation:
    $(MAKE) -C test perceptron

perceptron_icezum40: perceptron_clean_dir perceptron_create_build_dir
	$(MAKE) -C design/perceptron all_ice40

perceptron_clean:
	$(MAKE) -C design/perceptron clean

perceptron_clean_dir:
	@rm -rf $(PERCEPTRON_BUILD_DIR)

perceptron_create_build_dir:
	@mkdir $(PERCEPTRON_BUILD_DIR)
	@mkdir $(PERCEPTRON_REPORT_DIR)
	@mkdir $(PERCEPTRON_BIT_DIR)


################################################################################
# UART project
################################################################################

uart_icezum40: uart_clean_dir uart_create_build_dir
	$(MAKE) -C design/uart all_ice40

uart_clean:
	$(MAKE) -C design/uart clean

uart_clean_dir:
	@rm -rf $(UART_BUILD_DIR)

uart_create_build_dir:
	@mkdir $(UART_BUILD_DIR)
	@mkdir $(UART_REPORT_DIR)
	@mkdir $(UART_BIT_DIR)

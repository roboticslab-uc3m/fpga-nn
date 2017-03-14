export PERCEPTRON_BUILD_DIR:=build/perceptron
export PERCEPTRON_REPORT_DIR:=$(PERCEPTRON_BUILD_DIR)/report
export PERCEPTRON_BIT_DIR:=$(PERCEPTRON_BUILD_DIR)/bitfile
export PERCEPTRON_NET_DIR:=$(PERCEPTRON_BUILD_DIR)
export PERCEPTRON_ROUTE_DIR:=$(PERCEPTRON_BUILD_DIR)
exprot PERCEPTRON_PROJECT_DIR:=design/perceptron/project
export PERCEPTRON_SOURCE_DIR:=design/perceptron


all:

perceptron_icezum40: perceptron_clean_dir perceptron_create_build_dir
	$(MAKE) -C design/perceptron all_ice40



clean_all: perceptron_clean

perceptron_clean:
	$(MAKE) -C design/perceptron clean

perceptron_clean_dir:
	@rm -rf $(PERCEPTRON_BUILD_DIR)

perceptron_create_build_dir:
	@mkdir $(PERCEPTRON_BUILD_DIR)
	@mkdir $(PERCEPTRON_REPORT_DIR)
	@mkdir $(PERCEPTRON_BIT_DIR)

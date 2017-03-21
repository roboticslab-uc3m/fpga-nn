SOURCES:=uart_tx.v uart_rx.v
TOP_FILE:=uart_tx.v
TOP_MODULE:=$(patsubst %.v,%,$(TOP_FILE))

ROOT_DIR:=../..
REPORT_DIR:=$(ROOT_DIR)/$(UART_REPORT_DIR)
NET_DIR:=$(ROOT_DIR)/$(UART_NET_DIR)
BITFILE_DIR:=$(ROOT_DIR)/$(UART_BIT_DIR)
PLACE_ROUTE_DIR:=$(ROOT_DIR)/$(UART_ROUTE_DIR)
COMPILE_DIR:=$(ROOT_DIR)/$(COMPILE_DIR)

COMPILED_FILES:=$(patsubst %.v,$(COMPILE_DIR)/%.comp,$(SOURCES))

################################################################################
# Compilation
################################################################################
compile: $(COMPILED_FILES)

$(COMPILE_DIR)/%.comp: %.v
	@echo "	COMPILE $<"
	@iverilog $< -y . -o $@ 

clean_files:
	@rm -rf $(REPORT_DIR)/*.txt
	@rm -rf $(NET_DIR)/*.v $(NET_DIR)/*.blif
	@rm -rf $(PLACE_ROUTE_DIR)/*.asc
	@rm -rf $(BITFILE_DIR)/*.bin


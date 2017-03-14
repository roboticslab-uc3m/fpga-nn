SOURCES:=perceptron.v perceptron_iceZUM_alhambra.v
TOP_MODULE:=perceptron_iceZUM_alhambra

ROOT_DIR:=../..
REPORT_DIR:=$(ROOT_DIR)/$(PERCEPTRON_REPORT_DIR)
NET_DIR:=$(ROOT_DIR)/$(PERCEPTRON_NET_DIR)
BITFILE_DIR:=$(ROOT_DIR)/$(PERCEPTRON_BIT_DIR)
PLACE_ROUTE_DIR:=$(ROOT_DIR)/$(PERCEPTRON_ROUTE_DIR)

ICE40_SYNTH_REPORT:=synthesis_ice40.txt
ICE40_PLACE_REPORT:=place_route_ice40.txt
ICE40_ASC:=route_ice40.asc
ICE40_BIT:=bitfile_ice40.bin

all_ice40: synthesis_ice40 place_route_ice40 bitfile_ice40

synthesis_ice40: 
	yosys -p 'synth_ice40 -blif $(NET_DIR)/ice40.blif -top $(TOP_MODULE)' $(SOURCES) > $(REPORT_DIR)/$(ICE40_SYNTH_REPORT)

place_route_ice40:
	arachne-pnr -p constraints/icezum_alhambra.pcf $(NET_DIR)/ice40.blif -o $(PLACE_ROUTE_DIR)/$(ICE40_ASC) 2> $(REPORT_DIR)/$(ICE40_PLACE_REPORT)

bitfile_ice40:
	icepack $(PLACE_ROUTE_DIR)/$(ICE40_ASC) $(BITFILE_DIR)/$(ICE40_BIT)


clean_files:
	@rm -rf $(REPORT_DIR)/*.txt
	@rm -rf $(NET_DIR)/*.v $(NET_DIR)/*.blif
	@rm -rf $(PLACE_ROUTE_DIR)/*.asc
	@rm -rf $(BITFILE_DIR)/*.bin


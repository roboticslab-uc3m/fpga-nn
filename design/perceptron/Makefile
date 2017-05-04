PROJECT_NAME:=perceptron

SOURCES:=perceptron_top.v perceptron.v comm_controller.v uart.v uart_rx.v uart_tx.v
TOP_FILE:=perceptron_iceZUM_alhambra.v
TOP_MODULE:=$(patsubst %.v,%,$(TOP_FILE))

XIL_PRJ_FILE:=perceptron.prj
XIL_XST_FILE:=perceptron.xst

ROOT_DIR:=../..
REPORT_DIR:=$(ROOT_DIR)/$(PERCEPTRON_REPORT_DIR)
NET_DIR:=$(ROOT_DIR)/$(PERCEPTRON_NET_DIR)
BITFILE_DIR:=$(ROOT_DIR)/$(PERCEPTRON_BIT_DIR)
PLACE_ROUTE_DIR:=$(ROOT_DIR)/$(PERCEPTRON_ROUTE_DIR)
COMPILE_DIR:=$(ROOT_DIR)/$(COMPILE_DIR)

################################################################################
# Xilinx design flow directories
# (so there are no xilinx flow files created elsewhere)
################################################################################
XIL_FLOW_DIR:=$(ROOT_DIR)/$(XIL_FLOW_DIR)
SOURCE_DIR_FROM_XIL:=$(ROOT_DIR_FROM_XIL)/$(PERCEPTRON_SOURCE_DIR)


ICE40_SYNTH_REPORT:=synthesis_ice40.txt
ICE40_PLACE_REPORT:=place_route_ice40.txt
ICE40_TIME_REPORT:=time_analysis_ice40.txt
ICE40_ASC:=route_ice40.asc
ICE40_BIT:=bitfile_ice40.bit
COMPILED_FILE:=$(PROJECT_NAME).comp

XIL7_SYNTH_REPORT:=synthesis_xil7.txt
XIL7_PLACE_REPORT:=place_route_xil7.txt
XIL7_TIME_REPORT:=time_analysis_xil7.txt
XIL7_ASC:=route_xil7.asc
XIL7_BIT:=bitfile_xil7.bit
XIL7_COMPILED_FILE:=$(PROJECT_NAME).comp

SPARTAN3e_SYNTH_REPORT:=synthesis_spartan3e.txt
SPARTAN3e_PLACE_REPORT:=place_route_spartan3e.txt
SPARTAN3e_TIME_REPORT:=time_analysis_spartan3e.txt
SPARTAN3e_NGC:=netlist_spartan3e.ngc
SPARTAN3e_NGD:=netlist_spartan3e.ngd
SPARTAN3e_NCD:=route_spartan3e.ncd
SPARTAN3e_BIT:=bitfile_spartan3e.bit
SPARTAN3e_COMPILED_FILE:=$(PROJECT_NAME).comp

COMPILED_FILES:=$(patsubst %.v,$(COMPILE_DIR)/%.comp,$(SOURCES))


################################################################################
# Compilation
################################################################################
compile: $(COMPILED_FILES)

$(COMPILE_DIR)/%.comp: %.v
	@echo "	COMPILE $<"
	@iverilog $< -y . -o $@ 

################################################################################
# Physical implementation ice40
################################################################################
all_ice40: bitfile_ice40

synthesis_ice40: 
	@echo "	SYNTHESIZE $(PROJECT_NAME) for iceZUM alhambra board"	
	@yosys -p 'synth_ice40 -blif $(NET_DIR)/ice40.blif -top $(TOP_MODULE)' $(TOP_FILE) $(SOURCES) > $(REPORT_DIR)/$(ICE40_SYNTH_REPORT)
	@echo "Synthesis report usage:"
	@cat $(REPORT_DIR)/$(ICE40_SYNTH_REPORT) | tail -24 | head -n 13
	@echo "====================================================================="
	@echo ""

place_route_ice40:
	@echo "	PLACE & ROUTE $(PROJECT_NAME) for iceZUM alhambra board"
	@arachne-pnr -p constraints/icezum_alhambra.pcf $(NET_DIR)/ice40.blif -o $(PLACE_ROUTE_DIR)/$(ICE40_ASC) 2> $(REPORT_DIR)/$(ICE40_PLACE_REPORT)
	@echo "Place & Route report usage:"
	@cat $(REPORT_DIR)/$(ICE40_PLACE_REPORT) | grep "After packing:" -A 13
	@cat $(REPORT_DIR)/$(ICE40_PLACE_REPORT) | grep "After placement:" -A 13
	@echo "====================================================================="
	@echo ""

time_analisys_ice40:
	@echo "	TIME ANALISYS $(PROJECT_NAME) for iceZUM alhambra board"
	@icetime -d hx1k -t -p constraints/icezum_alhambra.pcf -r $(REPORT_DIR)/$(ICE40_TIME_REPORT) $(PLACE_ROUTE_DIR)/$(ICE40_ASC) >> /dev/null
	@echo "Time analysis:"
	@cat $(REPORT_DIR)/$(ICE40_TIME_REPORT) | tail -3 | head -n 2
	@echo "====================================================================="
	@echo ""

bitfile_ice40: synthesis_ice40 place_route_ice40 time_analisys_ice40
	@echo "	BITFILE of $(PROJECT_NAME) for iceZUM alhambra board"
	@icepack $(PLACE_ROUTE_DIR)/$(ICE40_ASC) $(BITFILE_DIR)/$(ICE40_BIT)



################################################################################
# Physical implementation Xilinx 7 series
################################################################################
all_xil7: synthesis_xil7

synthesis_xil7: 
	@echo "	SYNTHESIZE $(PROJECT_NAME) for xilinx 7 series fpga"	
	@yosys -p 'synth_xilinx -top $(TOP_MODULE)' $(TOP_FILE) $(SOURCES) > $(REPORT_DIR)/$(XIL7_SYNTH_REPORT)
	@echo "Synthesis report usage:"
	@cat $(REPORT_DIR)/$(XIL7_SYNTH_REPORT) | tail -24 | head -n 13
	@echo "====================================================================="
	@echo ""

	
	
################################################################################
# Physical implementation Digilent Nexys2 board (Spartan 3e)
################################################################################
all_spartan3e: bitfile_spartan3e

synthesis_spartan3e: prj_file xst_file
	@echo "	SYNTHESIZE $(PROJECT_NAME) for Digilent Nexys2 board (Spartan 3e)"
	@cd $(XIL_FLOW_DIR); $(XST) -ifn $(XIL_FLOW_DIR)/$(XIL_XST_FILE) -ofn $(SPARTAN3e_SYNTH_REPORT) -intstyle silent
	@cd $(XIL_FLOW_DIR); $(NGDBUILD) $(SPARTAN3e_NGC) $(SPARTAN3e_NGD) >> /dev/null
	@cp $(XIL_FLOW_DIR)/$(SPARTAN3e_NGD) $(NET_DIR)/$(SPARTAN3e_NGD)
	@cp $(XIL_FLOW_DIR)/$(SPARTAN3e_SYNTH_REPORT) $(REPORT_DIR)/$(SPARTAN3e_SYNTH_REPORT)
	@echo ""
	@echo "Synthesis usage report:"
	@cat $(REPORT_DIR)/$(SPARTAN3e_SYNTH_REPORT) | grep "Device utilization summary:" -A 13
	@echo "Synthesis timing report:"
	@cat $(REPORT_DIR)/$(SPARTAN3e_SYNTH_REPORT) | grep "Timing Summary:" -A 24
	@echo "====================================================================="
	@echo ""

place_route_spartan3e: synthesis_spartan3e
	@echo "	PLACE & ROUTE $(PROJECT_NAME) for Digilent Nexys2 board (Spartan 3e)"
	@cd $(XIL_FLOW_DIR); $(MAP) $(SPARTAN3e_NGD) -o _$(SPARTAN3e_NCD) >> /dev/null
	@cd $(XIL_FLOW_DIR); $(PAR) -intstyle silent _$(SPARTAN3e_NCD) $(SPARTAN3e_NCD)
	@cp $(XIL_FLOW_DIR)/$(SPARTAN3e_NCD) $(NET_DIR)/$(SPARTAN3e_NCD)
	@cp $(XIL_FLOW_DIR)/$(patsubst %.ncd,%.par,$(SPARTAN3e_NCD)) $(REPORT_DIR)/$(SPARTAN3e_PLACE_REPORT)

bitfile_spartan3e: place_route_spartan3e
	@echo "	BITFILE of $(PROJECT_NAME) for Digilent Nexys2 board (Spartan 3e)"
	@cd $(XIL_FLOW_DIR); $(BITGEN) $(SPARTAN3e_NCD) $(SPARTAN3e_BIT) >> /dev/null
	@cp $(XIL_FLOW_DIR)/$(SPARTAN3e_BIT) $(BITFILE_DIR)/$(SPARTAN3e_BIT)

xst_file:
	@echo "set -tmpdir $(XIL_FLOW_DIR)" 		   > $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "set -xsthdpdir $(XIL_FLOW_DIR)" 		  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "run" 								  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-ifn $(XIL_FLOW_DIR)/$(XIL_PRJ_FILE)"  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-ifmt mixed" 						  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-top $(TOP_MODULE)" 			          >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-ofn $(SPARTAN3e_NGC)"			 	  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-vlgincdir $(SOURCE_DIR_FROM_XIL)"	  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-ofmt NGC" 							  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-p xc3s500e-5-fg320" 				  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-opt_mode Speed" 					  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)
	@echo "-opt_level 1" 						  >> $(XIL_FLOW_DIR)/$(XIL_XST_FILE)

prj_file:
	@echo "verilog work $(TOP_FILE)" > $(XIL_FLOW_DIR)/$(XIL_PRJ_FILE)
	@$(foreach file, $(SOURCES), echo "verilog work $(file)" >> $(XIL_FLOW_DIR)/$(XIL_PRJ_FILE);)


clean_files:
	@rm -rf $(REPORT_DIR)/*.txt
	@rm -rf $(NET_DIR)/*.v $(NET_DIR)/*.blif
	@rm -rf $(PLACE_ROUTE_DIR)/*.asc
	@rm -rf $(BITFILE_DIR)/*.bin

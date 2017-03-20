# FPGA-NN
Neural Networks on FPGA

## About
This project aims to develop and evaluate neural networks for FPGAs. The designs are written in the verilog-2005 HDL lenguaje.

### Open FPGA development
Given the recent release of the open source Icestorm tools, which allows to program several [Lattice's ICE FPGAs](https://en.wikipedia.org/wiki/ICE_(FPGA)), we chose to work only with open tools. The sources from this projects are also open source, licensed under the [LGPL License](https://www.gnu.org/licenses/lgpl.html).

### FPGA compatibility
The choosen toolchain is compatible with the iCE40 LP1K, LP4K, LP8K, and HX devices. However, some of the tools are compatible with more FPGAs, as is the case of Yosys, which can syntesize code for the Xilinx-7 series; and the verilog code is constrainted to the [verilog-2005 standard](http://staff.ustc.edu.cn/~songch/download/IEEE.1364-2005.pdf), so it should be easily ported to most platforms and toolchains.

The following list enumerates the tested FPGA boards:
* izeZUM Alhambra (iCE40HX1K)

## Installation of the required tools
The tools used by this project are:
* Verilog synthesis: [Yosys](http://www.clifford.at/yosys/)
* place&route: [Arachne-PNR](https://github.com/cseed/arachne-pnr)
* FPGA programming: [IceStorm Tools](http://www.clifford.at/icestorm/)
* compilation and simulation: [Icarus](http://iverilog.icarus.com/)
* wave visualization: [gtkwave](http://gtkwave.sourceforge.net/)

Of course, as noted in the previous section, different tools could be used.

The following commands, taken mostly from the icestorm webpage (http://www.clifford.at/icestorm/) can be used to install them on an ubuntu machine.
### Prerrequisites
```bash
sudo apt-get update
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-de
```
### Yosys: Verilog Synthesis
```bash
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make -j$(nproc)
sudo make install
```
### Arachne-PNR: Place&Route
```bash
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
```
### IceStorm: FPGA Programming Tools
```bash
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
```
### Icarus: Verilog Compiler and Simulator
```bash
sudo apt-get install iverilog
```

### GTKwave: VCD File Waveform Viewer
```bash
sudo apt-get install gtkwave
```

## Instructions (TODO)

### Compilation and Testing (TODO)

### Loading to FPGA (TODO)

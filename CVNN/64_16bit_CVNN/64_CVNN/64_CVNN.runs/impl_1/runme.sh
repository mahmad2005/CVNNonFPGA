#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=C:/Xilinx/Vitis/2021.1/bin;C:/Xilinx/Vivado/2021.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2021.1/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2021.1/bin
else
  PATH=C:/Xilinx/Vitis/2021.1/bin;C:/Xilinx/Vivado/2021.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2021.1/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2021.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='E:/FPGAProject/01102022/FPGAResearch/Z_Fresh/Z_Final/FPGA_Implementation/Pipelined_8_Input/CVNN/64_16bit_CVNN/64_CVNN/64_CVNN.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log main.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source main.tcl -notrace


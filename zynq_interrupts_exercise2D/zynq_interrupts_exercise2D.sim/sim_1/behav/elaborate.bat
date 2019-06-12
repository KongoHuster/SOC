@echo off
set xv_path=C:\\Users\\XLInux\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto 38aefb3657b24e918297c0e6c12f130d -m64 --debug typical --relax --mt 2 --include "../../../lab8.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_processing_system7_0_0" --include "../../../lab8.srcs/sources_1/ipshared/xilinx.com/axi_infrastructure_v1_1/cf21a66f/hdl/verilog" --include "../../../lab8.srcs/sources_1/ipshared/xilinx.com/processing_system7_bfm_v2_0/adcdcea3/hdl" -L xil_defaultlib -L axi_lite_ipif_v3_0 -L lib_cdc_v1_0 -L interrupt_control_v3_1 -L axi_gpio_v2_0 -L proc_sys_reset_v5_0 -L generic_baseblocks_v2_1 -L axi_infrastructure_v1_1 -L axi_register_slice_v2_1 -L axi_data_fifo_v2_1 -L axi_crossbar_v2_1 -L fifo_generator_v12_0 -L axi_protocol_converter_v2_1 -L unisims_ver -L unimacro_ver -L secureip --snapshot zynq_interrupt_system_wrapper_behav xil_defaultlib.zynq_interrupt_system_wrapper xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

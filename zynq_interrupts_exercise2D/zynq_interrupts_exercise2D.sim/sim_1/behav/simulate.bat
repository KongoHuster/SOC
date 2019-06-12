@echo off
set xv_path=C:\\Users\\XLInux\\Vivado\\2015.2\\bin
call %xv_path%/xsim zynq_interrupt_system_wrapper_behav -key {Behavioral:sim_1:Functional:zynq_interrupt_system_wrapper} -tclbatch zynq_interrupt_system_wrapper.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

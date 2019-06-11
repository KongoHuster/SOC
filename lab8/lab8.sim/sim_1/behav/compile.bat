@echo off
set xv_path=C:\\Users\\XLInux\\Vivado\\2015.2\\bin
echo "xvlog -m64 --relax -prj zynq_interrupt_system_wrapper_vlog.prj"
call %xv_path%/xvlog  -m64 --relax -prj zynq_interrupt_system_wrapper_vlog.prj -log compile.log
echo "xvhdl -m64 --relax -prj zynq_interrupt_system_wrapper_vhdl.prj"
call %xv_path%/xvhdl  -m64 --relax -prj zynq_interrupt_system_wrapper_vhdl.prj -log compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0

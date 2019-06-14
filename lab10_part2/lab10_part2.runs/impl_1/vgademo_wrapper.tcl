proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  debug::add_scope template.lib 1
  create_project -in_memory -part xc7z010clg400-1
  set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir D:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.cache/wt [current_project]
  set_property parent.project_path D:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.xpr [current_project]
  set_property ip_repo_paths {
  d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.cache/ip
  D:/Study/Soc/SOC/labs/lab10/zybo_base_system
} [current_project]
  set_property ip_output_repo d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.cache/ip [current_project]
  add_files -quiet D:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.runs/synth_1/vgademo_wrapper.dcp
  read_xdc -ref vgademo_processing_system7_0_0 -cells inst d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_processing_system7_0_0/vgademo_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_processing_system7_0_0/vgademo_processing_system7_0_0.xdc]
  read_xdc -ref vgademo_axi_vdma_0_0 -cells U0 d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_axi_vdma_0_0/vgademo_axi_vdma_0_0.xdc
  set_property processing_order EARLY [get_files d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_axi_vdma_0_0/vgademo_axi_vdma_0_0.xdc]
  read_xdc D:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/constrs_1/new/vgacons.xdc
  read_xdc -ref vgademo_axi_vdma_0_0 -cells U0 d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_axi_vdma_0_0/vgademo_axi_vdma_0_0_clocks.xdc
  set_property processing_order LATE [get_files d:/Study/Soc/SOC/labs/lab10/lab10VGA2/lab10VGA2.srcs/sources_1/bd/vgademo/ip/vgademo_axi_vdma_0_0/vgademo_axi_vdma_0_0_clocks.xdc]
  link_design -top vgademo_wrapper -part xc7z010clg400-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force vgademo_wrapper_opt.dcp
  catch {report_drc -file vgademo_wrapper_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file vgademo_wrapper.hwdef}
  place_design 
  write_checkpoint -force vgademo_wrapper_placed.dcp
  catch { report_io -file vgademo_wrapper_io_placed.rpt }
  catch { report_utilization -file vgademo_wrapper_utilization_placed.rpt -pb vgademo_wrapper_utilization_placed.pb }
  catch { report_control_sets -verbose -file vgademo_wrapper_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force vgademo_wrapper_routed.dcp
  catch { report_drc -file vgademo_wrapper_drc_routed.rpt -pb vgademo_wrapper_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file vgademo_wrapper_timing_summary_routed.rpt -rpx vgademo_wrapper_timing_summary_routed.rpx }
  catch { report_power -file vgademo_wrapper_power_routed.rpt -pb vgademo_wrapper_power_summary_routed.pb }
  catch { report_route_status -file vgademo_wrapper_route_status.rpt -pb vgademo_wrapper_route_status.pb }
  catch { report_clock_utilization -file vgademo_wrapper_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force vgademo_wrapper.bit 
  catch { write_sysdef -hwdef vgademo_wrapper.hwdef -bitfile vgademo_wrapper.bit -meminfo vgademo_wrapper.mmi -ltxfile debug_nets.ltx -file vgademo_wrapper.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}


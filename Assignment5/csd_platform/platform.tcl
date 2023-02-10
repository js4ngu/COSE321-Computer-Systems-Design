# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\File\Lec\undergraduate\COSE321-Computer-Systems-Design\Assignment1\csd_platform\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\File\Lec\undergraduate\COSE321-Computer-Systems-Design\Assignment1\csd_platform\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {csd_platform}\
-hw {C:\File\Lec\undergraduate\COSE321-Computer-Systems-Design\Assignment1\class_experiments_v21\SoC_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {C:/File/Lec/undergraduate/COSE321-Computer-Systems-Design/Assignment1}

platform write
platform generate -domains 
platform active {csd_platform}
platform generate
platform active {csd_platform}
domain active {zynq_fsbl}
bsp reload
domain active {standalone_domain}
bsp reload
platform generate -domains 
platform generate
platform generate
platform active {csd_platform}
platform generate -domains 
platform active {csd_platform}
platform generate -domains 
platform generate -domains 

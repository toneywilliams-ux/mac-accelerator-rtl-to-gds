# Conventional 16-bit signed MAC
export DESIGN_NICKNAME = mac_16bit
export DESIGN_NAME = mac_16bit
export PLATFORM = sky130hd

# RTL source files
export VERILOG_FILES = \
    /project/rtl/multiplier/csa_3to2_32bit.v \
    /project/rtl/multiplier/final_cpa_32bit.v \
    /project/rtl/multiplier/booth_multiplier_16bit.v \
    /project/rtl/mac/mac_16bit.v

# Timing constraints
export SDC_FILE = /project/constraints/mac_16bit.sdc

# Physical design settings
export CORE_UTILIZATION = 40
export PLACE_DENSITY = 0.60

# Timing optimization
export TNS_END_PERCENT = 100

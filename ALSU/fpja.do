vlib work
vlog ALSU_TO_SEVEN_SEGMENT.v ALSU_TO_SEVEN_SEGMENT_tb.v
vsim -voptargs=+acc work.ALSU_TO_SEVEN_SEGMENT_tb
add wave *
add wave -position insertpoint  \
sim:/ALSU_TO_SEVEN_SEGMENT_tb/DUT/ALSU/out
add wave -position insertpoint  \
sim:/ALSU_TO_SEVEN_SEGMENT_tb/DUT/ALSU_display_on_7segment/LED_BCD
add wave -position insertpoint  \
sim:/ALSU_TO_SEVEN_SEGMENT_tb/DUT/valid
add wave -position insertpoint  \
sim:/ALSU_TO_SEVEN_SEGMENT_tb/DUT/ALSU/INPUT_PRIORITY
run -all
#quit -sim
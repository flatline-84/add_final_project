proc runSim {} {
    restart -force -nowave

    add wave clk
    add wave reset
    add wave i2c_sda
    add wave i2c_scl
    
    property wave -radix hex *

    force -deposit /clk 1 0, 0 {10 ps} -repeat 20

    force -freeze reset 1
    run 50
    # force -freeze clk 1
    # run 50
    # force -freeze clk 0
    # run 50
    # force -freeze clk 1
    # run 50
    # force -freeze clk 0
    # run 50    
    # force -freeze clk 1
    # run 50

    force -freeze reset 0

    # set i 0

    # for {set i 0} {$i < 100} {incr i} {
    #     force -freeze clk 0
    #     run 50
    #     force -freeze clk 1
    # }

    run 2000
    view wave
}


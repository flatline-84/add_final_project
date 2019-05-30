proc runSim {} {
    restart -force -nowave


    add wave *
    
    property wave -radix hex *
                    #value, time, value, time
    force -deposit /clk_in 1 0, 0 {10 ns} -repeat 20 ns 
    #50MHZ (working!)

    force -freeze start 0
    force -freeze reset 1
    run 1000
    force -freeze reset 0


    force -freeze dev_addr X"72"
    #0x72
    force -freeze reg_data X"a5b7"
    #0xa5
    # force -freeze data X"b7" 
    #0xb7
    run 10000
    force -freeze start 1
    run 20us
    # force -freeze start 0
    force -freeze start 0
    run 20000us

    force -freeze reset 1
    run 1000
    force -freeze reset 0
    force -freeze dev_addr X"39"
    #0x72
    force -freeze reg_data X"8811"
    #0xa5
    # force -freeze data X"c6" 
    run 10000
    force -freeze start 1
    run 20us
    force -freeze start 0
    run 20000us
    
    view wave
}


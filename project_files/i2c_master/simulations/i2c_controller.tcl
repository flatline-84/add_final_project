proc runSim {} {
    restart -force -nowave


    add wave *
    
    property wave -radix hex *
                    #value, time, value, time
    force -deposit /clk_in 1 0, 0 {10 ns} -repeat 20 ns 
    #50MHZ (working!)

    force -freeze start 0
    force -freeze reset_in 1
    run 1000
    force -freeze reset_in 0


    force -freeze dev_addr X"72"
    #0x72
    force -freeze reg_addr X"a5"
    #0xa5
    force -freeze data X"b7" 
    #0xb7
    run 10000
    force -freeze start 1
    # run 305ns
    run 20000us
    
    force -freeze start 0

    
    view wave
}


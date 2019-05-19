proc runSim {} {
    restart -force -nowave


    add wave *
    
    property wave -radix hex *
                    #value, time, value, time
    force -deposit /ref_clk 1 0, 0 {10 ns} -repeat 20 ns 
    #50MHZ (working!)

    force -freeze reset 1
    run 1ns

    force -freeze reset 0

    run 40000ns
    view wave
}


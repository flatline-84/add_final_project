proc runSim {} {
    #Clear the current sims and add waveforms

    restart -force -nowave
    add wave *

    #set radix
    property wave -radix hex *

    #Gen clock to pusj data
    # Gen system clock  
     force -deposit ref_clk 1 0, 0 {100ns} -repeat 200ns
    run 800ns
    force -freeze reset_n 1
    run 300ns
    force -freeze reset_n 0
    run 300ns
    force -freeze reset_n 1
    run 300ns


   # force -freeze saved_addr zzzzzz100010

    # force -freeze reset_spi_counter 1
    run 300ns
    # force -freeze reset_spi_counter 0
    run 300ns
    # force -freeze reset_n 1
    # run 300ns

    force -freeze start 0
    # force -freeze reset_spi_counter 1
    run 300ns
    force -freeze start 1
    # force -freeze reset_spi_counter 0
    run 600ns
    force -freeze start 0
    # force -freeze reset_spi_counter 1
    run 300ns




     run 20000ns

    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
     run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
     run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
     run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
     run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0
    run 250ns
    force -freeze spi_sdo 1 
    run 250ns
    force -freeze spi_sdo 0



    # force -freeze reset_n 1
    # run 30ns

    # force -freeze COUNT 16#00
    # run 10ns


}
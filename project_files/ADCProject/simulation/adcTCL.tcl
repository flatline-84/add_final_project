proc runSim {} {
    #Clear the current sims and add waveforms

    restart -force -nowave
    add wave *

    #set radix
    property wave -radix hex *

    #Gen clock to pusj data
    # Gen system clock  
    # force -deposit CLOCK_50 1 0, 0 {10ns} -repeat 20ns
    run 40ns

    # force -freeze reset_n 1
    # run 30ns
    # force -freeze reset_n 0
    # run 30ns
    # force -freeze reset_n 1
    # run 30ns

    force -freeze COUNT 16#00
    run 10ns


    force -freeze reset_n 16#01
    run 40ms
    force -freeze reset_n 16#00
    run 40ms
    force -freeze reset_n 16#01
    run 40ms

    force -freeze GO 16#01
    run 40ms
    force -freeze GO 16#00
    run 40ms
    force -freeze GO 16#01
    run 40ms


    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms
    force -freeze COUNT 16#FFF
    run 40ms
    force -freeze COUNT 16#000
    run 40ms


    


    # force -freeze armSwitch_pin 0
    # run 30ns

    # force -freeze armSwitch_pin 1
    # run 40ms

    # force -freeze armSwitch_pin 0
    # run 30ns

    # force -freeze armSwitch_pin 1
    # run 40ms

    # force -freeze PanicSwitch_pin 1
    # run 10ms

    # force -freeze PanicSwitch_pin 0
    # run 30ns

    # force -freeze PanicSwitch_pin 1
    # run 10ms

    run 500ms

   # force -freeze 

}
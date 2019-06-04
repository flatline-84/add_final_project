# vsim -gui work.hdmi_controller_display -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver


proc runSim {} {
    restart -force -nowave

    add wave *
    
    property wave -radix hex *
                    #value, time, value, time
    force -deposit /clock50 1 0, 0 {10 ns} -repeat 20 ns 
    #50MHZ (working!)

    # force -freeze start 0
    force -freeze reset 0
    run 1000
    force -freeze reset 1
    run 1000
    force -freeze reset 0
    run 1000

    run 100000us

    
    view wave
}


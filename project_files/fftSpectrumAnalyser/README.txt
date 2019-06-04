To simulate the design:

    Open ModelSim
    Open the fftSpectrumAnalyser.mpf simulation in \simulation folder.
    In the command window (ensuring that you correct for the different path on your machine) type: source D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/testbench/mentor/msim_setup.tcl
    In the command window type: com
    In the command window type: dev com
    The simulation can now be started by going to Simulate -> Start Simulation.
    The item to simulate is work->fftSpectrumAnalyser.
    You will need to add in the following libraries: fft_ii_0, altera_lnsim_ver, altera_mf_ver, fftSpectrum_inst_clk_bfm, fft_Spectrum_inst_rst_bfm, fftSpectrum_inst

Note that no functionality is included in this design - it's just about getting the simulation setup correctly. 

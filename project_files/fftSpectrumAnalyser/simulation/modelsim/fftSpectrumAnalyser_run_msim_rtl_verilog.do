transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib fftSpectrum
vmap fftSpectrum fftSpectrum
vlog -vlog01compat -work fftSpectrum +incdir+D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/fftSpectrum.v}
vlog -vlog01compat -work work +incdir+D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrumAnalyser.v}
vlog -sv -work fftSpectrum +incdir+D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/submodules {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/submodules/fftSpectrum_fft_ii_0.sv}
vcom -93 -work fftSpectrum {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/submodules/auk_dspip_text_pkg.vhd}
vcom -93 -work fftSpectrum {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/submodules/auk_dspip_math_pkg.vhd}
vcom -93 -work fftSpectrum {D:/Designs/Quartus/EEET2162/fftSpectrumAnalyser/fftSpectrum/synthesis/submodules/auk_dspip_lib_pkg.vhd}


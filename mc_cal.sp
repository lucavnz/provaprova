* Calibrated run 149
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.5404385863565169 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.5381111134742292 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Iex 0 vm dc 35n
M1 vm vout 0 0 n130 w=3.0u l=10.0u
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0 0 n130 w=0.45u l=0.15u
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u
Cm vm 0 123.5f
.ic v(vm)=0 v(vmid)=1.8 v(vout)=0
.tran 1n 20u uic
.control
run
meas tran tp trig v(vout) val=0.9 rise=1 targ v(vout) val=0.9 rise=2
let f_s = 1 / tp
print f_s
.endc
.end

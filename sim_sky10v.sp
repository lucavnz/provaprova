* SKY130 at VDD = 1.0V
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.0
Iex 0 vm dc 5n

M1 vm vout 0 0 n130 w=1.0u l=2.0u
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0 0 n130 w=0.45u l=0.15u
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u
Cm vm 0 20f

.ic v(vm)=0 v(vmid)=1.0 v(vout)=0
.tran 0.1n 30u uic

.control
run
wrdata sky10v.dat v(vm) v(vout) i(Vdd)
.endc
.end

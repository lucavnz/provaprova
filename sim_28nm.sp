* 28nm Low-Voltage Ultra-Low-Power LIF Neuron
.model n28 nmos level=54 version=4.5 toxe=1.2e-9 vth0=0.28 u0=0.030 voff=-0.06 nfactor=1.3
.model p28 pmos level=54 version=4.5 toxe=1.2e-9 vth0=-0.28 u0=0.012 voff=-0.06 nfactor=1.3

Vdd vdd 0 0.5
Iex 0 vm dc 1n

* M1 reset transistor
M1 vm vout 0 0 n28 w=0.5u l=0.03u

* Inverter 1 (M2-M3)
M2 vmid vm vdd vdd p28 w=0.2u l=0.03u
M3 vmid vm 0 0 n28 w=0.1u l=0.03u

* Inverter 2 (M4-M5)
M4 vout vmid vdd vdd p28 w=0.2u l=0.03u
M5 vout vmid 0 0 n28 w=0.1u l=0.03u

Cm vm 0 5f

.ic v(vm)=0 v(vmid)=0.5 v(vout)=0
.tran 0.1n 30u uic

.control
run
wrdata sim_28nm_lp.dat v(vm) v(vout) i(Vdd)
.endc
.end

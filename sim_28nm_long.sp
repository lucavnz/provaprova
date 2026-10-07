* 28nm Low-Voltage Ultra-Low-Power LIF Neuron with Long-Channel M1
.model n28 nmos level=54 version=4.5 toxe=1.2e-9 vth0=0.35 u0=0.030 voff=-0.06 nfactor=1.3
.model p28 pmos level=54 version=4.5 toxe=1.2e-9 vth0=-0.35 u0=0.012 voff=-0.06 nfactor=1.3

Vdd vdd 0 0.6
Iex 0 vm dc 5n

* M1 reset transistor: long channel to suppress off-leakage!
M1 vm vout 0 0 n28 w=0.2u l=0.5u

* Inverter 1 (M2-M3)
M2 vmid vm vdd vdd p28 w=0.2u l=0.06u
M3 vmid vm 0 0 n28 w=0.1u l=0.06u

* Inverter 2 (M4-M5)
M4 vout vmid vdd vdd p28 w=0.2u l=0.06u
M5 vout vmid 0 0 n28 w=0.1u l=0.06u

Cm vm 0 10f

.ic v(vm)=0 v(vmid)=0.6 v(vout)=0
.tran 0.1n 20u uic

.control
run
wrdata sim_28nm_long.dat v(vm) v(vout) i(Vdd)
.endc
.end

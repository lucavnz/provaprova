* Paper 1 Baseline LIF Neuron in ngspice
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Iex 0 vm dc 23.8n

* M1 subthreshold integrate and reset
M1 vm vout 0 0 n130 w=3.0u l=10.0u

* First inverter (M2-M3)
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0 0 n130 w=0.45u l=0.15u

* Second inverter (M4-M5)
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u

* Membrane capacitor
Cm vm 0 123.5f ic=0

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0
.tran 0.1n 30u uic

.control
run
meas tran t_spike1 trig v(vout) val=0.9 rise=1 targ v(vout) val=0.9 rise=2
let f_spike = 1 / t_spike1
print f_spike
wrdata baseline_transient.dat v(vm) v(vout)
.endc
.end

* Innovation 4: Integrated Synaptic Front-End + LIF Neuron
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8

* Presynaptic pulse generator: train of 50ns pulses every 500ns
Vpre vpre 0 pulse(0 1.8 100n 1n 1n 40n 400n)
Vweight vweight 0 1.1

* Synaptic Front-End (PMOS switch + weight transistor)
* Msyn_weight sets current, Msyn_sw switches with active-low pulse
* Let us invert vpre for PMOS switch
M_inv_p vpre_b vpre vdd vdd p130 w=0.45u l=0.15u
M_inv_n vpre_b vpre 0   0   n130 w=0.45u l=0.15u

Msyn_w  n_syn vweight vdd vdd p130 w=0.9u l=0.5u
Msyn_sw vm    vpre_b  n_syn vdd p130 w=0.9u l=0.15u

* LIF Neuron core
M1 vm vout 0 0 n130 w=3.0u l=10.0u
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0 0 n130 w=0.45u l=0.15u
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u
Cm vm 0 123.5f

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0
.tran 0.2n 5u uic

.control
run
wrdata synapse_sim.dat v(vpre) v(vm) v(vout)
.endc
.end

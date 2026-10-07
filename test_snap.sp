* LIF with Regenerative Positive Feedback to kill crowbar
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Iex 0 vm dc 23.8n

* First inverter (M2-M3)
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0    0   n130 w=0.45u l=0.15u

* Regenerative NMOS pull-down: as soon as Vout starts to rise, M_pos pulls Vmid down instantly!
M_pos vmid vout 0 0 n130 w=0.9u l=0.15u

* Second inverter (M4-M5)
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u

* M1 reset
M1 vm vout 0 0 n130 w=3.0u l=10.0u
Cm vm 0 123.5f

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0
.tran 0.1n 30u uic

.control
run
wrdata snap.dat v(vm) v(vmid) v(vout) i(Vdd)
.endc
.end

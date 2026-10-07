* Innovation 2: Starved Reset from Vmid
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Iex 0 vm dc 50n
Vctrl vctrl 0 1.8

* M1 reset transistor driven by vrst
M1 vm vrst 0 0 n130 w=3.0u l=10.0u

* First inverter (M2-M3)
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0 0 n130 w=0.45u l=0.15u

* Second inverter (M4-M5)
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u

* Starved Inverter driven by Vmid:
* When vmid drops to 0 (spike), PMOS pulls vrst to VDD
M_up vrst vmid vdd vdd p130 w=0.9u l=0.15u
* When vmid returns to 1.8, vrst discharges through starved NMOS
M_dn vrst vmid n_starv 0 n130 w=0.45u l=0.15u
M_starv n_starv vctrl 0 0 n130 w=0.45u l=2.0u
Crst vrst 0 50f

Cm vm 0 123.5f

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0 v(vrst)=0
.tran 0.5n 60u uic

.control
run
wrdata refr_1.80.dat v(vm) v(vout) v(vrst)
meas tran t_p trig v(vout) val=0.9 rise=2 targ v(vout) val=0.9 rise=3
let f_spike = 1 / t_p
print f_spike
.endc
.end

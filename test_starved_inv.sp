* LIF with Crowbar-Current Limiter
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Iex 0 vm dc 23.8n
Vlim vlim 0 1.3

* Current limiter for first inverter: limits crowbar to ~2 uA!
M_lim n_lim vlim vdd vdd p130 w=0.45u l=2.0u

* First inverter (M2-M3): source of M2 is connected to n_lim instead of VDD!
M2 vmid vm n_lim vdd p130 w=0.45u l=0.15u
M3 vmid vm 0     0   n130 w=0.45u l=0.15u

* Second inverter (M4-M5)
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u

* M1 reset
M1 vm vout 0 0 n130 w=3.0u l=10.0u
Cm vm 0 123.5f

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0
.tran 0.2n 30u uic

.control
run
wrdata starved_inv.dat v(vm) v(vout) i(Vdd)
.endc
.end

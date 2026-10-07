* Advanced Unified LIF Neuromorphic Core
* Featuring:
* 1. CTAT-Compensated Subthreshold Bias (M_b1, M_b2, R_b, M6)
* 2. Starved-Feedback Programmable Refractory Period (M_up, M_dn, M_starv, Crst)
* 3. Post-Fabrication Bulk-Biasing Mismatch Tuning (M3 bulk terminal V_bulk)
* 4. Integrated 2T Synaptic Front-End (M_syn_w, M_syn_sw)

.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Vbulk vbulk 0 0.0
Vctrl_refr vctrl_refr 0 0.70

* Synaptic excitation (train of 30ns pulses)
Vpre vpre 0 pulse(0 1.8 100n 1n 1n 30n 300n)
Vweight vweight 0 1.05

* Synaptic Front-End
M_inv_p vpre_b vpre vdd vdd p130 w=0.45u l=0.15u
M_inv_n vpre_b vpre 0   0   n130 w=0.45u l=0.15u
M_syn_w  n_syn vweight vdd vdd p130 w=0.9u l=0.5u
M_syn_sw vm    vpre_b  n_syn vdd p130 w=0.9u l=0.15u

* Thermal-Compensated Bias Auxiliary Cell
Mb1 vbias_ctat vbias_ctat vdd vdd p130 w=0.45u l=2.0u
Rbias vbias_ctat nb 120k
Mb2 nb nb 0 0 n130 w=1.0u l=2.0u

* Background bias injection
M6 vm vbias_ctat vdd vdd p130 w=0.45u l=4.0u

* Membrane capacitor & Integrator
Cm vm 0 123.5f
M1 vm vrst 0 0 n130 w=3.0u l=10.0u

* Stage 1: Threshold Detector with Bulk-Biasing
M2 vmid vm vdd vdd p130 w=0.45u l=0.15u
M3 vmid vm 0   vbulk n130 w=0.45u l=0.15u

* Stage 2: Output Inverter Buffer
M4 vout vmid vdd vdd p130 w=0.45u l=0.15u
M5 vout vmid 0 0 n130 w=0.45u l=0.15u

* Stage 3: Starved-Feedback Programmable Refractory Generator
M_up vrst vmid vdd vdd p130 w=0.9u l=0.15u
M_dn vrst vmid n_starv 0 n130 w=0.45u l=0.15u
M_starv n_starv vctrl_refr 0 0 n130 w=0.45u l=2.0u
Crst vrst 0 35f

.ic v(vm)=0 v(vmid)=1.8 v(vout)=0 v(vrst)=0
.tran 0.2n 10u uic

.control
run
meas tran t_p trig v(vout) val=0.9 rise=1 targ v(vout) val=0.9 rise=2
let f_s = 1 / t_p
print f_s
wrdata unified_transient.dat v(vpre) v(vm) v(vout) v(vrst)
.endc
.end

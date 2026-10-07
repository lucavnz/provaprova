* Inverter Trip Point with Bulk Bias
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.62 u0=0.035 voff=-0.08 nfactor=1.5
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.62 u0=0.015 voff=-0.08 nfactor=1.5

Vdd vdd 0 1.8
Vb  vb  0 0.4
Vin vin 0 0.9

* Inverter with NMOS bulk tied to Vb
M2 vout vin vdd vdd p130 w=0.45u l=0.15u
M3 vout vin 0   vb  n130 w=0.45u l=0.15u

.dc Vin 0 1.8 0.001

.control
run
* Find crossing Vin = Vout
let diff = v(vout) - v(vin)
meas dc v_trip when diff=0
print v_trip
.endc
.end

* Test BSIM in ngspice
.model n130 nmos level=54 version=4.5 toxe=3e-9 vth0=0.538 u0=0.035 lint=0 vint=0
.model p130 pmos level=54 version=4.5 toxe=3e-9 vth0=-0.540 u0=0.015 lint=0 vint=0

Vdd vdd 0 1.8
Vin vin 0 0.9

M1 vout vin 0 0 n130 w=0.45u l=0.15u
M2 vout vin vdd vdd p130 w=0.45u l=0.15u

.op
.control
run
print v(vout)
.endc
.end

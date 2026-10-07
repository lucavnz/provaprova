* Test sky130 in ngspice
.include nfet_01v8.pm3.spice
.include pfet_01v8.pm3.spice

Vdd vdd 0 1.8
Vin vin 0 0.9

X1 vout vin 0 0 sky130_fd_pr__nfet_01v8 w=0.45 l=0.15
X2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 w=0.45 l=0.15

.op
.control
run
print v(vout)
.endc
.end

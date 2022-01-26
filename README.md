# physics
In this repo different methods used in physics related projects of mine are presented.

1. CUSUM: 

The CUSUM method is used to determine changes in a given time profile.

function(data set, ωn, threshold, **kwargs)
- ωn: estimated start mean value or automatic.
- threshold: limit value for position determination 
- return: (graphic, time stamp)

The data in the given example originates from the EPHIN on the SoHO. The first column gives 
information about the time in minutes since the launch of the probe (20.07.1999). As
second column is the number of events in detector G, the anticoincidence of the instrument.

2. Fermi gas: 

Here the Fermi-Dirac statistic of electrons is recreated using the Metropolis–Hastings algorithm.

3. Generate ground state: 

Here we generate the ground state of a Heisenberg model using tensor networks.
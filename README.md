# physics
In this repo the CUSUM method is used to determine changes in a given time profile.

Definition: 

function(data set, ωn, threshold, **kwargs)
- ωn: estimated start mean value or automatic.
- threshold: limit value for position determination 
- return: (graphic, time stamp)

The data in our example originate from the EPHIN (Electron Proton Helium instrument) on the SoHO (Solar Heliospheric Observatory). The first column gives 
information about the time in minutes since the launch of the probe (20.07.1999). As
second column is the number of events in detector G, the anticoincidence of the instrument.


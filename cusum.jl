
# Vollversion CUSUM

# benötigte Bibliotheken werden eingebunden

import numpy as np
import time as tm
from datetime import datetime
from datetime import timedelta
import matplotlib.pyplot as plt
import matplotlib.dates as mdates


time, event_value = np.loadtxt("dat.txt", unpack = True)




#Variable Parameter:
w = mean(event_value)	# Mittelwert setzen
h = 100*w                   # Grenzwert
std_abw_max = 150			# maximale Standartabweichung
min_range = 100             # range for the new average value after an event
i = 1;
number = len(time)


s = Array{Float64}(undef, number)
sp = Array{Float64}(undef, number)
sn = Array{Float64}(undef, number)
cusum_points = []
cusum_p_points = []
cusum_n_points = []
converted_time = Array{Float64}(undef, number)


#converting the time array into dates
j = 0
while j < number:
    converted_time[j] = startdate_c + timedelta(minutes=time[j])
    j+=1

#Falls gefordert wird hier die zu überprüfende Sequenz des Datensatzes erstellt
time_s = time[:number]
converted_time_s = converted_time[:number]


# Funktion: setzt neues w (Mittelwert dynamisch); neues i (Index wo das Event zuende ist) wird zurückgegeben
function new_average_and_index(i)
    std_abw = std_abw_max + 1
    while (i+min_range) < number and std_abw > std_abw_max:
        std_abw = np.std(event_value[i:(i+min_range)])
        w = np.mean(event_value[i:(i+min_range)])
        i += 100
    return w, i
    end


#Funktion: setzt neue Startwerte
def new_start(i):
        s[i] = value_current
        sp[i] = value_current
        if sp[i] < 0:
            sp[i] = 0  # sp wird nie < 0
        sn[i] = value_current
        if sn[i] > 0:
            sp[i] = 0  # sn wird nie > 0

# Startinitialisierungen:
w, i = new_average_and_index(i)
print("start w: " + str(w))
value_current = (event_value[i] - w)
new_start(i)

while i < number: #Hauptschleife

    value_current = (event_value[i] - w)

    s[i] = s[i-1] + value_current
    sp[i] = sp[i-1] + value_current
    if sp[i] < 0:
        sp[i] = 0     # sp wird nie < 0
    sn[i] = sn[i-1] + value_current
    if sn[i] > 0:
        sn[i] = 0     # sn wird nie > 0

    # Hier wird gestet ob der Grenzwert überschritten wird und wenn ja, wird dies als Event ausgegeben und startet CUSUM neu, sobald das Event zuende ist.
    if (s[i] < -h or s[i] > h):
        print("CUSUM an der Stelle  " + str(i) + "  zur Zeit  " + str(startdate_c + timedelta(minutes=time[i])) + ".")
        print(" CUSUM:  " + str(s[i]) + "\n CUSUM+: " + str(sp[i]) + "\n CUSUM-: " + str(sn[i]) + "\n ... mit Grundniveau: " + str(w) + "\n" )
        cusum_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)
    if sp[i] > h:
        print("CUSUM+ an der Stelle  " + str(i) + "  zur Zeit  " + str(startdate_c + timedelta(minutes=time[i])) + ".")
        print(" CUSUM:  " + str(s[i]) + "\n CUSUM+: " + str(sp[i]) + "\n CUSUM-: " + str(sn[i]) + "\n ... mit Grundniveau: " + str(w) + "\n" )
        cusum_p_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)
    if sn[i] < -h:
        print("CUSUM- an der Stelle  " + str(i) + "  zur Zeit  " + str(startdate_c + timedelta(minutes=time[i])) + ".")
        print(" CUSUM:  " + str(s[i]) + "\n CUSUM+: " + str(sp[i]) + "\n CUSUM-: " + str(sn[i]) + "\n ... mit Grundniveau: " + str(w) + "\n" )
        cusum_n_points.append([startdate_c + timedelta(minutes=time[i]),event_value[i]])
        new_start(i)
        w, i = new_average_and_index(i)

    i += 1



# Plotten der Ereignissanzahl (y-Achse) auf die Zeit (x-Achse):
# TODO: Mit Marker und Zeitstempel
#3 DP arrays are for testing
plt.figure(1)
plt.subplot(211)
plt.plot(converted_time_s, event_value, "g-")
plt.title('Event overview')
# plt.xlabel('Time')
plt.ylabel('Event value')

for i in cusum_points:
        if i[1]<30000:
            plt.annotate("C",xy=(i[0],26000),xytext=(i[0],39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
        else:
            plt.annotate("C",xy=(i[0],26000),xytext=(i[0]+timedelta(minutes=2600),39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
for i in cusum_p_points:
        if i[1]<30000:
            plt.annotate("C+",xy=(i[0],26000),xytext=(i[0],39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
        else:
            plt.annotate("C+",xy=(i[0],26000),xytext=(i[0]+timedelta(minutes=2600),39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
for i in cusum_n_points:
        if i[1]<30000:
            plt.annotate("C-",xy=(i[0],26000),xytext=(i[0],39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
        else:
            plt.annotate("C-",xy=(i[0],26000),xytext=(i[0]+timedelta(minutes=2600),39000),arrowprops=dict(arrowstyle="-|>"),horizontalalignment='center', verticalalignment='top',)
#Formating time axis
#myFmt = mdates.DateFormatter('%m-%d')



plt.subplot(212)
plt.plot(converted_time_s, s, "b-",label='S')
plt.plot(converted_time_s, sp, "y-",label='SP')
plt.plot(converted_time_s, sn, "r-",label='SN')
plt.title('Cusum overview')
plt.xlabel(Date after Start')
plt.ylabel('Cusum value')
legend = plt.legend(loc='upper left', shadow=True, fontsize='x-small')
#legend.get_frame().set_facecolor("C0") Farbe der Legende
#Formating time axis
#myFmt2 = mdates.DateFormatter('%m-%d-%y')
#plt.gca().xaxis.set_major_formatter(myFmt2)

plt.subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=None, hspace=0.3)



ende = tm.time()
print("Laufzeit: " + '{:5.3f}s'.format(ende-start))

# Zeigen des Plots
plt.show()



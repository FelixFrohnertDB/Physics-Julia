import math
import random as rd
import matplotlib.pyplot as plt
import numpy as np


#system size
size = 100

my = 50
sigma = my*0.4


accrej = 0




#initialize random config

orbitals = [0]*size
for i in range(size):
	orbitals[i] = rd.randint(0,1)
mcorb = [0]*size
mcorb2 = [0]*size


#initialize array of random nubmers

nmc = 100000#0

#	numran =   round(np.random.normal(my,sig)) #   #




randomOrbital = 0
accept = 0
deltaE = 0
sign = 0.0
function sim(iter::Float64,bet::Float64)
	beta = bet
	orbitals = [0]*size
	compplot = [0]*size
	compplot2 = [0]*size
	compplot3 = 0
	for i in range(size):
		orbitals[i] = rd.randint(0,1)
		compplot[i] = 1.0/(1.0 + math.exp(beta*(i-my)))
		compplot2[i] = math.exp(beta*(i-my))/((1.0 + math.exp(beta*(i-my)))**2)
		compplot3 += 1.0/(1.0 + math.exp(beta*(i-my)))
	mcorb = [0]*size
	mcorb2 = [0]*size
	mcorb3 = 0


	i = 0
	account = 0
	while i < iter:
		#chose random orbital dist with q as chem pot
		randomOrbital = rd.randint(0,size-1)
		if orbitals[randomOrbital] == 1:
			sign = -1.0
		else:
			sign = 1.0

		#Here the pro of accepting a change is computed
		deltaE = randomOrbital
		accept = min(1, math.exp( -beta *(deltaE - my)*sign ))

		#accept or reject
		accrej = rd.uniform(0,1)
		if accept >= accrej:
			account +=1
			orbitals[randomOrbital] += 1
			orbitals[randomOrbital] = orbitals[randomOrbital] % 2
		for j in range(len(mcorb)):
			mcorb[j]+=orbitals[j]
			mcorb2[j]+=orbitals[j]**2
		i+=1
		if (i/iter*100)%2 == 0 :
			print(i/iter *100, "%")
	for x in range(len(mcorb)):
		mcorb[x]=mcorb[x]/iter
		mcorb2[x]=mcorb2[x]/iter
		mcorb3 += mcorb[x]
	for x in range(len(mcorb)):
		mcorb2[x]=(mcorb2[x]-mcorb[x]*mcorb[x])
#	print(mcorb)
	print("Acc",account/iter)
	return [mcorb,compplot,mcorb2,compplot2,mcorb3,compplot3]
result1 = sim(nmc,1/10)
result2 = sim(nmc,1/15)
result3 = sim(nmc,1/5)

file1=open("results.txt","w+")
file1.write("Theo: \n")
file1.writelines([str(result1[5])+"\n",str(result2[5])+"\n",str(result3[5])+"\n"])
file1.write("Calc: \n")
file1.writelines([str(result1[4])+"\n",str(result2[4])+"\n",str(result3[4])+"\n"])
file1.close()

plt.xlabel("energy")
plt.ylabel("occpation number <n>")

plt.plot(result1[1],label='Theoretical value: \u03B2=1/10')
plt.plot(result1[0],"+r",markersize=3,label='Numerical result: \u03B2=1/10')
plt.plot(result2[1],label='Theoretical value: \u03B2=1/15')
plt.plot(result2[0],"+b",markersize=3,label='Numerical result: \u03B2=1/15')
plt.plot(result3[1],label='Theoretical value: \u03B2=1/5')
plt.plot(result3[0],"+k",markersize=3,label='Numerical result: \u03B2=1/5')


legend = plt.legend(loc='upper right', shadow=False, fontsize='x-small')
plt.savefig("test1.jpg")


plt.clf()


plt.plot(result1[3],label='Theoretical value: \u03B2=1/10')
plt.plot(result1[2],"+r",markersize=1,label='Numerical result: \u03B2=1/10')
plt.plot(result2[3],label='Theoretical value: \u03B2=1/15')
plt.plot(result2[2],"+b",markersize=1,label='Numerical result: \u03B2=1/15')
plt.plot(result3[3],label='Theoretical value: \u03B2=1/5')
plt.plot(result3[2],"+k",markersize=1,label='Numerical result: \u03B2=1/5')
plt.xlabel("energy")
plt.ylabel("occpation number fluctuation <( \u0394 n )\u00B2>")
legend = plt.legend(loc='upper right', shadow=False, fontsize='x-small')
plt.savefig("test2.pdf")

plt.clf()




# plt.plot(result3[1],label='Theoretical value')
# plt.plot(result3[0],"+r",markersize=1,label='Numerical result')
# #plt.plot(result2)
# #plt.plot(result3)
# plt.xlabel("energy")
# plt.ylabel("occpation number <n>")
# legend = plt.legend(loc='upper right', shadow=False, fontsize='x-small')
# plt.savefig("test3.png")
import functions
import numpy as np
import WalabotAPI as walabot
import matplotlib.pyplot as plt

aluminum_block=np.load('aluminum_block.npy')
aluminum_block_raised=np.load('aluminum_block_raised_1.9cm.npy')
aluminum_block_raised_again=np.load('aluminum_block_raised_2.4cm.npy')
aluminum_block_under_bin=np.load('aluminum_block_under_bin_0cm.npy')
aluminum_block_under_bin_1=np.load('aluminum_block_under_bin_1cm.npy')
aluminum_block_under_bin_04=np.load('aluminum_block_under_bin_0.4cm.npy')
aluminum_block_under_bin_025=np.load('aluminum_block_under_bin_0.25cm.npy')
aluminum_block_under_bin_015=np.load('aluminum_block_under_bin_0.15cm.npy')
baseline_with_bin=np.load('baseline_with_bin.npy')
baseline_with_bin_1cm=np.load('baseline_with_bin_1cm.npy')
baseline_with_bin_04cm=np.load('baseline_with_bin_0.4cm.npy')
baseline_with_bin_025cm=np.load('baseline_with_bin_0.25cm.npy')
baseline_with_bin_015cm=np.load('baseline_with_bin_0.15cm.npy')
baseline=np.load('baseline.npy')


baseline=baseline[49,:,:]
baseline_with_bin=baseline_with_bin[49,:,:]
baseline_with_bin_1cm=baseline_with_bin_1cm[49,:,:]
baseline_with_bin_04cm=baseline_with_bin_04cm[49,:,:]
baseline_with_bin_025cm=baseline_with_bin_025cm[49,:,:]
baseline_with_bin_015cm=baseline_with_bin_015cm[49,:,:]

dist1=[]
dist2=[]
dist3=[]
dist4=[]
dist5=[]
dist6=[]
dist7=[]
dist8=[]

for i in range(0,50):
    data = aluminum_block[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline)
    dist1.append(dist)

print np.mean(dist1)


#plt.plot(dist1,label='aluminum block')




for i in range(0,50):
    data = aluminum_block_raised[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline)
    dist2.append(dist)


print np.mean(dist2)


#plt.plot(dist2,  label='aluminum block raised 1cm')



for i in range(0,50):
    data = aluminum_block_raised_again[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline)
    dist3.append(dist)


print np.mean(dist3)

#plt.plot(dist3, label='aluminum block raised 2.4cm')



for i in range(0,50):
    data = aluminum_block_under_bin[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline_with_bin)
    dist4.append(dist)


print np.mean(dist4)

plt.plot(dist4, label='aluminum block under bin-no water')


for i in range(0,50):
    data = aluminum_block_under_bin_1[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline_with_bin_1cm)
    dist5.append(dist)

plt.plot(dist5, label= 'aluminum block under bin-1cm water')
print np.mean(dist5)

for i in range(0,50):
    data = aluminum_block_under_bin_04[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline_with_bin_04cm)
    dist6.append(dist)

plt.plot(dist6, label= 'aluminum block under bin-0.4cm water')
print np.mean(dist6)

for i in range(0,50):
    data = aluminum_block_under_bin_025[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline_with_bin_025cm)
    dist7.append(dist)

plt.plot(dist7, label= 'aluminum block under bin-0.25cm water')
print np.mean(dist7)

for i in range(0,50):
    data = aluminum_block_under_bin_015[i, :, :]
    dist=functions.getDistanceToTarget(data,walabot.PROF_SHORT_RANGE_IMAGING,baseline_with_bin_015cm)
    dist8.append(dist)

plt.plot(dist8, label= 'aluminum block under bin-0.15cm water')
print np.mean(dist8)

plt.legend()
plt.show()


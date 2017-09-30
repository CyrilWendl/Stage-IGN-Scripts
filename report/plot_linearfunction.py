"""-Plotting probabilities for a given coordinate and saving as PDF File
"""

import matplotlib.pyplot as plt
import pylab
import seaborn

plt.close('all')
F = pylab.gcf()
plt.rc('text', usetex=True)
plt.rc('font', family='serif')


def showProbabilities(x, y):
    plt.plot(x,y)
    plt.xticks(x,x)
    plt.xlabel(r'\textbf{Distance [m]}')
    plt.ylabel(r'\textbf{Probability}')
    plt.grid(True)
    plt.tick_params(top='off', bottom='off', left='off', right='off', labelleft='off', labelbottom='on')
    seaborn.despine(left=True, bottom=True, right=True)
    plt.savefig("/Users/cyrilwendl/Documents/Stages/IGN/linear_function.pdf", bbox_inches='tight')


x=[-100,0,200,300]
y=[1,1,0,0]

showProbabilities(x,y)

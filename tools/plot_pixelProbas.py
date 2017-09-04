"""
-Plotting probabilities for a given coordinate and saving as PDF File
"""

import matplotlib.pyplot as plt
import gdal,ogr
import numpy as np
import pylab
from affine import Affine
from PIL import Image, ImageDraw


plt.close('all')
F = pylab.gcf()
plt.rc('text', usetex=True)
plt.rc('font', family='serif')

# Probabilities
def showProbabilities(Probas, Names):
    objects = ('Building','Road','Forest','Vegetation','Water')
    y_pos = np.arange(len(objects))

    for idx,P in enumerate(Probas):
        plt.subplot(2,2,idx+1)
        plt.bar(y_pos, P, align='center', alpha=0.5)
        plt.bar(y_pos, P, align='center', alpha=0.5)
        plt.xticks(y_pos, objects)
        plt.xlabel(r'\textbf{Class}')
        plt.ylabel(r'\textbf{Probability}')
        plt.title(Names[idx])
        plt.grid(True)
        axes = plt.gca()
        axes.set_ylim([0, 1])

    DefaultSize = F.get_size_inches()
    F.set_size_inches((DefaultSize[0] * 1.5, DefaultSize[1] * 1.8))
    plt.savefig("/home/cyrilwendl/fusion/proba_point.pdf", bbox_inches='tight')

def getPixelValues(file,coords):
    im=gdal.Open(file)
    cols = im.RasterXSize
    rows = im.RasterYSize
    transform = im.GetGeoTransform()

    xOrigin = transform[0]
    yOrigin = transform[3]
    pixelWidth = transform[1]
    pixelHeight = -transform[5]

    pixel_values=[]
    for i in range(1,im.RasterCount+1):
        band=im.GetRasterBand(i)
        data = band.ReadAsArray(0, 0, cols, rows)
        col = int((coords[0] - xOrigin) / pixelWidth)
        row = int((yOrigin - coords[1]) / pixelHeight)
        print col,row
        pixel_values.append(data[row][col])
    order = [0, 4, 1, 3, 2]
    pixel_values = [pixel_values[i] for i in order]
    return pixel_values

def draw_point(x,y):
    im=Image.open("/home/cyrilwendl/fusion/im_41000_30000/Classified/classif_SPOT6_all.visu.tif")
    draw = ImageDraw.Draw(im)
    r=15
    draw.ellipse((x-r, y-r, x+r,y+r), fill='white', outline='black')
    im.save("/home/cyrilwendl/fusion/test", "PNG")
    del draw

#draw_point(420,558)

coords=[175469,6836128]
Probas=[]
Probas.append(getPixelValues("/home/cyrilwendl/fusion/im_41000_30000/proba_S2.tif",coords))
Probas.append(getPixelValues("/home/cyrilwendl/fusion/im_41000_30000/proba_SPOT6.tif",coords))
Probas.append(getPixelValues("/home/cyrilwendl/fusion/im_41000_30000/proba_S2_weighted.tif",coords))
Probas.append(getPixelValues("/home/cyrilwendl/fusion/im_41000_30000/proba_SPOT6_weighted.tif",coords))

# data

Names=["Sentinel-2", "SPOT 6", "Sentinel-2 weighted", "SPOT6 weighted"]
showProbabilities(Probas, Names)
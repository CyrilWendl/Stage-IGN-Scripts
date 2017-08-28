from qgis.core import *
from qgis.gui import *
from qgis.utils import iface
from PyQt4 import QtGui, QtCore 
from PyQt4.QtCore import * 
from PyQt4.QtGui import * 
from natsort import natsorted, ns
import os, sys
import qgis

basedir="/media/cyrilwendl/15BA65E227EC1B23"
root = QgsProject.instance().layerTreeRoot()
root.removeAllChildren () # clean update
#QSettings().setValue("/Projections/defaultBehaviour", "useGlobal")
QgsMapLayerRegistry.instance().removeAllMapLayers() # clean up

   
rlayer = QgsRasterLayer(basedir + "/all_classif_S2.tif", "classif_S2")
QgsMapLayerRegistry.instance().addMapLayer(rlayer)
qgis.utils.iface.mapCanvas().setExtent(rlayer.extent())    

# get layer ids
printable_layers = qgis.utils.iface.legendInterface().layers() 
printable_layers_ids = []
for layer in printable_layers:
    printable_layers_ids.append(layer.id())
print printable_layers_ids

mapRenderer = iface.mapCanvas().mapRenderer()
mapRenderer.setLayerSet(printable_layers_ids)
c = QgsComposition(mapRenderer)
c.setPlotStyle(QgsComposition.Print)

# size of map
x, y = 0, 0
w, h = c.paperWidth(), c.paperHeight()
composerMap = QgsComposerMap(c, x ,y, w, h)
composerMap.setNewExtent(rlayer.extent())

def add_layer(layer_name):
    pass
    
def get_layers():    
    pass

def create_canvas():            
    # Create QgsComposition class
   # print printable_layers_ids
    pass
    #mapRenderer.setOutputSize(QSize(c.paperWidth(), c.paperHeight()), c.printResolution())
    #mapRenderer.setExtent(bigger_printable_layer.extent())

def add_text(t):
    # Write some text
    composerLabel = QgsComposerLabel(c)
    composerLabel.setText(t)
    composerLabel.adjustSizeToText()
    c.addItem(composerLabel)

def add_legend():
    # Legend
    legend = QgsComposerLegend(c)
    legend.model().setLayerSet(mapRenderer.layerSet())
    legend.setItemPosition(0,c.paperHeight()-50,0,0)
    c.addItem(legend)

def add_scale_bar():
    # Scale Bar
    # create scale bar
    item = QgsComposerScaleBar(c)
    item.setStyle('Single Box') # Other possibilities are: 'Single Box', 'Double Box', 'Line Ticks Middle', 'Line Ticks Down', 'Line Ticks Up', 'Numeric'
    item.setComposerMap(composerMap)
    item.applyDefaultSize()
    item.setAlignment(QgsComposerScaleBar.Right)
    item_x_position = c.paperWidth() - 25 - 5*item.segmentMillimeters() 
    item_y_position = c.paperHeight() - 25 
    item.setItemPosition(item_x_position,item_y_position,0,0)
    c.addItem(item)

def add_arrow():
    northarrowIcon = QgsComposerPicture(c)
    northarrowIcon.setSceneRect(QRectF(0,0,20,20))
    northarrowIcon.setPos(QPointF(50,110))
    northarrowIcon.setItemPosition(c.paperWidth()-20,0,0,0)
    northarrowIcon.setPictureFile("/usr/share/qgis/svg/arrows/NorthArrow_04.svg")
    c.addItem(northarrowIcon)

def save_pdf():
    printer = QPrinter()
    printer.setOutputFormat(QPrinter.PdfFormat)
    printer.setOutputFileName(basedir + "/out.pdf")
    printer.setPaperSize(QSizeF(c.paperWidth(), c.paperHeight()), QPrinter.Millimeter)
    printer.setFullPage(True)
    printer.setColorMode(QPrinter.Color)
    printer.setResolution(c.printResolution())

    pdfPainter = QPainter(printer)
    paperRectMM = printer.pageRect(QPrinter.Millimeter)
    paperRectPixel = printer.pageRect(QPrinter.DevicePixel)
    c.render(pdfPainter, paperRectPixel, paperRectMM)
    pdfPainter.end()
    
    
def main():
    text="Hello Worla"
    get_layers()
    create_canvas()
    add_text(text)
    add_legend()
    add_scale_bar()
    add_arrow()
    save_pdf()
    
main()
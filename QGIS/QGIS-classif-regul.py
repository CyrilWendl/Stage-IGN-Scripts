from qgis.core import *
from qgis.gui import *
from PyQt4.QtCore import *
from PyQt4 import QtGui
import os, sys
import qgis

def addWMSLayer():
     # WMS layer (not working)
    uri_separator = '&'
    uri_url = 'http://wxs.ign.fr/61fs25ymczag0c67naqvvmap/geoportail/wmts'
    uri_service = 'SERVICE=WMTS'
    uri_request = 'REQUEST=GetCapabilities'
    
    url_with_params = uri_separator.join((uri_url,
                                      uri_service,
                                      uri_request
                                      ))
    
    rlayer = QgsRasterLayer(url_with_params, 'SPOT 6-7 - 2016', 'wms')
    print rlayer.isValid() # uncomment these for displaying errors
    print rlayer.error().message()
    QgsMapLayerRegistry.instance().addMapLayer(rlayer)
    

def main():
    QgsMapLayerRegistry.instance().removeAllMapLayers() # clean up
    # addWMSLayer()
    
    # Groups
    root = QgsProject.instance().layerTreeRoot()
    root.removeAllChildren () # clean up

    # Regularization group    
    # load raster layers
    group_reg=root.insertGroup(1,"Regularization")
    source_dir = "/home/cyrilwendl/DeveloppementBase/im_test/Regul"
    for files in sorted(os.listdir(source_dir)):
        # load only raster layers
        if files.endswith(".visu.tif"):
            subgroup = group_reg.insertGroup(1, files)
            rlayer = QgsRasterLayer(source_dir + "/" + files, files)
            rlayer.renderer().setOpacity(0.5) 

            # add layer to the registry
            QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
            subgroup.addLayer(rlayer)
            
            qgis.utils.iface.mapCanvas().setExtent(rlayer.extent())
            
            # background image (SPOT6)
            rlayer = QgsRasterLayer("/home/cyrilwendl/DeveloppementBase/im_test/Im_SPOT6.tif", "Im_SPOT6")
            QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
            subgroup.addLayer(rlayer)
            #qgis.utils.iface.mapCanvas().setExtent(rlayer.extent())
            qgis.utils.iface.mapCanvas().refresh()
        
            qgis.utils.iface.mapCanvas().refresh()
    
    # Classification group    
    group_classif = root.insertGroup(2, "Classification")

    # load raster layers
    source_dir = "/home/cyrilwendl/DeveloppementBase/im_test/Fusion_doubleBat/Classified"
    for files in os.listdir(source_dir):

        # load only raster layers
        if files.endswith(".visu.tif"):
            rlayer = QgsRasterLayer(source_dir + "/" + files, files)
            rlayer.renderer().setOpacity(0.5) 
            
            qgis.utils.iface.mapCanvas().setExtent(rlayer.extent())
            
            # add layer to the registry
            QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
            group_classif.addLayer(rlayer)
            
            legend = qgis.utils.iface.legendInterface()  # access the legend
            legend.setLayerVisible(rlayer, False)  # hide the layer
    
    qgis.utils.iface.mapCanvas().refresh()
    
    # background image (SPOT6)
    rlayer = QgsRasterLayer("/home/cyrilwendl/DeveloppementBase/im_test/Im_SPOT6.tif", "Im_SPOT6")
    QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
    group_classif.addLayer(rlayer)
    qgis.utils.iface.mapCanvas().setExtent(rlayer.extent())
    qgis.utils.iface.mapCanvas().refresh()
    group_classif.setExpanded(False)
    
main()
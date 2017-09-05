from qgis.core import *
from qgis.gui import *
from PyQt4.QtCore import *
from PyQt4 import QtGui
from natsort import natsorted, ns
import os, sys
import qgis
root = QgsProject.instance().layerTreeRoot()

# global parameters
fusion_methods=["all_weighted"]
base_dirs = '/media/cyrilwendl/15BA65E227EC1B23/gironde/detail/'
#im_dirs = ["im_41000_30000", "im_39000_40000","im_39000_42000", "im_41000_40000", "im_41000_42000"]
#im_dirs = ["im_24500_18500,im_26500_18500,im_28500_32500,im_38500_32500,im_10500_34500,im_24500_20500,im_26500_20500,im_30500_30500"]
im_dirs = ["im_10500_34500"]
Fusion_Ouvert=True
Fusion_Sub_Ouvert=False
Fusion_Affiche=False
Background_SPOT_Affiche=False
Regul_Ouvert=True
Opacity_Layers=0.7

def showFusion(index):
    group_fus=root.insertGroup(index,"Fusion")
    # Fusion Classification
    # load raster layers
    for im_dir in natsorted(im_dirs):
        for fusion_method in natsorted(fusion_methods):
            fusion_cl_dir=base_dirs + im_dir +  "/Fusion_" + fusion_method + "/Classified"
            subgroup = group_fus.insertGroup(2, im_dir + "/" + fusion_method)
            subgroup.setExpanded(Fusion_Sub_Ouvert)
            for files in natsorted(os.listdir(fusion_cl_dir)):
                # load only raster layers
                if files.endswith(".visu.tif"):
                    subsubgroup = subgroup.insertGroup(2, files)
                    subsubgroup.setExpanded(Fusion_Sub_Ouvert)
                    rlayer = QgsRasterLayer(fusion_cl_dir + "/" + files, files)
                    rlayer.renderer().setOpacity(Opacity_Layers) 
                    
                    # add layer to the registry
                    QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                    subsubgroup.addLayer(rlayer)
                    
                    legend = qgis.utils.iface.legendInterface()  # access the legend
                    legend.setLayerVisible(rlayer, Fusion_Affiche)  # hide the layer
                    # original classification
                    
                    # background image (SPOT6)
                    rlayer = QgsRasterLayer(base_dirs + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                    QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                    subsubgroup.addLayer(rlayer)
                    legend = qgis.utils.iface.legendInterface()  # access the legend
                    legend.setLayerVisible(rlayer, False)  # hide the layer
                    qgis.utils.iface.mapCanvas().refresh()
                    subsubgroup.setExpanded(False)
    group_fus.setExpanded(Fusion_Ouvert)
    
def showRegul(index):
    # Fusion Classification
    # load raster layers
    group_reg=root.insertGroup(index,"Regulation")
    print im_dirs[0]
    for im_dir in natsorted(im_dirs, reverse=True):
        fusion_cl_dir=base_dirs + im_dir +  "/Regul"
        subgroup = group_reg.insertGroup(1, im_dir)
        for files in natsorted(os.listdir(fusion_cl_dir), reverse=True):
            # load only raster layers
            if files.endswith(".visu.tif"):
                subsubgroup = subgroup.insertGroup(2, files)
                subsubgroup.setExpanded(False)
                rlayer = QgsRasterLayer(fusion_cl_dir + "/" + files, files)
                rlayer.renderer().setOpacity(0.7) 
                
                # add layer to the registry
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                        
                # background image (SPOT6)
                rlayer = QgsRasterLayer(base_dirs + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
        subgroup.setExpanded(False)
    group_reg.setExpanded(Regul_Ouvert)
    
def showOriginal(index): #Original S2 and S6 classifications
    orig_group = root.insertGroup(index, "Original Classification")
    for im_dir in natsorted(im_dirs):
        subgroup = orig_group.insertGroup(1, im_dir)
        cl_dir=base_dirs + im_dir + "/Classified"
        for files in natsorted(os.listdir(cl_dir)):
            # load only raster layers
            if files.endswith(".visu.tif"):
                subsubgroup = subgroup.insertGroup(1, files)
                rlayer = QgsRasterLayer(cl_dir + "/" + files, files)
                rlayer.renderer().setOpacity(Opacity_Layers) 
                
                # add layer to the registry
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer

                # background image (SPOT6)
                rlayer = QgsRasterLayer(base_dirs + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
                subsubgroup.setExpanded(False)
        subgroup.setExpanded(False)
    orig_group.setExpanded(True)

def showGT(index):
    # Fusion Classification
    # load raster layers
    group_gt=root.insertGroup(index,"Ground Truth")
    print im_dirs[0]
    for im_dir in natsorted(im_dirs):
        subgroup = group_gt.insertGroup(1, im_dir)
        rlayer = QgsRasterLayer(base_dirs + im_dir +  "/train.visu.tif", "GT")
        rlayer.renderer().setOpacity(0.7) 
        
        # add layer to the registry
        QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
        subgroup.addLayer(rlayer)
        
        #legend = qgis.utils.iface.legendInterface()  # access the legend
        #legend.setLayerVisible(rlayer, False)  # hide the layer
            
        # background image (SPOT6)
        rlayer = QgsRasterLayer(base_dirs + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
        QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
        subgroup.addLayer(rlayer)
        legend = qgis.utils.iface.legendInterface()  # access the legend
        legend.setLayerVisible(rlayer, True)  # hide the layer
        qgis.utils.iface.mapCanvas().refresh()
        subgroup.setExpanded(False)
    group_gt.setExpanded(False)

    #qgis.utils.iface.mapCanvas().setExtent(group_reg.extent())       
   
def main():
    QSettings().setValue("/Projections/defaultBehaviour", "useGlobal")
    QgsMapLayerRegistry.instance().removeAllMapLayers() # clean up
    
    # Groups
    root.removeAllChildren () # clean up
    showRegul(1)
    showFusion(2)
    showOriginal(3)
    showGT(4)    

main()
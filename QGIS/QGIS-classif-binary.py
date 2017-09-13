from qgis.core import *
from qgis.gui import *
from PyQt4.QtCore import *
from PyQt4 import QtGui
from natsort import natsorted, ns
import os, sys
import qgis
root = QgsProject.instance().layerTreeRoot()

# global parametersc
base_dirs = '/media/cyrilwendl/15BA65E227EC1B23/finistere/detail/'
im_dirs = ["41000_30000"]
#im_dirs = ["im_41000_30000", "im_39000_40000","im_39000_42000", "im_41000_40000", "im_41000_42000"]

Fusion_Ouvert=True
Fusion_Sub_Ouvert=False
Fusion_Affiche=False
Background_SPOT_Affiche=False
Regul_Ouvert=True
Opacity_Layers=0.7

def showSegmentationBin(index):
    group_seg=root.insertGroup(index,"Segmentation")
    # Fusion Classification
    # load raster layers
    for im_dir in natsorted(im_dirs):
        fusion_cl_dir=base_dirs + "im_" + im_dir +  "/Binary/Seg"
        for files in natsorted(os.listdir(fusion_cl_dir)):
            # load only raster layers
            if files.endswith(".visu.tif"):
                subgroup = group_seg.insertGroup(2, files)
                subgroup.setExpanded(Fusion_Sub_Ouvert)
                rlayer = QgsRasterLayer(fusion_cl_dir + "/" + files, files)
                rlayer.renderer().setOpacity(Opacity_Layers) 
                
                # add layer to the registry
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subgroup.addLayer(rlayer)
                
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, Fusion_Affiche)  # hide the layer
                # original classification
                
                # bashowSegmentationBinckground image (SPOT6)
                rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
                subgroup.setExpanded(False)
                    
    group_seg.setExpanded(Fusion_Ouvert)

def showFusionBin(index):
    group_fus=root.insertGroup(index,"Fusion")
    # Fusion Classification
    # load raster layers
    for im_dir in natsorted(im_dirs):
        fusion_cl_dir=base_dirs + "im_" + im_dir +  "/Binary/Fusion/Classified"
        for files in natsorted(os.listdir(fusion_cl_dir)):
            # load only raster layers
            if files.endswith(".visu.tif"):
                subgroup = group_fus.insertGroup(2, files)
                subgroup.setExpanded(Fusion_Sub_Ouvert)
                rlayer = QgsRasterLayer(fusion_cl_dir + "/" + files, files)
                rlayer.renderer().setOpacity(Opacity_Layers) 
                
                # add layer to the registry
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subgroup.addLayer(rlayer)
                
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, Fusion_Affiche)  # hide the layer
                # original classification
                
                # background image (SPOT6)
                rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
                subgroup.setExpanded(False)
                    
    group_fus.setExpanded(Fusion_Ouvert)
    
def showRegulBin(index):
    # Fusion Classification
    # load raster layers
    group_reg=root.insertGroup(index,"Regulation Binary")
    print im_dirs[0]
    for im_dir in natsorted(im_dirs, reverse=True):
        fusion_cl_dir=base_dirs + "im_" + im_dir +  "/Binary/Regul"
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
                rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
        subgroup.setExpanded(False)
    group_reg.setExpanded(Regul_Ouvert)

def showRegul(index):
    # Fusion Classification
    # load raster layers
    group_reg=root.insertGroup(index,"Regulation")
    print im_dirs[0]
    for im_dir in natsorted(im_dirs, reverse=True):
        fusion_cl_dir=base_dirs + "im_" + im_dir +  "/Regul"
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
                rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
                QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
                subsubgroup.addLayer(rlayer)
                legend = qgis.utils.iface.legendInterface()  # access the legend
                legend.setLayerVisible(rlayer, False)  # hide the layer
                qgis.utils.iface.mapCanvas().refresh()
        subgroup.setExpanded(False)
    group_reg.setExpanded(Regul_Ouvert)

    #qgis.utils.iface.mapCanvas().setExtent(group_reg.extent())       
def showOriginal(index): #Original S2 and S6 classifications
    orig_group = root.insertGroup(index, "Original Classification")
    for im_dir in natsorted(im_dirs):
        subgroup = orig_group.insertGroup(1, im_dir)
        cl_dir=base_dirs + "im_" + im_dir + "/Binary/Classified"
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
                rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
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
        rlayer = QgsRasterLayer(base_dirs + "im_" +  im_dir +  "/train.visu.tif", "GT")
        rlayer.renderer().setOpacity(0.7) 
        
        # add layer to the registry
        QgsMapLayerRegistry.instance().addMapLayer(rlayer,False)
        subgroup.addLayer(rlayer)
        
        #legend = qgis.utils.iface.legendInterface()  # access the legend
        #legend.setLayerVisible(rlayer, False)  # hide the layer
        # original classification
            
        # background image (SPOT6)
        rlayer = QgsRasterLayer(base_dirs + "im_" + im_dir + "/Im_SPOT6.tif", "Im_SPOT6")
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
    showSegmentationBin(1)
    showRegulBin(2)
    showFusionBin(3)
    showRegul(4)
    showOriginal(5)
    showGT(6)

main()
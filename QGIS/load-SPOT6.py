from PyQt4.QtCore import QFileInfo,QSettings
from qgis.core import QgsRasterLayer, QgsCoordinateReferenceSystem
import os

def main():
    QSettings().setValue("/Projections/defaultBehaviour", "useGlobal")
    QgsMapLayerRegistry.instance().removeAllMapLayers() # clean up
    source_dir = "/home/cyrilwendl/finistere1/verifavancement/visu.tif"
    
    # load raster layer, "ogr"s
    for files in sorted(os.listdir(source_dir)):

        # load only raster layers
        if files.endswith(".tif"):
            rlayer = QgsRasterLayer(source_dir + "/" + files, files)

            # add layer to the registry
            QgsMapLayerRegistry.instance().addMapLayer(rlayer)

    
main()

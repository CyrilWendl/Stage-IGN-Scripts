from PyQt4.QtCore import QFileInfo,QSettings
from qgis.core import QgsRasterLayer, QgsCoordinateReferenceSystem
import os
from natsort import natsorted, ns

def main():
    QSettings().setValue("/Projections/defaultBehaviour", "useGlobal")
    QgsMapLayerRegistry.instance().removeAllMapLayers() # clean up
    source_dir = "/media/cyrilwendl/15BA65E227EC1B23/gironde/data/SPOT6_gironde/classif/extent"
    
    # load raster layer, "ogr"s
    for files in natsorted(os.listdir(source_dir)):

        # load only raster layers
        if files.endswith(".shp"):
            layer = QgsVectorLayer(source_dir + "/" + files, files,"ogr")

            # add layer to the registry
            QgsMapLayerRegistry.instance().addMapLayer(layer)

    
main()

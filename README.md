# Stage-IGN-Scripts
A series of scripts to produce the artificialized area using fusion and regulation on two individual classifications on SPOT-6 and Sentinel-2 satellite images.

## Files Structure
Files marked as _optional_ can be outcommented in the files marked as **master files** according to the user needs. Scripts needs to be called on the command line as `bash [scriptname].sh [option_1] [option_2] ... [option_n]`

### 1. Main code: per-tile (saved in `[region]/im_[tile_number]/`)
#### 1.1 Fusion and Regularization
**`/detail/master.sh [region] [tile_number]`**: Fusion and regulation in the extent of a SPOT-6 tile with all fusion methods. Parameters to set are `$DIR_DATA`, the input data path and `$DIR_BASH`, the path where the scripts are saved. Options are `[region]`=finistere|gironde, `[tile]`= a valid tile number. Calls the following scripts:
- `fusion_prep.sh`:  Extract SPOT6 probability, extract and crop Sentinel-2 probability save them to folder 
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images, save them to  folder `/im_[tile_number]/` (working in RAM for speed, needs sudo permissions)
- `rasterisation_gt.sh`: Rasterize ground truth and add a sixth buffer class, save it to  folder `/im_[tile_number]/`
- `fusion.sh`: Fusion using all fusion schemes, save them to folder `/im_[tile_number]/` for weighted fusion and `/$DIR_SAVE/im_[tile_number]/Fusion_all` for non-weighted fusion
- `classify.sh`: Produce label images of initial classification and fusion
- _optional_ `fusion_classification.sh`: fusion by classification (rf, svmt2 and svmt0), requires having calculated classification models using `fusion_classification_model.sh [region]`
- `regularize.sh [method]`: Regularize using one of the fusion methods (results in `/im_[tile_number]/Fusion_all_weighted`).
- _optional_ `regularize-crop.sh`: same as `regularize.sh` but with a crop window (for trying various parameters in small zone)
- `eval.sh [options]`: Evaluate all classifications. 
- _optional_ `../detail_binary/master.sh [region] [tile number]`: execute main script for artificialized area (explained below)
- _optional_ `../detail_binary/gt_master.sh [region] [tile number]`: execute main script for obtaining artificialized area ground truth (explained below)

Other scripts in `/detail/`:
- `eval_all_zones.sh [region]`: evaluation of several tiles
- `fusion_classification_model.sh [region]`: train RF, SVM t0 and SVM t2 classification models based on the ground truth of several tiles for fusion by classification. Is best exectued after `master.sh`, then `master.sh` can be executed again producing only fusion by classification with `fusion_classification.sh`.


#### 1.2 Artificialized Area
**`/detail_binary/master.sh [region] [tile number]`**: binary fusion and regulation for artificialized area on tiles produced by _detail_/`master.sh`, all results saved in `$DIR_SAVE/im_[tile number]/Binary`
- `fusion_prep.sh`:  Get binary probabilities from regularization result (distance dilatation) and Sentinel-2 classifier (`/Binary`)
- `fusion.sh`: Fusion using the Min and Bayes rules (`/Binary/Fusion`)
- `classify.sh`: Get class labels for input probabilities and fusion (`/Binary`,`/Binary/Fusion`)
- `regularize.sh`: Regularization of fusion input (`/Binary/Regul`)
- `segmentation.sh`: Refine regularization result using segmentation on the Sentinel-2 image (`/Binary/Seg`)

**`/detail_binary/gt_master.sh [region] [tile number]`**: get binary ground truth of artificialized area and evaluate binary 
classifications. Requires BDTOPO, OSO and OSM data to be saved in `/im_[tile number]/gt` Calls:
- `gt_bdtopo.sh`: extract building labels from bdtopo, progressively dilate them by 20 m radius 
- `gt_oso.sh`: extract urban labels by regrouping the [OSO](http://osr-cesbio.ups-tlse.fr/~oso/) classes corresponding to urbanized areas
- `gt_osm.sh`: extracts binary ground truth from OSM (OpenStreetMaps) landcover layer where the class attribute is "residential"
- `gt_eval_label.sh`: create binary difference maps between all labels in `/im_[tile number]/gt/eval`
- `gt_eval.sh`: get accuracy measures over all tiles (five for finistere), saved in `/[region]/Eval_bin/eval.txt`

_not used_ `bdparcellaire.sh`: extract BD parcellaire for majority voting in segments

### 2. Main Code: Several Tiles  (saved in `[region]/all/`)
#### 2.1 Fusion and Regularization
**`/all_tiles/master.sh [region] [tiles]`**: fusion of all tiles covered by both classifiers in main memory, output saved to /`[region]`/all. Tiles can be obtained by calling `TILES=$(bash tools/overlapping_tiles.sh [region])`. The code works similar to detail/`master.sh` but does everything in main memory and saves the output to the HDD for speed reasons. Accuracy measures are not produced.
- `fusion_prep.sh`:  Extract SPOT6 and Sentinel-2 probabilities
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images
- `fusion.sh`: Fusion using the Min and Bayes fusion schemes
- `classify.sh`: Produce classification labels
- `regularize.sh [method]`: Regularization using one of the fusion methods

#### 2.2 Artificialized Area
**`/all_binary/master.sh [region] [tile SPOT6]`**: binary fusion, regulation and segmentation for artificialized area on all tilesall

**`/all_gt/gt_master.sh`**: get BDTOPO ground truths and binary ground truths for entire covered zone (Finistère only)

### 3. Tools
**`/Sentinel-2/`**: initial classification of Sentinel-2 image using RF
- `sentinel-2-resize.sh`: Resizing of bands 5, 6, 7, 8A, 11, 12 to 10m
- `sentinel-2-gt.sh`: Extract GT for model training within Sentinel-2 image area
- `sentinel-2-classif.sh`: Model and classification of Sentinel-2 image series

**`/tools/`**: various generic scripts (gdal, etc.)
- `xargs.sh`: Parallelize certain script executions
- `raster_crop.sh [big_raster] [small_raster] [out_raster]`: Crop a GTiff raster to the extent of a second GTiff raster
- `resize_crop_raster.sh [big_raster] [small_raster] [out_raster]`: Crop resize a GTiff raster to the extent and resolution of a second GTiff raster
- `resize_crop_raster.sh [raster_to_resize] [raster] [out_raster]`: Resize a GTiff raster to resolution of a second GTiff raster
- `gdalminmax.sh [folder]`: Will check the regularization result in a folder and return 1 if the regularization  has converged and 0 otherwise (all labels are the same), using the min/max pixel value info from gdalinfo.
- `raster_extent.py`: Get the extent (xmin ymin xmax ymax) coordinates for a given raster.
- `overlapping_tiles.sh [region]`: Get the tile names of all SPOT-6 tiles which overlap with the Sentinel-2 classification, output classification extents to `$DIR_DATA/extent/`.

**`/exes/`**: executables (need dependencies to work), usage of executables documented in `documentation.odt`

**`/QGIS/`**: scripts for visualization of results of `/detail/master.sh`
- `QGIS-classif.py`: load ground truth, initial classification, fusion and regularization results
- `QGIS-classif-binary.py`: load ground truth, input data, fusion and regularization for artificialized area 

**`/report/`**: 
- `report_images_all_tiles.sh`: create compressed JPEG images of the results on all tiles in `/[region]/all/tiles'`
- `report_images_resize.sh [region] [tile_number]`: create compressed JPEG images for one tile in /`[region]`/im_`[tile_number]`/web
- `report_bati_dist.sh`: get figure of building distances in report
- `report-txt-to-tex.sh`: format accuracy measures as LaTeX table
- `report-txt-to-tex-eval-bin.sh [region]`: format binary accuracy measures as LaTeX table
- `plot_pixelProbas.py` output a PDF with a 4\*4 plot of probability values before and after weighting at a certain coordinate within a tile

**`documentation.odt`**: Documentation of executables developted at the MATIS

# System Requirements
The code was developed and tested on the following machine:
- OS: Ubuntu 16.04 LTS 64-bit
- Processor: Intel® Xeon(R) CPU E5-2665 0 @ 2.40GHz × 16 cores
- Graphics: Gallium 0.4 on NVE7
- RAM: 8 GB
- Storage: 500 GB HDD

# Supervisors
- Arnaud Le-Bris, IGN, MATIS
- Nesrine Chehata, IGN, MATIS
- Frank de Morsier, EPFL
- Anne Le-Puissant, LIVE, Université de Strassbourg

Contact: [mailto:cyril.wendl@epfl.ch](Cyril Wendl)

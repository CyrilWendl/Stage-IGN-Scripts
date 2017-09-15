# Stage-IGN-Scripts
A series of scripts for fusion of two classifications probabilities.
Folder structure of required files in folder-structure.txt
## Files Structure
Files marked as _optional_ can be outcommented in the files marked as **master files** according to the user needs. Scripts needs to be called on the command line as `bash [scriptname].sh [option_1] [option_2] ... [option_n]`
### 1. Main code: per-tile (saved in `[region]/im_[tile_number]/`)
#### 1.1 Fusion and Regularization
**detail/`master.sh [region] [tile_number]`**: Fusion and regulation in the extent of a SPOT-6 tile with all fusion methods. Parameters to set are `$DIR_DATA`, the input data path and `$DIR_BASH`, the path where the scripts are saved. Options are `[region]`=finistere|gironde, `[tile]`= a valid tile number. Calls the following scripts:
- `fusion_prep.sh`:  Extract SPOT6 probability, extract and crop Sentinel-2 probability save them to folder 
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images, save them to  folder `/im_[tile_number]/` (working in RAM for speed, needs sudo permissions)
- `rasterisation_gt.sh`: Rasterize ground truth and add a sixth buffer class, save it to  folder `/im_[tile_number]/`
- `fusion.sh`: Fusion using all fusion schemes, save them to folder `/im_[tile_number]/` for weighted fusion and `/$DIR_SAVE/im_[tile_number]/Fusion_all` for non-weighted fusion
- `classify.sh`: Produce label images of initial classification and fusion
- _optional_ `fusion_classification.sh`: fusion by classification (rf, svmt2 and svmt0), requires having calculated classification models using `fusion_classification_model.sh [region]`
- `regularize.sh [method]`: Regularize using one of the fusion methods (results in `/im_[tile_number]/Fusion_all_weighted`).
- `eval.sh [options]`: Evaluate all classifications. 
- _optional_ `../detail_binary/master.sh [region] [tile number]`: execute main script for artificialized area (explained below)
- _optional_ `../detail_binary/gt_master.sh [region] [tile number]`: execute main script for obtaining artificialized area ground truth (explained below)

#### 1.2 Artificialized Area
**detail_binary/`master.sh [region] [tile number]`**: binary fusion and regulation for artificialized area on tiles produced by _detail_/`master.sh`, all results saved in `$DIR_SAVE/im_[tile number]/Binary`
- `fusion_prep.sh`:  Get binary probabilities from regularization result (distance dilatation) and Sentinel-2 classifier (`/Binary`)
- `fusion.sh`: Fusion using the Min and Bayes rules (`/Binary/Fusion`)
- `classify.sh`: Get class labels for input probabilities and fusion (`/Binary`,`/Binary/Fusion`)
- `regularize.sh`: Regularization of fusion input (`/Binary/Regul`)
- `segmentation.sh`: Refine regularization result using segmentation on the Sentinel-2 image (`/Binary/Seg`)

**detail_binary/`gt_master.sh [region] [tile number]`**: get binary ground truth of artificialized area and evaluate binary 
classifications. Requires BDTOPO, OSO and OSM data to be saved in `/im_[tile number]/gt` Calls:
- `gt_bdtopo.sh`: extract building labels from bdtopo, progressively dilate them by 20 m radius 
- `gt_oso.sh`: extract urban labels by regrouping the [OSO](http://osr-cesbio.ups-tlse.fr/~oso/) classes corresponding to urbanized areas
- `gt_osm.sh`: extracts binary ground truth from OSM (OpenStreetMaps) landcover layer where the class attribute is "residential"
- `gt_eval_label.sh`: create binary difference maps between all labels in `/im_[tile number]/gt/eval`
- `gt_eval.sh`: get accuracy measures over all tiles (five for finistere), saved in `/[region]/Eval_bin/eval.txt`

### 2. Main Code: Several Tiles
#### 2.1 Fusion and Regularization
**all\_tiles/`master.sh [region] [tiles]`**: fusion of all tiles covered by both classifiers in main memory, output saved to /`[region]`/all. Tiles can be obtained by calling `TILES=$(bash tools/overlapping_tiles.sh [region])`. The code works similar to detail/`master.sh` but does everything in main memory and saves the output to the HDD for speed reasons. Accuracy measures are not produced.
- `fusion_prep.sh`:  Extract SPOT6 and Sentinel-2 probabilities
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images
- `fusion.sh`: Fusion using the Min and Bayes fusion schemes
- `classify.sh`: Produce classification labels
- `regularize.sh [method]`: Regularization using one of the fusion methods

#### 2.2 Artificialized Area
**_binary_all_/`master.sh [region] [tile SPOT6]`**: binary fusion, regulation and segmentation for artificialized area on all tiles
**_all_gt_/**: get BDTOPO ground truths and binary ground truths for entire covered zone (Finistère only)

### Tools
`/Sentinel-2/`: initial classification of Sentinel-2 image using RF
`/tools/`: various generic scripts (gdal, etc.)
  - `xargs.sh`: parallelize certain script executions
  - `raster_crop.sh [big_raster] [small_raster] [out_raster]`: Crop a GTiff raster to the extent of a second GTiff raster
  - `resize_crop_raster.sh [big_raster] [small_raster] [out_raster]`: Crop resize a GTiff raster to the extent and resolution of a second GTiff raster
  - `resize_crop_raster.sh [raster_to_resize] [raster] [out_raster]`: Resize a GTiff raster to resolution of a second GTiff raster
  - `gdalminmax.sh [folder]`: Will check the regularization result in a folder and return 1 if the regularization  has converged and 0 otherwise (all labels are the same), using the min/max pixel value info from gdalinfo.
  - `raster_extent.py`: Get the extent (xmin ymin xmax ymax) coordinates for a given raster.
  - `overlapping_tiles.sh [region]`: Get the tile names of all SPOT-6 tiles which overlap with the Sentinel-2 classification.
`/exes/`: executables (need dependencies to work)
`/QGIS/`: scripts for visualization of results of `/detail/master.sh`
`/report/`: 
  - `report_images_all_tiles.sh`: create compressed JPEG images of all tiles
  - `report_images_resize.sh [region] [tile_number]`: get all images for one tile as JPEGs in /`[region]`/im_`[tile_number]`/web
  - `report_bati_dist.sh`: get figure of building distances in report
  - `report-txt-to-tex.sh`: get figure of building distances in report
  - `report-txt-to-tex-eval-bin.sh [region]`: format accuracy measures as LaTeX table
  - `plot_pixelProbas.py` output a 4\*4 plot of probability values before and after weighting
  


## System Requirements
The code was developed and tested on the following machine
- OS: Ubuntu 16.04
- 8 GB RAM, 16 cores processor


## Supervisors
- Arnaud Le-Bris, IGN, Matis
- Nesrine Chehata, IGN, Matis
- Frank de Morsier, EPFL
- Anne Le-Puissant, LIVE, Université de Strassbourg

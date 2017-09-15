# Stage-IGN-Scripts
A series of scripts for fusion of two classifications probabilities.
Folder structure of required files in folder-structure.txt
## Files Structure
Files marked as _optional_ can be outcommented in the files marked as **master files** according to the user needs. Scripts needs to be called on the command line as `bash [scriptname].sh [option_1] [option_2] ... [option_n]`
### Main code: per-tile
**detail/`master.sh [region] [tile_number]`**: Fusion and regulation in the extent of a SPOT-6 tile with all fusion methods. Parameters to set are `$DIR_DATA`, the input data path and `$DIR_BASH`, the path where the scripts are saved. Options are `[region]`=finistere|gironde, `[tile]`= a valid tile number. Calls the following scripts:
- `fusion_prep.sh`:  Extract SPOT6 probability, extract and crop Sentinel-2 probability save them to folder 
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images, save them to  folder `$DIR_SAVE/im_[tile_number]/` (working in RAM for speed, needs sudo permissions)
- `rasterisation_gt.sh`: Rasterize ground truth and add a sixth buffer class, save it to  folder `/_$DIR_SAVE_/im_[tile_number]/`
- `fusion.sh`: Fusion using all fusion schemes, save them to folder `/$DIR_SAVE/im_[tile_number]/Fusion_all_weighted` for weighted fusion and `/$DIR_SAVE/im_[tile_number]/Fusion_all` for non-weighted fusion
- `classify.sh`: Produce label images of initial classification and fusion
- _optional_ `fusion_classification`.sh: fusion by classification
- `regularize.sh [method]`: Regularize using one of the fusion methods (results in `/$DIR_SAVE/im_[tile_number]/Fusion_all_weighted`).
- `eval.sh [options]`: Evaluate all classifications. 
- _optional_ `../binary/master.sh [region] [tile number]`: execute main script for artificialized area (explained below)
- _optional_ `../binary/gt_master.sh [region] [tile number]`: execute main script for obtaining artificialized area ground truth (explained below)

**binary/`master.sh [region] [tile number]`**: binary fusion and regulation for artificialized area on tiles produced by _detail_/`master.sh`
- `fusion_prep.sh`:  Get binary probabilities from regularization result (distance dilatation) and Sentinel-2 classifier
- `fusion.sh`: Fusion using the Min and Bayes rules
- `classify.sh`: Get class labels for input probabilities and fusion
- `regularize.sh`: Regularization of fusion input
- `segmentation.sh`: Refine regularization using segmentation on the Sentinel-2 image

**binary/`gt_master.sh [region] [tile number]`**: get binary ground truth of artificialized area and evaluate binary classifications. Calls:
- `gt_oso.sh`
- `gt_osm.sh`
- `gt_bdtopo.sh`

### Main code: several tiles
**all\_tiles/`master.sh`**: fusion of all tiles covered by both classifiers in main memory, output saved to /`[region]`/all
- `fusion_prep.sh`:  Extract SPOT6 probability, extract and crop Sentinel-2 probability save them to folder 
- `copy_images.sh`: Extract SPOT-6 and Sentinel-2 original images, save them to  folder `$DIR_SAVE/im_[tile_number]/` (working in RAM for speed, needs sudo permissions)
- `rasterisation_gt.sh`: Rasterize ground truth and add a sixth buffer class, save it to  folder `/_$DIR_SAVE_/im_[tile_number]/`
- `fusion.sh`: Fusion using all fusion schemes, save them to folder `/$DIR_SAVE/im_[tile_number]/Fusion_all_weighted` for weighted fusion and `/$DIR_SAVE/im_[tile_number]/Fusion_all` for non-weighted fusion
- `classify.sh`: Produce label images of initial classification and fusion
- _optional_ `fusion_classification`.sh: fusion by classification
- `regularize.sh [method]`: Regularize using one of the fusion methods (results in `/$DIR_SAVE/im_[tile_number]/Fusion_all_weighted`).
- `eval.sh [options]`: Evaluate all classifications. 
- _optional_ `../binary/master.sh`: execute main script for artificialized area (explained below)
- _optional_ `../binary/gt_master.sh`: execute main script for obtaining artificialized area ground truth (explained below)



**_binary_all_/`master.sh`**: binary fusion and regulation for artificialized area on all tiles
**_all_gt_/**: get BDTOPO ground truths and binary ground truths for entire covered zone (Finistère only)

### Tools
_Sentinel-2_: initial classification of Sentinel-2 image using RF
_tools_/: various generic scripts (gdal, etc.)
_exes_/: executables
_QGIS_/: scripts for visualization of results of `/detail/master.sh`
_report_/: 
  - `report_images_all_tiles.sh`: create compressed JPEG images of all tiles
  - `report_images_resize.sh [region] [tile_number]`: get all images for one tile as JPEGs in /`[region]`/im_`[tile_number]`/web
  - `report_bati_dist.sh`: get figure of building distances in report
  - `report-txt-to-tex.sh`: get figure of building distances in report
  - `report-txt-to-tex-eval-bin.sh [region]`: format accuracy measures as LaTeX table
  


## System Requirements
The code was developed and tested on the following machine
- OS: Ubuntu 16.04
- 8 GB RAM, 16 cores processor

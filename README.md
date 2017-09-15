# Stage-IGN-Scripts
A series of scripts for fusion of two classifications probabilities.
Folder structure of required files in folder-structure.txt

## Files to use
- _detail_/master.sh: fusion on a tile with all fusion methods, calls:
  - _binary_/master.sh: binary fusion and regulation for artificialized area on tiles produced by _detail_/master.sh
  - _tools_/: various generic scripts (gdal, etc.)
- _all_tiles_/master.sh: fusion of all tiles in main memory, output saved to /\[region\]/all
  - _binary_all_/master.sh: binary fusion and regulation for artificialized area on all tiles
	- _all_gt_/: get BDTOPO ground truths and binary ground truths for entire covered zone (Finistère only)  
- _Sentinel-2_: initial classification of Sentinel-2 image using RF
- _QGIS_/: scripts for visualization of results of /detail/master.sh
- _report_/:


## System Requirements
The code was developed and tested on the following machine
- OS: Ubuntu 16.04
- 8 GB RAM, 16 cores processor

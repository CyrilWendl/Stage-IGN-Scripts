# Stage-IGN-Scripts
A series of scripts for fusion of two classifications probabilities.
Folder structure of required files in folder-structure.txt

## Files to use
1. _Sentinel-2_: scripts for initial classification of Sentinel-2 image using RF
1. _detail_/master.sh: script to launch for fusion on a tile with all fusion methods
2. _all_tiles_/master.sh: fusion of all tiles in memory
3. _fusion_regul/master.sh: second fusion and regulation for artificialized area on tiles produced by _detail_/master.sh
3. _fusion_regul_all_/master.sh: second fusion and regulation for artificialized area on all tiles
4. _QGIS_/: scripts for visualization of results of /detail/master.sh

## System Requirements
The code was developed and tested on the following machine
- OS: Ubuntu 16.04
- 8 GB RAM, 16 cores processor

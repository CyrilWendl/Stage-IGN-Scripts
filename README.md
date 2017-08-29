# Stage-IGN-Scripts
A series of scripts for fusion of two classifications probabilities.
Folder structure of required files:
[region]
├── data
│   ├── GT # ground truth for classification and evaluation
│   │   ├── BDTOPO
│   │   │   ├── A_RESEAU_ROUTIER
│   │   │   ├── B_VOIES_FERREES_ET_AUTRES
│   │   │   ├── C_TRANSPORT_ENERGIE
│   │   │   ├── D_HYDROGRAPHIE
│   │   │   ├── E_BATI
│   │   │   ├── F_VEGETATION
│   │   │   ├── G_OROGRAPHIE
│   │   │   ├── H_ADMINISTRATIF￼ ￼ ￼
￼ Edit file  
│   │   │   ├── I_ZONE_ACTIVITE
│   │   │   └── T_TOPONYMES
│   │   └── RPG
│   ├── S2_<region> # Sentinel-2 data
│   │   ├── 20160901 # folders containing B2, B3, B4... of same resolution (upscaled)
│   │   ├── 20161130
│   │   ├── ...
│   │   └── S2_data (original data)
│   │       ├── SENTINEL2A_20160901-110708-860_L2A_T30TXQ_D_V1-1
│   │       ├── SENTINEL2A_20161130-110418-460_L2A_T30TXQ_D_V1-1
│   │       │   ...
│   └── SPOT6_<region> # SPOT 6 data
│       ├── image (original image)
│       └── proba
│           ├── test_10500_10500 
│           │   └── classification_results
│           │       └── preds # probability for a given tile
│           ├── test_...
└── detail # results of master.sh are saved here
    ├── im_38500_32500
    │   ├── Classified
    │   ├── Eval
    │   ├── Fusion_all
    │   │   └── Classified
    │   ├── Fusion_all_weighted
    │   │   └── Classified
    │   └── Regul
    └── im_41000_420000

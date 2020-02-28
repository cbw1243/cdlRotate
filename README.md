## cdlRotate: Access Cropland Data Layer (CDL) data and calculate land use changes over time

The Cropland Data Layer (CDL) is a raster, geo-referenced, crop-specific land cover data layer that provides crop-specific land cover classification product of more than 100 crop categories grown in the United States over time. It is provided by the National Agricultural Statistics Service (NASS) of the United States Department of Agriculture. The [CropScape](https://nassgeodata.gmu.edu/CropScape/) is a an web interface to access the visualize the CDL data. 

The objectives of the `cdlRotate` package are twofold. First, it aims to provide easy access to data for any Area Of Interest (AOI) specified by users. The AOI could be a county, a triangle, a rectangle, or a single point. Second, it aims to calculate land use changes, including crop rotations (e.g., corn -- soybeans) over time for an AOI. 


## Package installation   
To install the package, run the following codes in `R`:
```
install.packages("devtools") # Run this if the devtools package is not installed.     
devtools::install_github("cbw1243/cdlRotate")  
```

## Note   
The package is initially released on Feb. 27, 2020. I am seeking for user feedbacks to improve on the package. So, any feedback is very welcomed. Just a reminder: I could make changes to the package. So please use the most recent version of the package. **Install again before using it**. 

Contact: Bowen Chen, PhD (bwchen@illinois.edu) 

## Acknowledgement     
The development of this package was supported by USDA-NRCS Agreement No. NR193A750016C001 through the Cooperative Ecosystem Studies Units network. Any opinions, findings, conclusions, or recommendations expressed are those of the author(s) and do not necessarily reflect the view of the U.S. Department of Agriculture. 

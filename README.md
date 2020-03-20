## cdlRotate: Access Cropland Data Layer (CDL) data and calculate land use changes over time

The [Cropland Data Layer (CDL)](https://www.nass.usda.gov/Research_and_Science/Cropland/sarsfaqs2.php) is a raster, geo-referenced, crop-specific land cover data layer, and it provides crop-specific land cover classification product of more than 100 crop categories grown in the United States over time. The CDL is administered by the National Agricultural Statistics Service (NASS) of the United States Department of Agriculture. 

All historical CDL products are available for use and free for download through [CropScape](https://nassgeodata.gmu.edu/CropScape/), a web interface. However, the CropScape does not provide services of bulk downloading or calculation of land use changes over time, which could lead to inconvience in empirical works. The development of the `cdlRotate` aims to fill this gap. 

Specifically, the objectives of the `cdlRotate` package are threefold. First, it aims to provide easy access to data for any Area Of Interest (AOI) specified by users. The AOI could be a county, a triangle, a rectangle, or a single point. Second, it aims to calculate land use changes, including crop rotations (e.g., corn -- soybeans) over time for an AOI. Third, it visualizes the data on land use changes for an AOI. 

## Key functions   
The `cdlRotate` package contains three functions to achieve the objectives: 

- Data access    

The `GetCDLData` function is a wrapper function that downloads the data for an user specified AOI. An AOI could be a county defined by FIPS code, a triangle defined by three coordinates, a rectangle defined by four corner points, or a single point defined by a coordinate. The coordinates can be longitude/latitude. Below are two examples, and more examples are provided in the help file of `GetCDLData`.    
```
# Example 1. Retrieve data for the Champaign county in Illinois (FIPS = 17109) in 2018.
data <- GetCDLData(aoi = 17019, year = 2018, type = 'f')

# Example 2. Retrieve data for a triangle defined by three coordinates in 2018.
data <- GetCDLData(aoi = c(175207,2219600,175207,2235525,213693,2219600), year = 2018, type = 'ps')

# Example 3. Retrieve data for a single point by long/lat in 2018.
data <- GetCDLData(aoi = c(-94.6754,42.1197), year = 2018, type = 'p', crs = '+init=epsg:4326')
```
The retrieved data can be a raster file or a matrix, depending on users' choice of the `mat` argument in `GetCDLData` function. The data can then be saved using a standard approach. Note that `GetCDLData` retrieves data for one AOI in one year at a time. Users could use functions in the `apply` family to retrieve data for multiple AOIs in multiple years.   

- Land use change   
The `rotate` function calculates land use changes between any two years. For instance, if user is interested in land use change for the Champaign county from 2017 to 2018, run the following codes: 
```
rotatedata <- rotate(aoi = 17019, year1 = 2017, year2 = 2018, type = 'f')
```
The syntax of the `rotate` function is straightforward. The function is flexible with the choice of time. For example, users could also let `year1` be 2010 and `year2` be 2018 to investigate the land use changes in the long run. The returned file is a data frame that records number of pixels (or grid cells). For CDL at 30-meter resolution, each pixel represents an area of 900 square meters.   

- Land use visualization   

The `plorRot` function visualizes the land use change data generated by the `rotate` function. The returned file is a `ggplot` object since it is built on the `ggplot2` package.    
```
plotRot(rotate) 
```

## Package installation   
To install the package, run the following codes in `R`:
```
install.packages("devtools") # Run this if the devtools package is not installed.     
devtools::install_github("cbw1243/cdlRotate")  
```
Note the `cdlRotate` package depends on the `rgdal` and `sp` packages to process the raster files. 

## Development   
The package is initially released on February 27, 2020 at GitHub to collect users feedbacks. The package will be submitted to CRAN. If you have any suggestion, please contact the author.

Note that the package could be updated at any time at the current stage. To enjoy the latest version, install again before using it.

## Acknowledgement      
The development of this package was supported by USDA-NRCS Agreement No. NR193A750016C001 through the Cooperative Ecosystem Studies Units network. Any opinions, findings, conclusions, or recommendations expressed are those of the author(s) and do not necessarily reflect the view of the U.S. Department of Agriculture. 

## Contact   
[Bowen Chen](https://sites.google.com/view/bwchen), PhD (bwchen@illinois.edu)

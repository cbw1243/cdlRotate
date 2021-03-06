#' Access CDL raster data
#'
#' A function that retrieves CDL raster data for any area of interests for a year.
#'
#' @param aoi Area of interest. Could be a county FIPS code, a coordinate with two numeric values, multiple coordinates (e.g, three coordinates that defines a triangle),
#' or four values that defines a rectangle. The default coordinate system (used by CDL) is the Albers equal-area conic projection, or Albers projection. Users can provide
#' coordinates from a different projection method, but user have to specify the coordinate system in the \code{crs} argument.
#' For example, users can provide longitude/latitude coordinates here, while letting \code{crs} be '+init=epsg:4326'.
#' @param year  year of data to request. Can be a numerical value or a character.
#' @param type type of aoi. 'f' for county, 'ps' for points, 'b' for box, 'p' for a single point.
#' @param mat TRUE/FALSE. If FALSE (default), return a raster file; if TRUE, return a matrix that saves the data.
#' @param crs projection system for the coordinate, such as '+init=epsg:4326' for longitude/latitude.
#'
#' @return
#' The function returns a raster file or a matrix that saves the land use information. The file that matches the category codes with the category names
#' are available at~\url{https://www.nass.usda.gov/Research_and_Science/Cropland/docs/cdl_codes_names.xlsx}. Or simply use data(linkdata)
#'
#' @export
#'
#' @examples
#'
#' # Example 1. Retrieve data for the Champaign county in Illinois (FIPS = 17109) in 2018.
#' data <- GetCDLData(aoi = 17019, year = 2018, type = 'f')
#' raster::plot(data) # plot the data.
#'
#' # Example 2. Retrieve data for a single point by long/lat in 2018.
#' data <- GetCDLData(aoi = c(-94.6754,42.1197), year = 2018, type = 'p', crs = '+init=epsg:4326')
#' data
#' # Below uses the same point, but under the default coordinate system
#' data <- GetCDLData(aoi = c(108777,2125055), year = 2018, type = 'p')
#' data
#'
#' # Example 3. Retrieve data for a triangle defined by three coordinates in 2018.
#' data <- GetCDLData(aoi = c(175207,2219600,175207,2235525,213693,2219600), year = 2018, type = 'ps')
#' raster::plot(data)
#'
#' # Example 4. Retrieve data for a rectangle box defined by three corner points in 2018.
#' data <- GetCDLData(aoi = c(130783,2203171,153923,2217961), year = '2018', type = 'b')
#' raster::plot(data)
#'
GetCDLData <- function(aoi = NULL, year = NULL, type = NULL, mat = FALSE, crs = NULL){
  targetCRS <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

  if(!type %in% c('f', 'ps', 'b', 'p')) stop('The type value is wrong.')

  if(type == 'f'){
    data <- countydata(fips = aoi, year = year)
  }

  if(type == 'ps'){
    if(length(aoi) < 6) stop('For points, at least 6 values (3 coordinate points) have to be provided for aoi.')
    if(!is.null(crs)){
      numps <- length(aoi) # Number of points
      oldpoints <- sp::SpatialPoints(cbind(aoi[seq(1, numps, by = 2)], aoi[seq(2, numps, by = 2)]), sp::CRS(crs))
      newpoints <- sp::spTransform(oldpoints, targetCRS)
      aoi <- paste0(as.vector(t(newpoints@coords)), collapse = ',')
    }
    data <- pointSdata(points = aoi, year = year)
  }

  if(type == 'b'){
    if(length(aoi) != 4) stop('For box, 4 values (2 coordinate points) have to be provided for aoi.')
    if(!is.null(crs)){
      numps <- length(aoi) # Number of points
      oldpoints <- sp::SpatialPoints(cbind(aoi[seq(1, numps, by = 2)], aoi[seq(2, numps, by = 2)]), sp::CRS(crs))
      newpoints <- sp::spTransform(oldpoints, targetCRS)
      aoi <- paste0(as.vector(t(newpoints@coords)), collapse = ',')
    }
    data <- boxdata(box = aoi, year = year)
  }

  if(type == 'p'){
    if(!is.null(crs)){
      oldpoints <- sp::SpatialPoints(cbind(aoi[1], aoi[2]), sp::CRS(crs))
      newpoints <- sp::spTransform(oldpoints, targetCRS)
      aoi <- unlist(newpoints@coords)
    }
    data <- pointdata(point = aoi, year = year)
  }

  if(isTRUE(mat) & type %in% c('f', 'ps', 'b')){
    data <- raster::rasterToPoints(data)
    colnames(data) <- c('x', 'y', 'value')
  }
  return(data)
}


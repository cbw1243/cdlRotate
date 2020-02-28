#' Generate land use transition data for area of interest.
#'
#' A function that generate land use transitions from year1 to year2 for area of interest.
#'
#' @param aoi Area of interest. Could be a county FIPS code, a coordinate with two numeric values, multiple coordinates (e.g, three coordinates that defines a triangle),
#' or four values that defines a rectangle. The default coordinate system (used by CDL) is the Albers equal-area conic projection, or Albers projection. Users can provide
#' coordinates from a different projection method, but user have to specify the coordinate system in the \code{crs} argument.
#' For example, users can provide longitude/latitude coordinates here, while letting \code{crs} be '+init=epsg:4326'.
#' @param year1  Land use in year1. Can be a numerical value or a character.
#' @param year2  Land use in year2. Can be a numerical value or a character.
#' @param type type of aoi. 'f' for county, 'ps' for points, 'b' for box, 'p' for a single point.
#' @param crs projection system for the coordinate, such as '+init=epsg:4326' for longitude/latitude.
#'
#' @return
#' The function returns a raster file or a matrix that saves the land use information.
#'
#'
#' @export
#'
#' @examples
#'
#' # Example 1. Retrieve land use change data for Champaign, Illinois (FIPS = 17109) from 2017 to 2018.
#' data <- rotate(aoi = 17019, year1 = 2017, year2 = 2018, type = 'f')
#' plotRot(data, top = 3) # plot the data.
#'
#' # Example 2. Retrieve data for a triangle defined by three coordinates from 2017 to 2018.
#' data <- rotate(aoi = c(175207,2219600,175207,2235525,213693,2219600),
#'         year1 = 2017, year2 = 2018, type = 'ps')
#' plotRot(data, top = 3)
#'
#' # Example 4. Retrieve data for a rectangle box defined by three corner points from 2017 to 2018.
#' data <- rotate(aoi = c(130783,2203171,153923,2217961), year1 = 2017, year2 = 2018, type = 'b')
#' plotRot(data, top = 3)
#'
#'
rotate <- function(aoi, year1, year2, type = NULL, crs = NULL){
  datat1 <- GetCDLData(aoi = aoi, year = year1, mat = TRUE, type = type, crs = crs)
  datat2 <- GetCDLData(aoi = aoi, year = year2, mat = TRUE, type = type, crs = crs)

  datat1 <- data.table::as.data.table(datat1)
  datat2 <- data.table::as.data.table(datat2)

  data12 <- merge(datat1, datat2, by = c('x', 'y'))

  pixelcounts <- as.data.frame(data12)
  pixelcounts <- dplyr::group_by(pixelcounts, value.x, value.y)
  pixelcounts <- dplyr::summarise(pixelcounts, counts = dplyr::n())
  pixelcounts <- dplyr::arrange(pixelcounts, dplyr::desc(counts))

  return(pixelcounts)
}


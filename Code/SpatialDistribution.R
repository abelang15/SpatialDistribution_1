library(raster)
library(rgdal)
install.packages("biomod2")
library(biomod2)

library(sf)
library(terra)

#setting working directory
Bison <- read.table("bison_local.txt", sep = "\t", header = TRUE, fill = TRUE, quote = "")

#reduce the dataset to latitude and longitude
Bison <- Bison[, c("decimallongitude", "decimallatitude")]

Bison <- na.omit(Bison) #Remove any values where latitude or longitude coordinates are NA

#only keep unique values - removes duplicate rows
Bison <- unique(Bison)

install.packages("SpatialPoints")


Bison.sp <- SpatialPoints(cbind(Bison$decimallongitude, Bison$decimallatitude))
proj4string(Bison.sp) <- "+proj=longlat +datum=WGS84 +no_defs"


sdbound <- readOGR("C:/Users/abela/OneDrive/Desktop/SpatialDistribution_1/NBD_Boundry/COUNTY_BOUNDRY/FWS_National_Wilderness_Ext.shp", layer = "FWS_National_Wilderness_Ext")
proj4string(sdbound)

dem <- raster("DEM")
proj4string(dem)


setwd("Bioclim_tiles")
bioclim <- stack(list.files(pattern = "*.tif$", full.names = TRUE))


# Create copies of the Boundary, projected to the same projections
# as the DEM and Bioclim rasters, respectively
sdbound.dem <- spTransform(sdbound, crs(dem))
sdbound.bioclim <- spTransform(sdbound, crs(bioclim))


# Use the 'crop' function to crop the layers digital elevation model and
# stack of bioclim layers
dem.crop <- crop(dem, sdbound.dem)
bioclim.crop <- crop(bioclim, sdbound.bioclim)


dem.bioclim <- projectRaster(dem.crop, bioclim.crop)

PredVars <- stack(bioclim.crop, dem.bioclim)


Bison.sp.bioclim <- spTransform(Bison.sp, crs(PredVars))

# Now we can plot everything and make sure they line up:
plot(PredVars[[1]])  #Only plots the first layer from the stack of predictor variables
plot(Bison.sp.bioclim, add = T)  #plot the locality points
plot(sdbound.bioclim, add = T)  #plot the County boundary.


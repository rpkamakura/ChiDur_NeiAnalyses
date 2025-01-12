Code and Data accompanying manuscript: Social and physical changes related to gentrification and the number, diversity, and stress of street trees in two U.S. cities

* 01Data folder includes the datasets used in the analysis (split up by city)
	- Species urban tolerance information is from Dirr's Encyclopedia of trees and shrubs
	- building, construction permit, and zoning information are from each city, translated into segment level information through ArcGIS Pro

* 02Scripts contains R code used to run analyses
	- note that there is a code to examine the construction and renovation permits because the classifications differ between Chicago and Durham.
	- The main analysis code (City_Neighborhood_Analysis) from each city can be run in isolation by using the intermediate datasets (ChicagoSegmentData.csv and DurhamSegmentData.csv) rather than running all the cleaning and organization code first)

* 03Outputs includes the model parameter estimates and AIC values for the best fitting models (from running the main analysis scripts)
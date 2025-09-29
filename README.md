# Urban Forest Structure and Gentrification
Code and Data accompanying manuscript: Gentrification and urban forest structure and health: lessons from two cities

## Contact
If you have any questions, please contact Ren Poulton Kamakura at renatakamakura@gmail.com or ren.poultonkamakura@ubc.ca

## File Organization

__01Data:__ folder includes the datasets used in the analysis (split up by city)
* Species urban tolerance information is from Dirr's Encyclopedia of trees and shrubs
* building, construction permit, and zoning information are from each city, translated into segment level information through ArcGIS Pro
* Summary tables of tree-level and neighborhood data with segment numbers that match the numbers in the manuscript are in the city sub-folders, in the folders labelled "SummariesMatchingManuscript". Segment numbers in intermediate tables otherwise match grid cell names.
* The PilotTesting folder includes data from initial pilot field work that sampled electrical conductivity and soil compaction

__02Scripts:__ contains R code used to run analyses
* note that there is a code to examine the construction and renovation permits because the classifications differ between Chicago and Durham.
* The main analysis code (City_Neighborhood_Analysis) from each city can be run in isolation by using the intermediate datasets (ChicagoSegmentData.csv and DurhamSegmentData.csv) rather than running all the cleaning and organization code first
* This folder also includes csv files that help translate the grid cell names (default street segment names) to the segment names used in the manuscript for ease of understanding

__03Outputs:__ includes the model parameter estimates and AIC values for the best fitting models (from running the main analysis scripts)
* each city has a folder with the neighborhood-level results, organized into one summary csv and otherwise into different csv's based on the response variable

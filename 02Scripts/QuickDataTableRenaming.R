#Pull in dictionaries
D_dict <- read.csv("./Durham_SegName_Dict.csv")
C_dict <- read.csv("./Chicago_SegName_Dict.csv")

#Pull in data frames
#main summary files that someone might want to look at
files_Dur <- c("../01Data/Durham/091523AllYearsCombDurham.csv", 
               "../01Data/Durham/DurhamSegmentData.csv")
files_Chi <- c("../01Data/Chicago/091223AllYearsComb.csv", 
               "../01Data/Chicago/ChicagoSegmentData.csv")
dfs_d <- lapply(files_Dur, read.csv)
dfs_c <- lapply(files_Chi, read.csv)

#create new df names
updateName <- function(oldName){
  nm <- strsplit(oldName, ".csv")
  newName <- paste(nm[1], "nwSegnms.csv", sep='_')
  return(newName)
}

dfs_d_out <- lapply(files_Dur, updateName)
dfs_c_out <- lapply(files_Chi, updateName)

#create new dfs
# Function to update each data frame
update_segment_column <- function(df, dict) {
  
  if ("Segment" %in% colnames(df)) {
    # Create new Seg column
    df$Seg <- dict$Segment[match(df$Segment, dict$Seg_old)]
    
    # Remove old Segment column
    df$Segment <- NULL
    
    # Reorder columns to move Seg to the front
    df <- df[, c("Seg", setdiff(names(df), "Seg"))]
  } else if ("Name" %in% colnames(df)){
    # Create new Seg column
    df$Seg <- dict$Segment[match(df$Name, dict$Seg_old)]
    
    # Remove old Segment column
    df$Name <- NULL
    
    # Reorder columns to move Seg to the front
    df <- df[, c("Seg", setdiff(names(df), "Seg"))]
  }
  
  
  return(df)
  
}


# Apply the function to each data frame in the list
dfs_d_nwSeg <- lapply(dfs_d, update_segment_column, dict = D_dict)
dfs_c_nwSeg <- lapply(dfs_c, update_segment_column, dict = C_dict)

#write out the new dfs
Map(function(df, filename) {
  invisible(write.csv(df, file = filename, row.names = FALSE))
}, dfs_d_nwSeg, dfs_d_out)

Map(function(df, filename) {
  invisible(write.csv(df, file = filename, row.names = FALSE))
}, dfs_c_nwSeg, dfs_c_out)



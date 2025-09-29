C_dict <- read.csv("./Durham_SegName_Dict.csv")
C_data <- read.csv("./DurhamSegmentData.csv")

usefulcols <- c("Segment", "SVI", "Change_PWnHL","Change_MedHHI", 
                "AllConst_since11", "Avg_Rmov")

newdf <- C_data[, usefulcols]
newdf$Seg <- C_dict$Segment[match(newdf$Segment, C_dict$Seg_old)]

write.csv(newdf[, c("Seg", "SVI", "Change_PWnHL","Change_MedHHI", 
                    "AllConst_since11", "Avg_Rmov")], "DurhamPredSummary.csv")

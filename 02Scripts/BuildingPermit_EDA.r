##Explore the building parcel data

library(stringr) #to look at regex 
library(stringi) #same, need lower case

DurhamPermits <- read.csv("../01Data/Durham/DurhamPermit_Segs.csv")

ChicagoPermits <- read.csv("../01Data/Chicago/ChicagoPermits_bySeg.csv")


##start to look at the permit types
DurPermTypes <- table(DurhamPermits$BLDB_ACT_1)
ChiPermTypes <- table(ChicagoPermits$permit_typ)

##look at the notes with the permit types you think may go together
#Durham: Addition, Alterations, Interior Alterations, Re-Hab, Repair, Residential - Decks, Shell Only
#Chicago: PERMIT - RENOVATION/ALTERATION, PERMIT - SCAFFOLDING (maybe skip scaffolding?)

#get notes about each of these
# DurAddNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Addition"]
# DurAltNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Alterations"]
# DurIntAltNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Interior Alterations"]
# DurReHabNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Re-Hab"]
# DurRepairNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Repair"]
# DurDeckNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Residential - Decks"]
# DurShellNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "Shell Only"]
# 
# #get notes about chicago
# ChiRenoAltNotes <- ChicagoPermits$work_descr[ChicagoPermits$permit_typ == "PERMIT - RENOVATION/ALTERATION"]
# ChiScaffoldNotes <- ChicagoPermits$work_descr[ChicagoPermits$permit_typ == "PERMIT - SCAFFOLDING"] #can safely exclude
# ChiElecNotes <- ChicagoPermits$work_descr[ChicagoPermits$permit_typ == "PERMIT - ELECTRIC WIRING"]
# #may want to exclude the monthly maintenance, not sure the rest are really needed either tbh
# ChiElevNotes <- ChicagoPermits$work_descr[ChicagoPermits$permit_typ == "PERMIT - ELEVATOR EQUIPMENT"] #only one

##look into what is there
terms <- c("deck", "bath", "sitting area", "canopy", "patio", "remodel", "garage", 
           "expansion", "loading dock", "reno", "addition", "bedroom", "porch", 
           "rehab", "room", "roof", "floor", "repair", "foundation", "demol",
           "shell", "solar", "install", "partition", "elevator", "replace", 
           "alteration", "upfit", "electric", "kitchen", "mount", "remov", 
           "basement", "wall", "fit-up", "stabiliz", "tree", "masonry", "office",
           "plumbing", "stair", "facade", "balcon", "toilet")

terms <- sort(terms)

#go through and get a sense of the vibe of these permit types

#create Durham dataframe
DpermTypes <- c("Addition", "Alteration", "InterAlterations", "Re-Hab", "Repair", "Decks", "Shell")
DpermColNms <- c("Addition", "Alterations", "Interior Alterations", "Re-Hab", "Repair", "Residential - Decks", "Shell Only") #to know the column
DurhamTermHist <- as.data.frame(matrix(0, ncol=length(DpermTypes), nrow=length(terms)))
names(DurhamTermHist) <- DpermTypes
rownames(DurhamTermHist) <- terms

#iterate through the data
for (dp in 1:length(DurhamPermits$OBJECTID_12)){
  
  dp_type <- DurhamPermits$BLDB_ACT_1[dp]
  col <- match(dp_type, DpermColNms)
  
  #not one of the permits we care about
  if(is.na(col)){
    next
  }
  
  for (t in 1:length(terms)){
    
    trm <- terms[t]
    pres <- str_detect(stri_trans_tolower(DurhamPermits$DESCRIPTIO[dp]), trm)
    
    #if the term is in the notes
    if (pres){
      
      DurhamTermHist[t, col] <- DurhamTermHist[t, col] + 1
      
    } #if term is present
    
  } #term loop
  
} #row loop

###Note: Durham also has a "Foundation Only" section as well as "Commercial - Roofing/Re-Roofing" and "Other"

#############Do the same for Chicago

#create chicago dataframe
CpermTypes <- c("RenovAlt", "Scaffold", "Electric", "Elevator")
CpermColNms <- c("PERMIT - RENOVATION/ALTERATION", "PERMIT - SCAFFOLDING", "PERMIT - ELECTRIC WIRING", "PERMIT - ELEVATOR EQUIPMENT") #to know the column
ChicagoTermHist <- as.data.frame(matrix(0, ncol=length(CpermTypes), nrow=length(terms)))
names(ChicagoTermHist) <- CpermTypes
rownames(ChicagoTermHist) <- terms

#iterate through the dataset
for (cp in 1:length(ChicagoPermits$OBJECTID)){
  
  cp_type <- ChicagoPermits$permit_typ[cp]
  col <- match(cp_type, CpermColNms)
  
  #not one of the permits we care about
  if(is.na(col)){
    next
  }
  
  for (t in 1:length(terms)){
    
    trm <- terms[t]
    pres <- str_detect(stri_trans_tolower(ChicagoPermits$work_descr[cp]), trm)
    
    #if the term is in the notes
    if (pres){
      
      ChicagoTermHist[t, col] <- ChicagoTermHist[t, col] + 1
      
    } #if term is present
    
  } #term loop
  
} #row loop


##########################################Look now at new construction

#Durham first
DurConstNotes <- DurhamPermits$DESCRIPTIO[DurhamPermits$BLDB_ACT_1 == "New"]
#most of these do seem like new buildings, though they mention "Tracking permit" so on, which might be something different?
#also EXREV? Not sure what that means?
#addendums too, and they have "Brooks practice field replacement, New Temporary Crows Nest 
#for Cameron Indoor,  and a new baseball scoreboard? These seem like additions

#Chicago
ChiConstNotes <- ChicagoPermits$work_descr[ChicagoPermits$permit_typ == "PERMIT - NEW CONSTRUCTION"]
#most seem good as well, though have smaller things like a two car garage

##check the number of permits
DurLines <- length(DurhamPermits$TARGET_FID)

ChiLines <- length(ChicagoPermits$FID) #591
ChiIDs <- unique(ChicagoPermits$id) #497
ChiPermitNum <- unique(ChicagoPermits$permit_) #493
DatesIss <- unique(ChicagoPermits$date_issue) #need to get rid of the lines without a date issued for the permits


##################################################################Go through and try to create analogous categories

#items that are to ignore for these permits
toIgnore <- c("temporary", "tracking")
renos <- c("scoreboard", "replace")

#get the column names
colNms <- c("Segment", "PermitIssueDate", "PermitType")

#create dataframes to write permits into
Permits_DurClean <- as.data.frame(matrix(NA, nrow=length(DurhamPermits$OBJECTID_12), ncol=length(colNms)))
Permits_ChiClean <- as.data.frame(matrix(NA, nrow=length(ChicagoPermits$OBJECTID), ncol=length(colNms)))

names(Permits_DurClean) <- colNms
names(Permits_ChiClean) <- colNms


#for storing data
sto_ind <- 1

#start with Durham
for (p in 1:length(DurhamPermits$OBJECTID)){
  
  pdata <- DurhamPermits[p,]
  
  #skip the stuff that is not relevant, want issued permits that are relevant to our 3 categories
  if (pdata$BLDB_ACT_1 == "Minimum Housing" | pdata$BLDB_ACT_1 == "Moving" | 
      pdata$BLDB_ACT_1 == "Other" | pdata$BLDB_ACT_1 == "Change of Occupancy"){
    
    print(paste("skipped row", p, "due to wrong permit type"))
    next
  
    #assign preliminary categories
  } else if (pdata$PmtStatus == "Disapproved" | pdata$PmtStatus == "Void" | 
             pdata$PmtStatus == "" | pdata$PmtStatus == "Recieved" | 
             pdata$PmtStatus == "CO Pending") {
    
    print(paste("skipped row", p, "due to incorrect status"))
    next
    
  } else if (pdata$BLDB_ACT_1 == "Demolition"){
    typ <- "Demo"
    
  } else if (pdata$BLDB_ACT_1 == "New"){
    typ <- "NewConst"
    
  } else {
    typ <- "Reno_Alt_add"
  }
  
  #check the notes for things to ignore
  skip = FALSE
  nts <- pdata$DESCRIPTIO
  
  for (i in toIgnore){
    pres = str_detect(tolower(nts), i)
    
    if (pres){
      skip = TRUE
      print(paste("skipped row", p, "due to presence of term", i))
      break
    }
  }
  
  #if the notes include a term to ignore
  if (skip){
    next
  }
  
  #check about things that would make me switch the category
  if (typ == "NewConst"){
    for (r in renos){
      shouldbeReno = str_detect(tolower(nts), r)
      
      if (shouldbeReno){
        typ <- "Reno_Alt_add"
      }
    } #renovations need to be recategorized
    
  } 
  
  ############Now add the info to the datafame
  Permits_DurClean$Segment[sto_ind] <- pdata$Name
  Permits_DurClean$PermitIssueDate[sto_ind] <- pdata$ISSUE_DATE
  Permits_DurClean$PermitType[sto_ind] <- typ
        
  #update row for storing info  
  sto_ind <- sto_ind + 1
} #going through each line

Permits_DurClean <- Permits_DurClean[!is.na(Permits_DurClean$Segment),]

write.csv(Permits_DurClean, "../01Data/Durham/Durham_BuildingPermits_wSeg_clean.csv")

#################Do the same thing for Chicago
#for storing data
sto_ind <- 1

#start with Durham
for (p in 1:length(ChicagoPermits$OBJECTID)){
  
  pdata <- ChicagoPermits[p,]
  
  #skip the stuff that is not relevant, want issued permits that are relevant to our 3 categories
  if (pdata$permit_typ == "PERMIT - SCAFFOLDING" | pdata$permit_typ == "PERMIT - SIGNS"){ 
    #pdata$permit_typ == "PERMIT - REINSTATE REVOKED PMT" | 
    
    print(paste("skipped row", p, "due to wrong permit type"))
    next
    
  } else if (pdata$permit_typ == "PERMIT - WRECKING/DEMOLITION"){
    typ <- "Demo"
    
  } else if (pdata$permit_typ == "PERMIT - NEW CONSTRUCTION"){
    typ <- "NewConst"
    
  } else {
    typ <- "Reno_Alt_add"
  }
  
  #check the notes for things to ignore
  skip = FALSE
  nts <- pdata$work_descr
  
  for (i in toIgnore){
    pres = str_detect(tolower(nts), i)
    
    if (pres){
      skip = TRUE
      print(paste("skipped row", p, "due to presence of term", i))
      break
    }
  }
  
  #if the notes include a term to ignore
  if (skip){
    next
  }
  
  #check about things that would make me switch the category
  if (typ == "NewConst"){
    for (r in renos){
      shouldbeReno = str_detect(tolower(nts), r)
      
      if (shouldbeReno){
        print(paste("Changed to renovation row", p, "due to presence of term", r))
        typ <- "Reno_Alt_add"
      }
    } #renovations need to be recategorized
    
  } 
  
  ############Now add the info to the datafame
  Permits_ChiClean$Segment[sto_ind] <- pdata$Name
  Permits_ChiClean$PermitIssueDate[sto_ind] <- pdata$date_issue
  Permits_ChiClean$PermitType[sto_ind] <- typ
  
  #update row for storing info  
  sto_ind <- sto_ind + 1
} #going through each line

Permits_ChiClean <- Permits_ChiClean[!is.na(Permits_ChiClean$Segment),]
write.csv(Permits_ChiClean, "../01Data/Chicago/Chicago_BuildingPermits_wSeg_clean.csv")

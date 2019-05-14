#This is a Frankensteins monster of a script. If you want sensible comments and
#slightly fewer redundant parts check out the code for linear relationships.
#It was built from this but.

#As of writing this, the current code only looks at 'Versus' files though it 
#though it imports all the csv files.

#For this to work you must have run the correct matlab script, on the correct
#DR files and put them in the correct place. This script cannot be run 
#straight after the DR script as the files are not sorted correctly.


#########################################################
### A) Installing and loading required packages
#########################################################
if (!require("BiocManager")) {
  install.packages("BiocManager", dependencies = TRUE)
  library(BiocManager)
}
if (!require("tidyverse")) {
  install.packages("tidyverse", dependencies = TRUE)
  library(tidyverse)
}
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
if (!require("tidyverse")) {
  install.packages("tidyverse", dependencies = TRUE)
  library(tidyverse)
}
if (!require("dplyr")) {
  install.packages("dplyr", dependencies = TRUE)
  library(dplyr)
}
if (!require("rlist")) {
  install.packages("rlist", dependencies = TRUE)
  library(rlist)
}
if (!require("ComplexHeatmap")) {
  install.packages("ComplexHeatmap", dependencies = TRUE)
  library(ComplexHeatmap)
}
if (!require("data.table")) {
  install.packages("data.table", dependencies = TRUE)
  library(data.table)
}
if (!require("styler")) {
  install.packages("styler", dependencies = TRUE)
  library(styler)
}
if (!require("circlize")) {
  install.packages("circlize", dependencies = TRUE)
  library(circlize)
}
#if (!require("colorRamp2")) {
#  install.packages("colorRamp2", dependencies = TRUE)
#  library(colorRamp2)
#}

library(devtools)
install_github("jokergoo/ComplexHeatmap", force = TRUE)
library(ComplexHeatmap)

#########################################################
### B) Setup, lists and some arrays
#########################################################

#Define some important things

ConditionsAbbr <- c("PL", "IV", "IN", "NB")

DataSets <- c(
  "DataForThisCondition", "DataFramePStatFDR", "DataFramePStatNonC",
  "DataFrameTStat", "MatrixPStatFDR", "MatrixPStatNonC", "MatrixTStat"
)

RowColNames <- c("C1", "C2", "C3", "C4", "C5", "C6")


# Build list to keep organised

AllData <- lapply(DataSets, function(q) {
  
})
names(AllData) <- DataSets

#AllData <- lapply(ConditionsAbbr, function(q) {
#  EmptySublist <- (setNames(vector("list", length(DataSets)), DataSets))
#})

#names(AllData) <- ConditionsAbbr



#########################################################
### C) Create Data Frames and Matrices for Plotting
#########################################################

########
########## -----> Acquire the data and start a for-loop
########

# Start a for loop

SourceDir <- file.path(paste0(
  "/Users/joshuamarden/University_Work/4th_Year_Neuroscience",
  "/Research_Project/Data/BRCOPT_preprocessed_Working",
  "/Connectivity_Analysis_Similarities_in_Connectivity_Patterns_Between_Conditions/"
))


TempFileList <- list.files(file.path
                           (SourceDir, "/Base_Files_FDR_0.05"),
                           pattern = "*.csv", full.names = FALSE
)


AllData[["DataForThisCondition"]] <- lapply(TempFileList, function(x) {
  read.delim(file.path(
    SourceDir, "/Base_Files_FDR_0.05",
    x
  ), header = FALSE, sep = ",", row.names = RowColNames, col.names = RowColNames)
})

names(AllData[["DataForThisCondition"]]) <- TempFileList



#####
####### -----------> P Values 
####

# Collect the 'versus' Data to put it in a data frame - FDR Corrected P Values

# Note how the FDR means it's only looking at FDR Corrected P-Values at this time

# Helper function to extract the relevant portion of MyList and rbind() it
makeColumns <- function(n) {
  re <- paste0("^", n, "Versus")
  sublist <- AllData[["DataForThisCondition"]][grep(paste0(re, "(.*FDR)"), names(AllData[["DataForThisCondition"]]))]
  names(sublist) <- sub(re, "", sub("\\Inter.*", "", names(sublist)))
  
  # Make sure sublist is sorted correctly and contains info on all
  sublist <- sublist[ConditionsAbbr]
  
  # Change row and col names so that they are unique in the final result
  sublist <- lapply(names(sublist), function(m) {
    res <- sublist[[m]]
    rownames(res) <- paste0(m, "_", rownames(res))
    colnames(res) <- paste0(n, "_", colnames(res))
    res
  })
  do.call(rbind, sublist)
}

lColumns <- lapply(setNames(nm = ConditionsAbbr), makeColumns)
AllData[["DataFramePStatFDR"]] <- do.call(cbind, lColumns)


# This still has all the names messed up and I can't
# Seem to fix it so here'a cheap way of doing it.

colnames(AllData[["DataFramePStatFDR"]]) <- rep(paste0(RowColNames), times = 4)
rownames(AllData[["DataFramePStatFDR"]]) <- make.names(rep(paste0(RowColNames), times = 4), unique = TRUE)

# Create Matrix for Plotting

AllData[["MatrixPStatFDR"]] <- data.matrix(AllData[["DataFramePStatFDR"]])




#####
####### -----------> P Values Uncorrected
#####


# Collect the 'versus' Data to put it in a data frame - Uncorrected Corrected P Values

# Helper function to extract the relevant portion of MyList and rbind() it
makeColumns <- function(n) {
  re <- paste0("^", n, "Versus")
  sublist <- AllData[["DataForThisCondition"]][grep(paste0(re, "(.*NonC)"), names(AllData[["DataForThisCondition"]]))]
  names(sublist) <- sub(re, "", sub("\\Inter.*", "", names(sublist)))
  
  # Make sure sublist is sorted correctly and contains info on all musketeers
  sublist <- sublist[ConditionsAbbr]
  
  # Change row and col names so that they are unique in the final result
  sublist <- lapply(names(sublist), function(m) {
    res <- sublist[[m]]
    rownames(res) <- paste0(m, "_", rownames(res))
    colnames(res) <- paste0(n, "_", colnames(res))
    res
  })
  do.call(rbind, sublist)
}

lColumns <- lapply(setNames(nm = ConditionsAbbr), makeColumns)
AllData[["DataFramePStatNonC"]] <- do.call(cbind, lColumns)


# This still has all the names messed up and I can't
# Seem to fix it so here'a cheap way of doing it.

colnames(AllData[["DataFramePStatNonC"]]) <- rep(paste0(RowColNames), times = 4)
rownames(AllData[["DataFramePStatNonC"]]) <- make.names(rep(paste0(RowColNames), times = 4), unique = TRUE)



# Create Matrix for Plotting

AllData[["MatrixPStatNonC"]] <- data.matrix(AllData[["DataFramePStatNonC"]])



#####
####### -----------> T Values
#####


# Collect the 'versus' Data to put it in a data frame - T-Values

# Helper function to extract the relevant portion of MyList and rbind() it


makeColumns <- function(n) {
  re <- paste0("^", n, "Versus")
  sublist <- AllData[["DataForThisCondition"]][grep(paste0(re, "(.*TStat)"), names(AllData[["DataForThisCondition"]]))]
  names(sublist) <- sub(re, "", sub("\\Inter.*", "", names(sublist)))
  
  # Make sure sublist is sorted correctly and contains info on all musketeers
  sublist <- sublist[ConditionsAbbr]
  
  # Change row and col names so that they are unique in the final result
  sublist <- lapply(names(sublist), function(m) {
    res <- sublist[[m]]
    rownames(res) <- paste0(m, "_", rownames(res))
    colnames(res) <- paste0(n, "_", colnames(res))
    res
  })
  do.call(rbind, sublist)
}

lColumns <- lapply(setNames(nm = ConditionsAbbr), makeColumns)
AllData[["DataFrameTStat"]] <- do.call(cbind, lColumns)


# This still has all the names messed up and I can't
# Seem to fix it so here'a cheap way of doing it.

colnames(AllData[["DataFrameTStat"]]) <- rep(paste0(RowColNames), times = 4)
rownames(AllData[["DataFrameTStat"]]) <- make.names(rep(paste0(RowColNames), times = 4), unique = TRUE)

# Create Matrix for Plotting

AllData[["MatrixTStat"]] <- data.matrix(AllData[["DataFrameTStat"]])



#########################################################
### D) More Flipping Lists
#########################################################

# I made a mistake and combining all of the DFs does not appear
# to be the best way of creating the matrix, because dividing the large matrix always causes
# and we should preserve row order....

# Not a good use of for-loop as it doesn't pre-allocate memory which we
# can do and should have done here but it always takes me
# hours to get my lapply loops working


# Create a vector of versus which we will be using to fill lists of matrices
VersusList <- c()

for (q in 1:length(ConditionsAbbr)) {
  for (j in 1:length(ConditionsAbbr)) {
    
    # VersusList(i) <- paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j])
    VersusList <- c(VersusList, paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j]))
  }
}

#StatMatrices <- list("PStatNonCMatrices", "PStatFDRMatrices", "TStatMatrices")

# Create a list of conditions and the matrices
#StatMatrices <- lapply(ConditionsAbbr, function(q) {
#    # Select Versus List so that for example, a PL list only contains PLVersusPL<
#    # PLVerusIV, PLVersusIN and PLVersusNB, and not NBVersus.. and so on...
#    WhichVersus <- grep(paste0("(^", q, ")"), VersusList, value = T, perl = T)
#    EmptySublist <- (setNames(vector("list", length(ConditionsAbbr)), WhichVersus))
#  })
#names(StatMatrices) <- ConditionsAbbr



PStatNonCMatrices <- lapply(ConditionsAbbr, function(q) {
  # Select Versus List so that for example, a PL list only contains PLVersusPL<
  # PLVerusIV, PLVersusIN and PLVersusNB, and not NBVersus.. and so on...
  WhichVersus <- grep(paste0("(^", q, ")"), VersusList, value = T, perl = T)
  EmptySublist <- (setNames(vector("list", length(ConditionsAbbr)), WhichVersus))
})
names(PStatNonCMatrices) <- ConditionsAbbr



PStatFDRMatrices <- lapply(ConditionsAbbr, function(q) {
  # Select Versus List so that for example, a PL list only contains PLVersusPL<
  # PLVerusIV, PLVersusIN and PLVersusNB, and not NBVersus.. and so on...
  WhichVersus <- grep(paste0("(^", q, ")"), VersusList, value = T, perl = T)
  EmptySublist <- (setNames(vector("list", length(ConditionsAbbr)), WhichVersus))
})
names(PStatFDRMatrices) <- ConditionsAbbr



TStatMatrices <- lapply(ConditionsAbbr, function(q) {
  # Select Versus List so that for example, a PL list only contains PLVersusPL<
  # PLVerusIV, PLVersusIN and PLVersusNB, and not NBVersus.. and so on...
  WhichVersus <- grep(paste0("(^", q, ")"), VersusList, value = T, perl = T)
  EmptySublist <- (setNames(vector("list", length(ConditionsAbbr)), WhichVersus))
})
names(TStatMatrices) <- ConditionsAbbr


# Now using a for-loop, this time not so aggregiously (I think), fill those damn lists:

# Non Corrected

for (q in 1:length(ConditionsAbbr)) {
  for (j in 1:length(ConditionsAbbr)) {
    TempHold <- grep(paste0(
      "(^", ConditionsAbbr[q],
      ")(?=.*Versus", ConditionsAbbr[j], ")(?=.*NonC)"
    ), names(AllData[["DataForThisCondition"]]),
    value = T, perl = T
    )
    
    TempDestName <- paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j])
    
    PStatNonCMatrices[[ConditionsAbbr[q]]][[TempDestName]] <- data.matrix(AllData[["DataForThisCondition"]][[TempHold]])
  }
}

# FDR Corrected

for (q in 1:length(ConditionsAbbr)) {
  for (j in 1:length(ConditionsAbbr)) {
    TempHold <- grep(paste0(
      "(^", ConditionsAbbr[q],
      ")(?=.*Versus", ConditionsAbbr[j], ")(?=.*FDR)"
    ), names(AllData[["DataForThisCondition"]]),
    value = T, perl = T
    )
    
    TempDestName <- paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j])
    
    PStatFDRMatrices[[ConditionsAbbr[q]]][[TempDestName]] <- data.matrix(AllData[["DataForThisCondition"]][[TempHold]])
  }
}


# T Stat

for (q in 1:length(ConditionsAbbr)) {
  for (j in 1:length(ConditionsAbbr)) {
    TempHold <- grep(paste0(
      "(^", ConditionsAbbr[q],
      ")(?=.*Versus", ConditionsAbbr[j], ")(?=.*TStat)"
    ), names(AllData[["DataForThisCondition"]]),
    value = T, perl = T
    )
    
    TempDestName <- paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j])
    
    TStatMatrices[[ConditionsAbbr[q]]][[TempDestName]] <- data.matrix(AllData[["DataForThisCondition"]][[TempHold]])
  }
}

#########################################################
### E) More Flipping Lists Pt2
#########################################################

#It appears that you can't comnine columns and rows with + and %v$.
# "Error: The heatmap list should only be all horizontal or vertical."
#Instead we're going to combine the matrices along rows, turn these into 
#heatmaps which we will separate with columns, and see if we can join 
#those together. This means more lists...


PStatNonCMatricesAsRows <- lapply(ConditionsAbbr, function(q) {
  PStatNonCMatricesAsRows <-  Reduce(cbind, unlist(PStatNonCMatrices[q], recursive = FALSE)) 
})
names(PStatNonCMatricesAsRows) <- paste0(ConditionsAbbr, "Row")


PStatFDRMatricesAsRows <- lapply(ConditionsAbbr, function(q) {
  PStatFDRMatricesAsRows <-  Reduce(cbind, unlist(PStatFDRMatrices[q], recursive = FALSE)) 
})
names(PStatFDRMatricesAsRows) <- paste0(ConditionsAbbr, "Row")


TStatMatricesAsRows <- lapply(ConditionsAbbr, function(q) {
  TStatMatricesAsRows <-  Reduce(cbind, unlist(TStatMatrices[q], recursive = FALSE)) 
})
names(TStatMatricesAsRows) <- paste0(ConditionsAbbr, "Row")


#########################################################
### D) PLotting
#########################################################


#Setup

#Really I should just setup the p and t-stat heatmpas as cone comand so 
#I don't have to change them echah time!!


#Colour Scheme for P Stats
my_palette_PStat = colorRamp2(log(c(0.06, 0.05, 0.001, 0.000001)),
                              c('snow', '#ffed9f' , '#e1783c', '#df0037'))

LegendLabels = expression("0.05", "0.03", "0.01", "0.005", "0.001", "1 × 10"^"-4", "1 × 10"^"-5")


#Colour Scheme for T stats - with reduced overlap so T and P stat heatmaps
#Are difficult to confuse
my_palette_TStat = colorRamp2(c(-3, -1.5, 0, 1.5, 3),
                              c("#3a5fcd", "#76eec6", "#FAF9E8", "#ff636c", "#D20101"))

my_palette_TStat(seq(-3.1, 3.1))


ConditionAnoCol = c("#deebf7", "#1c9099", "#addd8e", "#fee391")



Heatmap( log(AllData[["MatrixPStatFDR"]]), name = "Interconditional Interconnectivity Heatmap, Adjusted P-Values",
         column_title = "Interconditional Interconnectivity Heatmap, Adjusted P-Values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         row_labels = rep(RowColNames, times = 4),
         use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 8,
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 310,
         col = my_palette_PStat,
         row_split = rep(1:4, each = 6),
         column_split = rep(1:4, each = 6),
         row_title = NULL,
         #column_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = "Legend",
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         top_annotation = HeatmapAnnotation(
           t1 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           height = unit(0.6, "cm")
         ),
         
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10)
           ),
           width = unit(0.6, "cm")
         ),
         
         row_names_gp = gpar(fontsize = 7),
         column_names_gp = gpar(fontsize = 7),
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

Heatmap( log(AllData[["MatrixPStatNonC"]]), name = "Interconditional Interconnectivity Heatmap, Unadjusted P-Values",
         column_title = "Interconditional Interconnectivity Heatmap, Unadjusted P-Values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "tiff",
         #raster_quality = 3,
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 310,
         row_labels = rep(RowColNames, times = 4),
         col = my_palette_PStat,
         row_split = rep(1:4, each = 6),
         column_split = rep(1:4, each = 6),
         row_title = NULL,
         #column_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = "Legend",
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         top_annotation = HeatmapAnnotation(
           t1 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           height = unit(0.6, "cm")
         ),
         
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10)
           ),
           width = unit(0.6, "cm")
         ),
         
         row_names_gp = gpar(fontsize = 7),
         column_names_gp = gpar(fontsize = 7),
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

Heatmap( AllData[["MatrixTStat"]], name = "Interconditional Interconnectivity Heatmap, t-Statistic",
         column_title = "Interconditional Interconnectivity Heatmap, t-Statistics",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 310,
         row_labels = rep(RowColNames, times = 4),
         col = my_palette_TStat,
         row_split = rep(1:4, each = 6),
         column_split = rep(1:4, each = 6),
         row_title = NULL,
         #column_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_TStat,
           at = (c(-3, -1.5, 0, 1.5, 3)), 
           legend_height = unit(6, "cm")),
         
         top_annotation = HeatmapAnnotation(
           t1 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           height = unit(0.6, "cm")
         ),
         
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10)
           ),
           width = unit(0.6, "cm")
         ),
         
         row_names_gp = gpar(fontsize = 7),
         column_names_gp = gpar(fontsize = 7),
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

##################Rough Working



#PStatNonCMtx <- lapply(ConditionsAbbr, function(q) {
#  PStatNonCMtx <-  Reduce(rbind, unlist(PStatNonCMatricesAsRows[q], recursive = FALSE)) 
#})

#Heatmap( AllData[["PL"]][["MatrixPStatNonC"]], name ="PL TStat",
#         cluster_rows = FALSE,
#         cluster_columns = FALSE,
#         cluster_row_slices = TRUE,
#         cluster_column_slices = TRUE,
#         column_names_rot = 0,
#         col = my_palette,
#         row_split = rep(c("PL", "IV", "IN", "NB"), 6),
#         column_split = rep(c("PL", "IV", "IN", "NB"), 6)
#         )



#LayoutList <- paste0(names(TempHMs[1])," + ", names(TempHMs[2])," + ",names(TempHMs[3])," + ",names(TempHMs[4]), " %v% ", 
#                     names(TempHMs[5])," + ",names(TempHMs[6])," + ",names(TempHMs[7])," + ",names(TempHMs[8]), "  %v% ", 
#                     names(TempHMs[9])," + ",names(TempHMs[10])," + ",names(TempHMs[11])," + ",names(TempHMs[12]), " %v% ",
#                     names(TempHMs[13]), " + ", names(TempHMs[14]), " + ", names(TempHMs[15]), " + ", names(TempHMs[16])
#                     
#)

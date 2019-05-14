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

ComponentsAbbr <- c("C1", "C2", "C3", "C4", "C5", "C6")

DataSets <- c(
  "DataUnsorted", "DataFramePStatNonC", "DataFramePStatFDR",
  "DataFrameTStat",  "MatrixPStatNonC", "MatrixPStatFDR", "MatrixTStat"
)

# Build list to keep organised

AllData <- lapply(DataSets, function(q) {
  
})
names(AllData) <- DataSets


#########################################################
### C) Create Data Frames and Matrices for Plotting
#########################################################


SourceDir <- file.path(paste0(
  "/Users/joshuamarden/University_Work/4th_Year_Neuroscience",
  "/Research_Project/Data/BRCOPT_preprocessed_Working",
  "/Connectivity_Analysis_Connectivity_of_Components_Across_Conditions/"
))


TempFileList <- list.files(file.path
                           (SourceDir, "/Base_Files_FDR_0.05"),
                           pattern = "*.csv", full.names = FALSE
)


AllData[["DataUnsorted"]] <- lapply(TempFileList, function(x) {
  read.delim(file.path(
    SourceDir, "/Base_Files_FDR_0.05",
    x
  ), header = FALSE, sep = ",")
})

names(AllData[["DataUnsorted"]]) <- TempFileList


#Create a function that roerder the conditions withing the
#table so they are correct
CorrOrder <- function (df) {
  #Incorrect and original order is as follows:
  #1:6 IN, 7:12 IV, 13:18 NB, 19:24 PL
  new_order = c(19:24, 7:12, 1:6, 13:18)
  
  new_df <- df[new_order, new_order]
  
  return(df)
}

AllData[["DataFramePStatNonC"]] <- CorrOrder(AllData[["DataUnsorted"]][["AllInterNetworkPStatsNonC.csv"]])
rownames(AllData[["DataFramePStatNonC"]]) <- make.names(rep(paste0(ComponentsAbbr), times = 4), unique = TRUE)
colnames(AllData[["DataFramePStatNonC"]]) <- rep(paste0(ComponentsAbbr), times = 4)


AllData[["DataFramePStatFDR"]] <- CorrOrder(AllData[["DataUnsorted"]][["AllInterNetworkPStatsFDR.csv"]])
rownames(AllData[["DataFramePStatFDR"]]) <- make.names(rep(paste0(ComponentsAbbr), times = 4), unique = TRUE)
colnames(AllData[["DataFramePStatFDR"]]) <- rep(paste0(ComponentsAbbr), times = 4)

AllData[["DataFrameTStat"]] <- CorrOrder(AllData[["DataUnsorted"]][["AllInterNetworkTStats.csv"]])
rownames(AllData[["DataFrameTStat"]]) <- make.names(rep(paste0(ComponentsAbbr), times = 4), unique = TRUE)
colnames(AllData[["DataFrameTStat"]]) <- rep(paste0(ComponentsAbbr), times = 4)



AllData[["MatrixPStatNonC"]] <- as.matrix(AllData[["DataFramePStatNonC"]])

AllData[["MatrixPStatFDR"]] <- as.matrix(AllData[["DataFramePStatFDR"]])

AllData[["MatrixTStat"]] <- as.matrix(AllData[["DataFrameTStat"]])


#########################################################
### D) PLotting
#########################################################


#Setup

#Really I should just setup the p and t-stat heatmpas as cone comand so 
#I don't have to change them echah time!!

ConditionAnoCol = c("#deebf7", "#1c9099", "#addd8e", "#fee391")


#Colour Scheme for P Stats
my_palette_PStat = colorRamp2(log(c(0.06, 0.05, 0.001, 0.000001)),
                              c('snow', '#ffed9f' , '#e1783c', '#df0037'))

LegendLabels = expression("0.05", "0.03", "0.01", "0.005", "0.001", "1 × 10"^"-4", "1 × 10"^"-5")



#Colour Scheme for T stats - with reduced overlap so T and P stat heatmaps
#Are difficult to confuse
my_palette_TStat = colorRamp2(c(-3, -1.5, 0, 1.5, 3),
                              c("#3a5fcd", "#76eec6", "#FAF9E8", "#ff636c", "#D20101"))

my_palette_TStat(seq(-3.1, 3.1))



Heatmap( log(AllData[["MatrixPStatFDR"]]), name = "Relationship of Component Activity over Time Heatmap, Adjusted p-Values",
         column_title = "Relationship of Component Activity over Time Heatmap, Adjusted p-Values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         row_labels = rep(ComponentsAbbr, times = 4),
         column_labels = rep(ComponentsAbbr, times = 4),
         row_names_side = "right",
         #use_raster = TRUE,
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
           title = NULL,
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

Heatmap( log(AllData[["MatrixPStatNonC"]]), name = "Relationship of Component Activity over Time Heatmap, Unadjusted p-Values",
         column_title = "Relationship of Component Activity over Time Heatmap, Unadjusted p-Values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         row_labels = rep(ComponentsAbbr, times = 4),
         column_labels = rep(ComponentsAbbr, times = 4),
         #use_raster = TRUE,
         #raster_device = "tiff",
         #raster_quality = 3,
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
           title = NULL,
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

Heatmap( AllData[["MatrixTStat"]], name = "Relationship of Component Activity over Time Heatmap, t-statistic",
         column_title = "Relationship of Component Activity over Time Heatmap, t-statistic",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         row_labels = rep(ComponentsAbbr, times = 4),
         column_labels = rep(ComponentsAbbr, times = 4),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 310,
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





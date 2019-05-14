#A script for creating heatmaps for the linear compariosns of time courses for
#components.You'll need to make the correct folder and then run the correct 
#matlab script for this to have anything to use.

#To be honest this script has become rather inefficient as I should reallly 
#use loops/lapply to dynamically create my 'data sets vector' and then
#sort data into the many lists created using that vector, without having 
#it typed out each time. But for now it's faster to duplicate and edit large
#sections in sublime and then dump them back in here.
#'d love to make this code perfect but I don't have time.


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

#Currently need to force it to get the most up to date version from
#GitHub, should channge start of May according to jokergoo I think

library(devtools)
install_github("jokergoo/ComplexHeatmap", force = TRUE)
library(ComplexHeatmap)

#########################################################
### B) Get the data
#########################################################

#Define some useful things
ConditionsAbbr <- c("PL", "IV", "IN", "NB")
RowColNames <- c("C1", "C2", "C3", "C4", "C5", "C6")
SourceDir <- file.path(paste0(
  "/Users/joshuamarden/University_Work/4th_Year_Neuroscience",
  "/Research_Project/Data/BRCOPT_preprocessed_Working",
  "/DR_Relationships/"
  ))

#Create a vector of names that I'll be using to create lists
DataSets <- c(
  "DataUnsorted", "LinearDataFramePStatBFC", "LinearDataFramePStatNonC",
  "LinearDataFrameTStat", "LinearMatrixPStatBFC", "LinearMatrixPStatNonC",
  "LinearMatrixTStat", "QuadDataFramePStatBFC", "QuadDataFramePStatNonC",
  "QuadDataFrameTStat", "QuadMatrixPStatBFC", "QuadMatrixPStatNonC", 
  "QuadMatrixTStat")

#This cretaes a verus list so it's easier in the next step to call
#files and arrange them within my dataframe in the
#way I want (PL, IV, IN then NB)
VersusList <- c()

for (q in 1:length(ConditionsAbbr)) {
  for (j in 1:length(ConditionsAbbr)) {
    
    # VersusList(i) <- paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j])
    VersusList <- c(VersusList, paste0(ConditionsAbbr[q], "Versus", ConditionsAbbr[j]))
  }
}
  
#Make a list that your data will be put into
AllData <- lapply(DataSets, function(q) {
  #EmptySublist <- (setNames(vector("list", length(VersusList)), VersusList))
  
})
#Name the parts of that list
names(AllData) <- DataSets

#create a list of the names of the .csv files we'll use
TempFileList <- list.files(file.path
                           (SourceDir, "/Base_Files"),
                           pattern = "*.csv", full.names = FALSE
                           
)


#Put all the files into the imaginitvely named 'AllData'
AllData[["DataUnsorted"]] <- lapply(TempFileList, function(x) {
  read.delim(file.path(
    SourceDir, "/Base_Files",
    x
  ), header = FALSE, sep = ",")
})


#Give the files back their names so you know what on earth
#each data frame contains
names(AllData[["DataUnsorted"]]) <- TempFileList

#########################################################
### C) Sorting the Data 
#########################################################


#This is a surprisingly important bit. It puts all the conditions in order as
#it turns out they still get shuffled even with my creation of the versus list.
#but this ensures a PL to NB order, so that from this stage forward, I should be
#able to preict where items appear in lists and how my data should be plotted.
#Porbably not a great solution but it works.
AllData[["DataUnsorted"]] <- AllData[["DataUnsorted"]][order(-rowSums(sapply(seq_along(VersusList), function(i)
  i * grepl(VersusList[i], names(AllData[["DataUnsorted"]])))), names(AllData[["DataUnsorted"]]), decreasing = TRUE)]


#This makes all the Dataframes - Linear
AllData[["LinearDataFramePStatNonC"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Linear.*NonC)"), names(AllData[["DataUnsorted"]]))]
AllData[["LinearDataFramePStatNonC"]] <- list.rbind(AllData[["LinearDataFramePStatNonC"]])
colnames(AllData[["LinearDataFramePStatNonC"]]) <- RowColNames

AllData[["LinearDataFramePStatBFC"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Linear.*BFC)"), names(AllData[["DataUnsorted"]]))]
AllData[["LinearDataFramePStatBFC"]] <- list.rbind(AllData[["LinearDataFramePStatBFC"]])
colnames(AllData[["LinearDataFramePStatBFC"]]) <- RowColNames

AllData[["LinearDataFrameTStat"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Linear.*TStat)"), names(AllData[["DataUnsorted"]]))]
AllData[["LinearDataFrameTStat"]] <- list.rbind(AllData[["LinearDataFrameTStat"]])
colnames(AllData[["LinearDataFrameTStat"]]) <- RowColNames


#This makes all the Dataframes - Quad
AllData[["QuadDataFramePStatNonC"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Quad.*NonC)"), names(AllData[["DataUnsorted"]]))]
AllData[["QuadDataFramePStatNonC"]] <- list.rbind(AllData[["QuadDataFramePStatNonC"]])
colnames(AllData[["QuadDataFramePStatNonC"]]) <- RowColNames

AllData[["QuadDataFramePStatBFC"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Quad.*BFC)"), names(AllData[["DataUnsorted"]]))]
AllData[["QuadDataFramePStatBFC"]] <- list.rbind(AllData[["QuadDataFramePStatBFC"]])
colnames(AllData[["QuadDataFramePStatBFC"]]) <- RowColNames

AllData[["QuadDataFrameTStat"]] <- AllData[["DataUnsorted"]][grep(paste0("(^", VersusList, collapse="|", ".*Quad.*TStat)"), names(AllData[["DataUnsorted"]]))]
AllData[["QuadDataFrameTStat"]] <- list.rbind(AllData[["QuadDataFrameTStat"]])
colnames(AllData[["QuadDataFrameTStat"]]) <- RowColNames


#This makes all the Matrices - Linear
AllData[["LinearMatrixPStatNonC"]] <- data.matrix(AllData[["LinearDataFramePStatNonC"]])

AllData[["LinearMatrixPStatBFC"]] <- data.matrix(AllData[["LinearDataFramePStatBFC"]])

AllData[["LinearMatrixTStat"]] <- as.matrix(AllData[["LinearDataFrameTStat"]])

#This makes all the Matrices - Quad
AllData[["QuadMatrixPStatNonC"]] <- data.matrix(AllData[["QuadDataFramePStatNonC"]])

AllData[["QuadMatrixPStatBFC"]] <- data.matrix(AllData[["QuadDataFramePStatBFC"]])

AllData[["QuadMatrixTStat"]] <- as.matrix(AllData[["QuadDataFrameTStat"]])



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

#Self Explkanatory
RowNames = c("vs PL", "vs IV", "vs IN", "vs NB", 
             "vs PL", "vs IV", "vs IN", "vs NB", 
             "vs PL", "vs IV", "vs IN", "vs NB",
             "vs PL", "vs IV", "vs IN", "vs NB")

#This is the backgreound colour used for the row labels
RowLabCol = c("#deebf7", "#1c9099", "#addd8e", "#fee391",
              "#deebf7", "#1c9099", "#addd8e", "#fee391",
              "#deebf7", "#1c9099", "#addd8e", "#fee391",
              "#deebf7", "#1c9099", "#addd8e", "#fee391")


########
#   Linear
########

# P Stat Non-C

Heatmap( log(AllData[["LinearMatrixPStatNonC"]]), name = "Linear Dual Regresion Heatmap, Unadjusted p-values",
         column_title = "Linear Dual Regresion Heatmap, Unadjusted p-values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_PStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

# P Stat BFC

Heatmap( log(AllData[["LinearMatrixPStatBFC"]]), name = "Linear Dual Regresion Heatmap, Adjusted p-values",
         column_title = "Linear Dual Regresion Heatmap, Adjusted p-values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_PStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

# T Stat

Heatmap( AllData[["LinearMatrixTStat"]], name = "Linear Dual Regresion Heatmap, t-Statistic",
         column_title = "Linear Dual Regresion Heatmap, t-Statistic",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_TStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_TStat,
           at = (c(-3, -1.5, 0, 1.5, 3)), 
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)
         
         
########
#   Quad
########

# P Stat Non-C

Heatmap( log(AllData[["QuadMatrixPStatNonC"]]), name = "Quadratic Dual Regresion Heatmap, Unadjusted p-Values",
         column_title = "Quadratic Dual Regresion Heatmap, Unadjusted p-Values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_PStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)

# P Stat BFC

Heatmap( log(AllData[["QuadMatrixPStatBFC"]]), name = "Quadratic Dual Regresion Heatmap, Adjusted p-values",
         column_title = "Quadratic Dual Regresion Heatmap, Adjusted p-values",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_PStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_PStat,
           at = log(c(0.05,0.03,0.01,0.001,0.0001,0.00001,0.000001)),
           labels = LegendLabels,
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)
# T Stat 


Heatmap( AllData[["QuadMatrixTStat"]], name = "Quadratic Dual Regresion Heatmap, t-Statistic",
         column_title = "Quadratic Dual Regresion Heatmap, t-Statistic",
         column_title_gp = gpar(fontsize = 10, fontface = "bold"),
         width = unit(8, "cm"), 
         height = unit(8, "cm"),
         #use_raster = TRUE,
         #raster_device = "png",
         #raster_quality = 3,
         show_row_names = TRUE,
         row_labels = RowNames,
         #row_names_side = "left",
         cluster_rows = FALSE,
         cluster_columns = FALSE,
         column_names_rot = 0,
         col = my_palette_TStat,
         row_split = rep(1:4, each = 4),
         row_title = NULL,
         cluster_row_slices = FALSE,
         cluster_column_slices =FALSE,
         heatmap_legend_param = list(
           title = NULL,
           col = my_palette_TStat,
           at = (c(-3, -1.5, 0, 1.5, 3)), 
           legend_height = unit(6, "cm")),
         left_annotation = rowAnnotation(
           t2 = anno_block(gp = gpar(fill = ConditionAnoCol, col = "white"), 
                           labels = c("PL", "IV", "IN", "NB"),
                           labels_rot = 0,
                           labels_gp = gpar(col = "black", fontsize = 10),
           ),
           width = unit(0.6, "cm")
         ),
         row_names_gp = gpar(fontsize = 7, fill = RowLabCol, col = "black"),
         column_names_gp = gpar(fontsize = 7),
         row_names_side = "left",
         row_names_centered = TRUE, 
         column_names_centered = TRUE
)  
         
         
         
         
         
         
         
      
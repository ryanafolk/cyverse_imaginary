# createImageLinks from CyVerse Imaginary service
# author Herrick H.K. Brown
# 2022-11-09
# code modified on 2023-05-06 (CC) to fix spelling error of directory from "SCotty" to "Scotty"

# vars to modify

# enter root directory for image folder
rootdir <- "/Users/ryanfolk/Desktop/cyverse_imaginary/temp/" # only absolute paths here
# enter upload date, needs to match dated folder name
date <- "2024-7-8"
# build working dir
wkdir <- paste(rootdir,date,sep="")
# check that the path exists
dir.create(file.path(paste(rootdir, date, "/", sep="")))
# output location
fiOUT <- "/Users/ryanfolk/Desktop/cyverse_imaginary/temp/"

# RAF: MAKE SURE LOCAL FILES ALSO IN DATED FOLDER
# make sure there are not any CSVs already in the folder

# stuff that actually does stuff

# build file list including directory
FL <- sub("/Users/ryanfolk/Desktop/cyverse_imaginary/temp/", "MISSA/", dir(path = wkdir, full.names=TRUE))
# get file names from file list
catnum<-sub(".*/", "", FL)
# remove .JPG from file names
catnum<-sub(".JPG", "", catnum, ignore.case=TRUE)
# strip off "_letter" from file names
# so that only catalogNumber remains
# changed it to be case insensitive on 2023-11-20 (HB)
# b/c some files have ".jpg" vs. ".JPG"
catnum <- gsub("_\\D+","",catnum,ignore.case=TRUE)
#changed from "_\\D",""..." to "_\\D+",""..." on 2023-11-20 (HB).
#realized there was a problem when adding in situ images to the workflow because
#USCH0068840_insitu was changed to USCH0068400nsitu
#adding "+" matches 1 to unlimited times as many as needed

#create dataFrame
df <- data.frame(matrix(ncol = 5, nrow = 0))
# assign column names to match images.csv in DwC-A format
x <- c("catalogNumber","sourceURL","originalURL","thumbnailURL","URL")
# insert colnames into df
colnames(df)<-x
# populate df with constructed URLs and corresponding catalogNumbers
df[1:length(FL),]<-c(catnum,paste("https://img.cyverse.org/resize?width=4000&url=https://data.cyverse.org/dav-anon/iplant/projects/sernec/",FL,sep=""),
                           paste("https://img.cyverse.org/resize?width=4000&url=https://data.cyverse.org/dav-anon/iplant/projects/sernec/",FL,sep=""),
                           paste("https://img.cyverse.org/thumbnail?height=200&url=https://data.cyverse.org/dav-anon/iplant/projects/sernec/",FL,sep=""),
                           paste("https://img.cyverse.org/resize?width=1250&url=https://data.cyverse.org/dav-anon/iplant/projects/sernec/",FL,sep=""))

write.csv(df, paste(fiOUT, "UpLd_", date, "_Fldr_", JPGfldr, "_", min(catnum), "-", max(catnum), ".csv", sep=""), row.names = FALSE)

# Before submitting to the SERNEC website, check a couple of the URLs in the CSV result to make sure they actually resolve to an image.
# ALWAYS CHECK SOME IMAGE LINKS

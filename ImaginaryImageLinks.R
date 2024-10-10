# createImageLinks from CyVerse Imaginary service
# author Herrick H.K. Brown 2022-11-09
# Edits by Ryan Folk 2024 forward, variables, paths &c.

# Only this code block should need to be modified, and really only date needs to be modified in each mapping file creation
# It is not necessary to set the working directory

# IMPORTANT TIPS:
# MAKE SURE LOCAL FILES ARE IN DATED FOLDER (if you've already deleted a local temporary copy you can create a sequential batch of files of zero bytes like so and the script will still work:
# for i in {33102..34506}; do touch MISSA0${i}.JPG; done
# Before submitting to the SERNEC website, check a couple of the URLs in the CSV result to make sure they actually resolve to an image.
# ALWAYS CHECK SOME IMAGE URLs BEFORE SUBMITTING -- just paste them in your browser
# Submission area in Symbiota is Administration Control Panel > Processing Toolbox > New Profile > Image URL Mapping File then upload the CSV
# Make sure to check the box in the next screen that says to create new records if existing records are not found

### Set paths
# Enter root directory for image folder
rootdir <- "/Users/ryanfolk/Documents/GitHub/cyverse_imaginary/temp/" # only absolute paths here
# Enter upload date, needs to match dated folder name including any extra bits
date <- "3-27-2023_missed2017-2018_photos"
# Build working directory
wkdir <- paste(rootdir,date,sep="")
# Check that the working directory path exists
dir.create(file.path(paste(rootdir, date, "/", sep="")))
# Set output location
fiOUT <- "/Users/ryanfolk/Documents/GitHub/cyverse_imaginary/temp/"

### Create mappings
# Build file list including directory
FL <- sub("/Users/ryanfolk/Documents/GitHub/cyverse_imaginary/temp/", "MISSA/", dir(path = wkdir, full.names=TRUE))
# Get file names from file list
catnum<-sub(".*/", "", FL)
# Remove .JPG from file names
catnum<-sub(".JPG", "", catnum, ignore.case=TRUE)
# Strip off "_letter" from file names
# So that only catalogNumber remains
# Changed it to be case insensitive on 2023-11-20 (HB)
# b/c some files have ".jpg" vs. ".JPG"
catnum <- gsub("_\\D+","",catnum,ignore.case=TRUE)
# Changed from "_\\D",""..." to "_\\D+",""..." on 2023-11-20 (HB).
# Realized there was a problem when adding in situ images to the workflow because
# USCH0068840_insitu was changed to USCH0068400nsitu
# Adding "+" matches 1 to unlimited times as many as needed
# These patterns should not pertain to MISSA but still keep them

# Create empty dataframe
df <- data.frame(matrix(ncol = 5, nrow = 0))
# Assign a vector of column names to match images.csv in DwC-A format
# Symbiota should automatically recognize and map these column headers in the web interface
x <- c("catalogNumber","sourceURL","originalURL","thumbnailURL","URL")
# Insert column names into the dataframe
colnames(df)<-x
# Populate the dataframe with constructed Imaginary URLs and corresponding catalogNumbers
df[1:length(FL),]<-c(catnum,paste("https://img.cyverse.org/resize?width=4000&url=https://data.cyverse.org/dav-anon/iplant/projects/magnoliagrandiFLORA/sernec-portal/",FL,sep=""),
                           paste("https://img.cyverse.org/resize?width=4000&url=https://data.cyverse.org/dav-anon/iplant/projects/magnoliagrandiFLORA/sernec-portal/",FL,sep=""),
                           paste("https://img.cyverse.org/thumbnail?height=200&url=https://data.cyverse.org/dav-anon/iplant/projects/magnoliagrandiFLORA/sernec-portal/",FL,sep=""),
                           paste("https://img.cyverse.org/resize?width=1250&url=https://data.cyverse.org/dav-anon/iplant/projects/magnoliagrandiFLORA/sernec-portal/",FL,sep=""))
# Write the mapping file
write.csv(df, paste(fiOUT, "UpLd_", date, "_Fldr_", date, "_", min(catnum), "-", max(catnum), ".csv", sep=""), row.names = FALSE)


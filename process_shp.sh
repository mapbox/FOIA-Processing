#!/bin/bash
set -e -o pipefail

# open zip
# go over each file in zip
# convert each file
# zip all files

# us-ca-city_of_<X>.zip
#   - us-ca-city_of_<X>.shp
#   - us-ca-city_of_<X>.dbf
#   - ...

OUTPUT=$1
FILEPATH=$2

if [[ -z $OUTPUT ]]; then
    echo "Missing name of output"
    echo "Usage:"
    echo '  ./process_sh <country-region-layer> "path/to/zipfile"'
    echo ""
    echo "Example"
    echo './process_sh us-ca-city_of_new_york "../Downloads/nyc.zip"'
    exit
fi

if [[ -z $FILEPATH ]]; then
    echo "Missing filepath"
    echo "Usage:"
    echo '  ./process_sh <country-region-layer> "path/to/zipfile"'
    echo ""
    echo "Example"
    echo './process_sh us-ca-city_of_new_york "../Downloads/nyc.zip"'
    exit
fi


echo "Unzipping data..."
# mkdir unzipped

cd unzipped
# unzip "../${FILEPATH}"


OIFS=$IFS
IFS='.'

echo "Processing data files..."
for FILE in * # cycles through all files in directory (case-sensitive!)
do
    echo "converting file: $FILE..."
    FILENEW=`echo $FILE | sed "^\.[\w]+$"` # replaces old filename
    # NEWFILE= echo $OUTPUT
    echo $NEWFILE
    # FILENEW=`echo $FILE | sed "s/.mif/_new.shp/"` # replaces old filename
    # ogr2ogr \
    # -f "ESRI Shapefile" \
    # "$FILENEW" "$FILE"
done


echo "Finishing up"
cd ../
# rm -rf unzipped/
IFS=$OIFS



exit 0

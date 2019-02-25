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

echo "Processing data files..."
for FILE in * # cycles through all files in directory (case-sensitive!)
do
    echo "converting file: $FILE..."
    EXT=${FILE##*.}
    NEWFILE="${OUTPUT}.${EXT}"
    echo $NEWFILE
    mv "${FILE}" "${NEWFILE}"
    # ogr2ogr -f "ESRI Shapefile" -t_srs "EPSG:4326" $NEWFILE
    zip $OUTPUT.zip ${NEWFILE}
done


echo "Finishing up"
cd ../
mv unzipped/$OUTPUT.zip ./$OUTPUT.zip
# ogr2ogr \
# -f "ESRI Shapefile" \
# $OUTPUT.zip
# unzip ./$OUTPUT.zip
ogr2ogr -f "ESRI Shapefile" -t_srs "EPSG:4326" $OUTPUT.zip
# "$FILENEW" "$FILE"
# zip -r $OUTPUT.zip . -i unzipped/
# rm -rf unzipped/



exit 0

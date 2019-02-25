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
mkdir unzipped

cd unzipped
unzip "../${FILEPATH}"

echo "Processing data files..."
OUTFILE=$OUTPUT


ogr2ogr -f "ESRI Shapefile" -t_srs "EPSG:4326" ../$OUTFILE *.shp
cd ../$OUTFILE


for FILE in * # cycles through all files in directory (case-sensitive!)
do
    echo "converting file: $FILE..."
    EXT=${FILE##*.}
    # FILENAME=${FILE%.*}
    OUTFILE="${OUTPUT}.${EXT}"
    echo $OUTFILE
    mv "${FILE}" "${OUTFILE}"
    echo $OUTPUT
    zip $OUTPUT.zip ${OUTFILE}
done


echo "Finishing up"


cd ../
mv $OUTPUT/$OUTPUT.zip ./$OUTPUT.zip

rm -rf $OUTPUT/
rm -rf unzipped/

ls | grep $OUTPUT
rm $OUTPUT.zip

exit 0

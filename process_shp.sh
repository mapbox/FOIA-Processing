#!/bin/bash
set -e -o pipefail

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
    echo './process_sh us-ny-city_of_new_york "../Downloads/nyc.zip"'
    exit
fi

if [[ -z $FILEPATH ]]; then
    echo "Missing filepath"
    echo "Usage:"
    echo '  ./process_sh <country-region-layer> "path/to/zipfile"'
    echo ""
    echo "Example"
    echo './process_sh us-ny-city_of_new_york "../Downloads/nyc.zip"'
    exit
fi


echo "Unzipping data..."
mkdir unzipped

cd unzipped
unzip "../${FILEPATH}"

echo "Processing data files..."
OUTFILE=$OUTPUT
echo $OUTFILE

# Process shapefile file to expected projection
ogr2ogr -f "ESRI Shapefile" -t_srs "EPSG:4326" ../$OUTFILE *.shp

# Generate output for open addresses review
ogr2ogr -f "Geojson" -t_srs "EPSG:4326" $OUTFILE.geojson *.shp
jq '.features[0:1][0].properties |keys' $OUTFILE.geojson

for (( i = 0; i < 10; i++ )); do
    (jq .features[$i] $OUTFILE.geojson) >> ../$OUTFILE.json
done
cd ../$OUTFILE

# Rename files to expected output name
for FILE in *
do
    echo "converting file: $FILE..."
    EXT=${FILE##*.}
    OUTFILE="${OUTPUT}.${EXT}"
    mv "${FILE}" "${OUTFILE}"
    zip ../$OUTPUT.zip ${OUTFILE}
done

# Cleanup
echo "Finishing up"
cd ../
rm -rf $OUTPUT/
rm -rf unzipped/

exit 0

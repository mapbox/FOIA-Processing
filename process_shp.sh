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
    echo './process_sh us-ca-city_of_new_york "../Downloads/nyc.zip"'
    exit
fi


echo "Unzipping data..."
# mkdir unzipped

cd unzipped
# unzip "../${FILEPATH}"

echo "Processing data files..."
OUTFILE=$OUTPUT
echo $OUTFILE

ogr2ogr -f "ESRI Shapefile" -t_srs "EPSG:4326" ../$OUTFILE *.shp
ogr2ogr -f "Geojson" -t_srs "EPSG:4326" ../$OUTFILE.geojson *.shp
# ogr2ogr -f "Geojson" -t_srs "EPSG:4326" ../pumpkin.geojson *.shp
# cat ../pumpkin.geojson | jq .
# jq '.features[0:1][0].properties |keys' ../pumpkin.geojson
jq '.features[0:1][0].properties |keys' ../$OUTFILE.geojson

cd ../$OUTFILE
# ogrinfo -so *.shp


for FILE in *
do
    echo "converting file: $FILE..."
    EXT=${FILE##*.}
    OUTFILE="${OUTPUT}.${EXT}"
    mv "${FILE}" "${OUTFILE}"
    zip $OUTPUT.zip ${OUTFILE}
done

SHP=$OUTPUT.shp
echo $SHP

# QUERY="SELECT * FROM ${SHP%.*} WHERE 1"
# QUERY="SELECT * FROM apples.shp WHERE 1"
# echo $QUERY

# ogrinfo -q $SHP -sql "SELECT * FROM apples LIMIT 10"
# ogr2ogr -f "Geojson" -t_srs "EPSG:4326" $SHP "SELECT * FROM ${SHP%.*} LIMIT 10" -dialect SQLITE


echo "Finishing up"
cd ../
mv $OUTPUT/$OUTPUT.zip ./$OUTPUT.zip
rm -rf $OUTPUT/
# rm -rf unzipped/

# TODO: rm
rm $OUTPUT.zip
rm $OUTPUT.geojson
# rm pumpkin.geojson

exit 0

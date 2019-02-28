# Processing FOIA Requests
Currently this repo helps process FOIA `shp` files for Open Addresses imports

## Setup
_Follow the following setup actions in your terminal_

```
$ cd
$ install homebrew
$ brew install gdal
$ brew install jq
```

## Usage
_In order to run the script, copy this repo locally and use the following commands in your terminal_

Download the source zip file for easy access, then run
```
$ ./process_sh <name-of-output> "path/to/zipfile"
$ ./process_sh <country-region-layer> "path/to/zipfile"

Example
$ ./process_sh us-ny-city_of_new_york "../Downloads/nyc.zip"
```

Specific [naming conventions](https://github.com/openaddresses/openaddresses/blob/master/CONTRIBUTING.md#attribute-tags), as in the above example, for the output should be followed in order to import properly to Open Addresses. 

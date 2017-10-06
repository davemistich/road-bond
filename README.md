# road-bond

Really simple election results county choropleth for the West Virginia road bond referendum.

## Generating the West Virginia SVG

The West Virginia SVG that's included in `index.html` is built from a TIGER shape file of United States counties.  To download the source data and generate an SVG file from the shape file, just run:

    make

The technique used comes from Mike Bostock's [Command Line Cartography](https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c).

Running `make` will generate a file named `wv-albers.svg` in a `data` subdirectory.  Each path in the SVG has an `id` attribute set to the county name to make it easy to join results data to the SVG paths with D3.

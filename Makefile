DATA_DIR = data
WIDTH = 960
HEIGHT = 960

.PHONY: all clean install

all: $(DATA_DIR)/wv-albers.svg $(DATA_DIR)/wv.csv

# TODO Simplify the geometry 
$(DATA_DIR)/wv-albers.svg: $(DATA_DIR)/wv-albers.json
	ndjson-split < $(DATA_DIR)/wv-albers.json 'd.features' | \
	geo2svg -n -w $(WIDTH) -h $(HEIGHT) \
        > $(DATA_DIR)/wv-albers.svg	

$(DATA_DIR)/wv-albers.json: $(DATA_DIR)/wv.json
	geoproject 'd3.geoConicEqualArea().parallels([37, 41]).rotate([79, 0]).fitSize([$(WIDTH), $(HEIGHT)], d)' \
	< $(DATA_DIR)/wv.json \
        > $(DATA_DIR)/wv-albers.json
                    
$(DATA_DIR)/wv.json: $(DATA_DIR)/cb_2016_us_county_500k/cb_2016_us_county_500k.shp
	shp2json -n data/cb_2016_us_county_500k/cb_2016_us_county_500k.shp | \
	ndjson-filter 'd.properties.STATEFP === "54"' | \
	ndjson-map 'd.id = d.properties.NAME, d' | \
        ndjson-reduce 'p.features.push(d), p' '{type: "FeatureCollection", features: []}' \
        > $(DATA_DIR)/wv.json	

$(DATA_DIR)/cb_2016_us_county_500k/cb_2016_us_county_500k.shp: $(DATA_DIR)/cb_2016_us_county_500k.zip
	cp $(DATA_DIR)/cb_2016_us_county_500k.zip $(DATA_DIR)/cb_2016_us_county_500k.zip.bak && \
	unzip -d $(DATA_DIR)/cb_2016_us_county_500k $(DATA_DIR)/cb_2016_us_county_500k.zip && \
	mv $(DATA_DIR)/cb_2016_us_county_500k.zip.bak $(DATA_DIR)/cb_2016_us_county_500k.zip && \
	find $(DATA_DIR)/cb_2016_us_county_500k -exec touch {} \;

$(DATA_DIR)/cb_2016_us_county_500k.zip: $(DATA_DIR)
	curl -L -o $(DATA_DIR)/cb_2016_us_county_500k.zip http://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_county_500k.zip

$(DATA_DIR):
	mkdir -p $(DATA_DIR)

clean:
	rm -rf $(DATA_DIR)

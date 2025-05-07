#!/usr/bin/bash

chmod +w ./data.csv
python3 ./scraper.py $1
chmod -w ./data.csv

#!/bin/bash

# Define the directory containing your NetCDF files
data_dir="/Volumes/BM_2022_x/Hindcast_1990_2010"

# Output directory for individual mean files
mean_dir="$data_dir/means"

# Create the output directory if it doesn't exist
mkdir -p "$mean_dir"

# Loop through each year and month
for year in {1992..2010}; do
  for month in {1..12}; do
    # Construct the input and output filenames
    input_file="$data_dir/croco_avg_Y${year}M${month}.nc"
    mean_file="$mean_dir/Mean_Y${year}M${month}.nc"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
      echo "Skipping missing file: $input_file"
      continue
    fi

    # Calculate mean within the file using ncra
    ncra -d time,0 "$input_file" "$mean_file"
  done
done

echo "Individual means calculated and saved in: $mean_dir"


#!/bin/bash

# Define the directory containing your NetCDF files
data_dir="/Volumes/BM_2022_x/Hindcast_1990_2010"

# Log file for errors
log_file="ncdump_errors.log"

# Loop through each NetCDF file
for file in "$data_dir"/*.nc; do
  # Read the file with ncdump
  ncdump -h "$file" 2>&1 | tee /dev/null

  # Check exit code and print status
  if [[ $? -eq 0 ]]; then
    echo "$file: 1 (read successfully)"
  else
    echo "$file: 0 (error - details in log)"
    echo "$file: $(tail -1 $log_file)" >> $log_file
  fi

  echo "-------------------------"
done

echo "Log of errors saved to: $log_file"


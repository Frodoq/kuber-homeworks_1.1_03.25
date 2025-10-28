#!/bin/bash

echo "=== Checking generated manifests ==="
for file in manifests/*.yaml; do
    echo "File: $file"
    echo "---"
    cat "$file"
    echo -e "\n=== End of $file ===\n"
done

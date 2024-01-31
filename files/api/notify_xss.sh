#!/bin/bash

while IFS= read -r line; do
  printf '%s\n' "$line"
done | /usr/local/go/bin/notify -silent -provider-config /opt/provider-config.yaml -provider discord -id xss
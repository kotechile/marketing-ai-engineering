#!/usr/bin/env bash
# ==========================================================
# Video Engine: 480p to 1080p Upscaling & Camera Simulation
# ==========================================================
set -euo pipefail

INPUT_FILE="${1:-input_480p.mp4}"
OUTPUT_FILE="${2:-output_1080p.mp4}"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file $INPUT_FILE does not exist."
    exit 1
fi

echo "Upscaling $INPUT_FILE to 1080x1920 (9:16 mobile format)..."

# Filter explanation:
# 1. scale=1080:1920:flags=lanczos -> High-quality Lanczos upscale
# 2. noise=alls=7:allf=t+u         -> Subtle sensor noise to remove plasticky AI finish
# 3. unsharp=5:5:0.7:3:3:0.3       -> Micro-contrast sharpening for natural smartphone feel
ffmpeg -y -i "$INPUT_FILE" \
    -vf "scale=1080:1920:flags=lanczos,noise=alls=7:allf=t+u,unsharp=5:5:0.7:3:3:0.3" \
    -c:v libx264 \
    -preset slow \
    -crf 18 \
    -c:a copy \
    "$OUTPUT_FILE"

echo "Done! Rendered to $OUTPUT_FILE"

"""
Video Pipeline Engine - Laptop Runner
Coordinates ElevenLabs TTS, low-res Fal lip-sync, FFmpeg upscaling, and Remotion motion overlays.
"""

import os
import sys
import json
import subprocess
import requests

FAL_KEY = os.getenv("FAL_KEY", "")
ELEVENLABS_KEY = os.getenv("ELEVENLABS_KEY", "")

def generate_voiceover(script_text: str, output_path: str = "output_audio.mp3", voice_id: str = "21m00Tcm4TlvDq8ikWAM") -> str:
    print(f"Generating ElevenLabs voiceover for voice {voice_id}...")
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
    headers = {"xi-api-key": ELEVENLABS_KEY, "Content-Type": "application/json"}
    payload = {
        "text": script_text,
        "model_id": "eleven_turbo_v2",
        "voice_settings": {"stability": 0.5, "similarity_boost": 0.8}
    }
    res = requests.post(url, json=payload, headers=headers)
    res.raise_for_status()
    with open(output_path, "wb") as f:
        f.write(res.content)
    print(f"Audio saved to {output_path}")
    return output_path

def run_upscale(input_path: str, output_path: str):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sh_script = os.path.join(script_dir, "upscale_and_enhance.sh")
    subprocess.run([sh_script, input_path, output_path], check=True)

if __name__ == "__main__":
    print("Video pipeline initialized. Ensure FAL_KEY and ELEVENLABS_KEY are set.")

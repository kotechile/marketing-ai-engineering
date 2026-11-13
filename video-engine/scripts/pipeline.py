"""
Video Pipeline Engine - Laptop Runner with Direct Kie.ai & ElevenLabs Integration
"""

import os
import sys
import json
import time
import requests
import subprocess

KIE_API_KEY = os.getenv("KIE_API_KEY", "")
ELEVENLABS_KEY = os.getenv("ELEVENLABS_KEY", "")

def generate_voiceover(script_text: str, output_path: str = "output_audio.mp3", voice_id: str = "21m00Tcm4TlvDq8ikWAM") -> str:
    """Generate audio read via ElevenLabs"""
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

def generate_seedance_avatar_kie(image_url: str, audio_url: str, prompt: str = "") -> str:
    """
    Generate 480p talking avatar via Kie.ai ByteDance Seedance 2.5
    """
    print("Calling Kie.ai for ByteDance Seedance 2.5...")
    url = "https://api.kie.ai/v1/jobs"
    headers = {
        "Authorization": f"Bearer {KIE_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "bytedance/seedance-2-5",
        "input": {
            "image": image_url,
            "audio": audio_url,
            "resolution": "480p",
            "prompt": prompt or "natural talking head, realistic UGC review style"
        }
    }
    res = requests.post(url, json=payload, headers=headers)
    res.raise_for_status()
    job_id = res.json().get("id")
    print(f"Job submitted to Kie.ai (ID: {job_id}). Waiting for render...")
    
    # Poll for completion
    while True:
        status_res = requests.get(f"https://api.kie.ai/v1/jobs/{job_id}", headers=headers).json()
        status = status_res.get("status")
        if status == "succeeded":
            return status_res.get("output", {}).get("video_url")
        elif status in ("failed", "canceled"):
            raise RuntimeError(f"Kie.ai render failed: {status_res}")
        time.sleep(5)

def run_upscale(input_path: str, output_path: str):
    """FFmpeg 480p -> 1080p Lanczos upscale + sensor grain"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sh_script = os.path.join(script_dir, "upscale_and_enhance.sh")
    subprocess.run([sh_script, input_path, output_path], check=True)

if __name__ == "__main__":
    print("Kie.ai Video Pipeline Ready. Set KIE_API_KEY and ELEVENLABS_KEY to execute.")

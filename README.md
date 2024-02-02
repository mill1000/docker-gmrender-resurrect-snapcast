# docker-gmrender-resurrect-snapcast
A Dockerfile for the gmrender-resurrect tailored for Snapcast.

## Compose Example
```yaml
services:
  gmrender-resurrect:
    image: gmrender-resurrect-snapcast:latest
    container_name: gmrender-resurrect
    restart: unless-stopped
    network_mode: host
    environment:
      FRIENDLY_NAME: "Snapcast"
      OPTIONS: "--mime-filter audio --gstout-audiopipe 'audioresample ! audioconvert ! audio/x-raw,rate=44100,format=S16LE,channels=2 ! filesink location=/snapcast/gmrender-resurrect'"
    volumes:
      - snapcast-pipes:/snapcast

volumes:
  snapcast-pipes:
```
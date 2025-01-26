# docker-gmrender-resurrect-snapcast
A Docker image for [gmrender-resurrect](https://github.com/hzeller/gmrender-resurrect) tailored for use with a [Snapcast](https://github.com/badaix/snapcast) server.

## Compose Example
```yaml
services:
  gmrender-resurrect:
    image: ghcr.io/mill1000/gmrender-resurrect-snapcast:latest
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
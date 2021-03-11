#!/bin/bash
mkdir -p /home/user/.config/spotify
chown -R user:user /home/user/.config/spotify
ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Update Spotify
echo "======== Update ========"
echo "Checking for updates ..."
sudo apt update
sudo apt install --yes spotify-client
echo "Done."

# Create virtual display
echo "======== Virtual display ========"
echo "Starting display server ..."
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99
x11vnc -display :99 -nopw -forever -quiet -geometry 1024x768 &
websockify -D --web=/usr/share/novnc/ 8080 localhost:5900 &
echo "Done."

# Start PulseAudio
echo "======== PulseAudio ========"
echo "Starting audio server ..."
sudo -H -u user bash -c pulseaudio &
echo "Done."

# Start PulseAudio
echo "======== Spotify Client ========"
echo "Starting Spotify ..."
sudo -H -u user bash -c spotify --disable-gpu

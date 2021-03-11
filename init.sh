#!/bin/bash
mkdir -p /home/user/.config/spotify
chown -R user:user /home/user/.config/spotify
ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Update Spotify
printf "\t======== Update ========\n"
printf "Checking for updates ...\n"
sudo apt update
sudo apt install --yes spotify-client
printf "Done.\n"

# Create virtual display
printf "\t======== Display ========\n"
printf "Starting Xvfb server ...\n"
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99
x11vnc -display :99 -nopw -forever -quiet -geometry 1024x768 &
websockify -D --web=/usr/share/novnc/ 8080 localhost:5900 &
printf "Done.\n"

# Start PulseAudio
printf "\t======== Audio ========\n"
printf "Starting PulseAudio ...\n"
sudo -H -u user bash -c pulseaudio 2>/dev/null &
printf "Done.\n"

# Start Spotify
printf "\t======== Client ========\n"
printf "Starting Spotify ...\n"
printf " __________________________________________________\n"
printf "|                                                  |\n"
printf "|   Login to Spotify: http://localhost:8080/       |\n"
printf "|__________________________________________________|\n\n"
sudo -H -u user bash -c "spotify --disable-gpu --disable-software-rasterizer --no-zygote"

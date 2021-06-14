#!/bin/bash
chown -R user:user /home/user/.config/spotify
if [ ! -f "/usr/share/novnc/index.html" ]; then
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html
fi

# Update Spotify
printf "\t======== Update ========\n"
printf "Checking for updates ...\n"
sudo apt update
sudo apt install --yes spotify-client
printf "Done.\n"

# Create virtual display
printf "\t======== Display ========\n"
printf "Starting Xvfb server ...\n"
if [ -f "/tmp/.X99-lock" ]; then
    rm -f /tmp/.X99-lock
fi
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99
sleep 1
if pgrep -x "Xvfb" >/dev/null
then
    printf "Done.\n"
else
    exit 1
fi

printf "Starting X11vnc ...\n"
x11vnc -display :99 -nopw -forever -quiet -geometry 1024x768 &
sleep 1
if pgrep -x "x11vnc" >/dev/null
then
    printf "Done.\n"
else
    exit 1
fi

printf "Starting noVNC ...\n"
websockify -D --web=/usr/share/novnc/ 8080 localhost:5900 &
sleep 1
if pgrep -x "websockify" >/dev/null
then
    printf "Done.\n"
else
    exit 1
fi

# Start PulseAudio
printf "\t======== Audio ========\n"
printf "Starting PulseAudio ...\n"
sudo -H -u user bash -c pulseaudio >/dev/null &
sleep 1
if pgrep -x "pulseaudio" >/dev/null
then
    printf "Done.\n"
else
    exit 1
fi

# Start Spotify
printf "\t======== Client ========\n"
printf "Starting Spotify ...\n"
printf " __________________________________________________\n"
printf "|                                                  |\n"
printf "|   Login to Spotify: http://localhost:8080/       |\n"
printf "|__________________________________________________|\n\n"
sudo -H -u user bash -c "spotify --disable-gpu --disable-software-rasterizer --no-zygote >/dev/null"
exit 0

# How install?
you need git clone `https://github.com/Yanoky1/mp3tag-selkies` and run 
```
docker compose build --no-cache
docker compose up -d
```
I built this Dockerfile using Claude & ChatGPT because I wasn’t satisfied with the existing mp3tag implementations in Docker with a web UI. It dynamically adapts the interface to the window size. To launch it, open https://ipserver:youport, click “Close,” then wait for the program to open, and add the root path to the music.

PLAYBACK := "mpv --no-video --ao=alsa --af=aresample=resampler=soxr --loop-playlist --shuffle"

_default:
    @just --choose

night:
    @pgrep gammastep >/dev/null \
      && pkill gammastep \
      || (gammastep -P -O {{env_var_or_default("COLOR", "3500")}} & disown)

music:
	@clear
	@easyeffects & disown
	{{PLAYBACK}} ~/media/music

chill:
	@clear
	@easyeffects & disown
	{{PLAYBACK}} https://www.youtube.com/watch?v=ZUIT_rQIR5M

update-music:
    @yt-dlp \
        -x --audio-format opus \
        -o "~/media/music/%(title)s.%(ext)s" \
        --yes-playlist \
        -N 64 \
        --sleep-interval 30 \
        --downloader aria2c \
        --downloader-args aria2c:"-x 16 -k 1M" \
        --cookies-from-browser firefox \
        "https://www.youtube.com/playlist?list=PLFen3AmxoGIhg_wPkrGE3h-v19pAIkgRW"

cache-clear:
	sudo rm -rf /home/kachi/.cache/*
	sudo rm -rf /root/.cache/*
	sudo rm -rf /var/cache/*
	rm -rf /home/kachi/.local/share/Trash/*
	sudo rm -rf /root/.local/share/Trash/*
	sudo journalctl --vacuum-time=1d

break-time:
    @while true; do \
        swaylock; \
        sleep 1200; \
    done

chat:
    sh -c 'read -p "Server IP: " server; \
           read -p "Port: " port; \
           read -p "Username: " name; \
           while read -r line; do \
               echo "[ $name ]: $line"; \
           done | ncat $server $port'

todo:
	taskwarrior-tui --taskdata .task

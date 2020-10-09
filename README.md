# DiscordWebhooks.sh
## Tiny Discord webhooks cli
Use webhooks to post in discord.
Manages multiple users and channels.

Only dependency is fzf (used as a menu) but this could 
easily be substituted with something like dmenu.

Intentionally left barebones to stay below 20 SLOC.

```sh
#!/bin/sh

save() { read -p "Enter $1: " r1; read -p "Enter $2: " r2; echo "$r1~|~$r2" >> "$3"; }

mkdir -p ~/.config/cordhooks/;
if [ -z $1 ]; then
    user=$(cat ~/.config/cordhooks/users.csv | fzf)
    username=$(echo $user | sed "s/~|~.*//")
    avatar_url=$(echo $user | sed "s/.*~|~//")
    webhook_url=$(cat ~/.config/cordhooks/channels.csv | fzf | sed "s/.*~|~//")
    echo "Enter message:"
    while true; do
        read -p "> " msg
        data="{\"username\": \"$username\", \"avatar_url\": \"$avatar_url\", \"content\": \"$msg\" }"
        curl -X POST -H "Content-Type: application/json" -d "$data" $webhook_url
    done
elif [ "$1" = "adduser" ]; then save "username" "avatar url" "~/.config/cordhooks/users.csv";
elif [ "$1" = "addchannel" ]; then save "channel name" "webhook url" "~/.config/cordhooks/channels.csv";
fi
```

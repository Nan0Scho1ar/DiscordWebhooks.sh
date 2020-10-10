#!/bin/bash

save() { read -p "Enter $1: " r1; read -p "Enter $2: " r2; echo "$r1~|~$r2" >> $3; }
delete() { sed -i $(cat -n $1 | fzf --with-nth 2.. | awk '{print $1"d"}') $1; }

mkdir -p ~/.config/discordwebhooks/;
if [ -z $1 ]; then
    IFS='~|~' read -r username avatar_url <<< $(cat $HOME/.config/discordwebhooks/users.bm | fzf)
    IFS='~|~' read -r channel_name webhook_url <<< $(cat $HOME/.config/discordwebhooks/channels.bm | fzf)
    echo "Enter message:"
    while true; do
        read -p "> " msg || exit 1
        data="{\"username\": \"$username\", \"avatar_url\": \"$avatar_url\", \"content\": \"$msg\" }"
        curl -X POST -H "Content-Type: application/json" -d "$data" $webhook_url
    done
elif [ "$1" = "adduser" ]; then save "username" "avatar url" "$HOME/.config/discordwebhooks/users.bm";
elif [ "$1" = "addchannel" ]; then save "channel name" "webhook url" "$HOME/.config/discordwebhooks/channels.bm";
elif [ "$1" = "deleteuser" ]; then delete "$HOME/.config/discordwebhooks/users.bm";
elif [ "$1" = "deletechannel" ]; then delete "$HOME/.config/discordwebhooks/channels.bm";
fi

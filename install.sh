#!/bin/bash



echo "📩 Installing tools..."

# install curl
sudo apt-get update && sudo apt-get install curl || { echo "❌ Failed to install curl. Exiting..."; exit 1; }
echo "✅ curl installed."

#install wget
sudo apt-get update && sudo apt-get install wget || { echo "❌ Failed to install wget. Exiting..."; exit 1; }
echo "✅ wget installed."

# install git
sudo apt-get update && sudo apt-get install git || { echo "❌ Failed to install git. Exiting..."; exit 1; }
echo "✅ git installed."

# install gh (GitHub CLI)
sudo apt-get update && sudo apt-get install gh || { echo "❌ Failed to install gh. Exiting..."; exit 1; }
echo "✅ gh installed."



echo "📩 Installing applications..."

# install Spotify
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client || { echo "❌ Failed to install Spotify. Exiting..."; exit 1; }
echo "✅ Spotify installed."

# install Discord
DISCORD_PATH="/usr/share/discord/resources/build_info.json"
DISCORD_DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
if [ -f "$DISCORD_PATH" ]; then
    installed_version=$(jq -r ".version" < "$DISCORD_PATH")
else
    installed_version=""
fi
deb_url=$(curl -s -I "$DISCORD_DOWNLOAD_URL" | grep -i "location:" | awk -F': ' '{print $2}' | tr -d '\r\n')
current_version=$(basename "$deb_url" | sed 's/^discord-\(.*\).deb/\1/')
if [[ "$installed_version" != "$current_version" ]]; then
    echo "Installed Discord version ($installed_version) differs from the current version ($current_version)."
    echo "Downloading and updating to version $current_version..."
    file_name="$TEMP_DIR/discord-$current_version.deb"
    if curl -s "$deb_url" -o "$file_name"; then
        echo "Installing Discord..."
        if dpkg -i "$file_name"; then
            echo "✅ Discord updated."
        else
            echo "❌ Discord installation failed. Attempting to fix broken dependencies..."
            apt-get -f install -y
        fi
        rm -f "$file_name"
    else
        echo "❌ Failed to download Discord package."
    fi
else
    echo "✅ Discord is already up-to-date (version $installed_version)."
fi

# install VSCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
sudo apt-get update && sudo apt-get install code || { echo "❌ Failed to install VSCode. Exiting..."; exit 1; }
rm microsoft.gpg
echo "✅ VSCode installed."



echo "📩 Installing dotfiles..."



echo "🎉 Installation completed successfully!"
#!/usr/bin/env bash
function main() {
    
    source "sharedFuncs.sh"

    load_paths
    WINE_PREFIX="$SCR_PATH/prefix"

    #resources will be remove after installation
    RESOURCES_PATH="$SCR_PATH/resources"
    
    export_var
    install_cameraRaw
}

function install_cameraRaw() {
    local filename="CameraRaw_12_2_1.exe"
    local filemd5="b6a6b362e0c159be5ba1d0eb1ebd0054"
    local filelink="https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe"
    local filepath="$filename"

    wget -O CameraRaw_12_2_1.exe "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe"

    echo "===============| Adobe Camera Raw v12 |===============" >> "$SCR_PATH/wine-error.log"
    show_message2 "Adobe Camera Raw v12 installation..."

    wine CameraRaw_12_2_1.exe

    notify-send "Photoshop CC" "Adobe Camera Raw v12 installed successfully" -i "photoshop"
    show_message2 "Adobe Camera Raw v12 installed..."
    unset filename filemd5 filelink filepath
}

main

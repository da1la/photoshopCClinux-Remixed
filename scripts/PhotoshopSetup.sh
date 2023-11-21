#!/usr/bin/env bash
source "sharedFuncs.sh"

function main() {

    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH

    setup_log "================| script executed |================"

    RESOURCES_PATH="$SCR_PATH/resources"
    WINE_PREFIX="$SCR_PATH/prefix"

    #create new wine prefix for photoshop
    rmdir_if_exist $WINE_PREFIX

    #export necessary variable for wine
    export_var

    #config wine prefix and install mono and gecko automatic
    winecfg -v win7
    #create resources directory
    rmdir_if_exist $RESOURCES_PATH

    winetricks --self-update
    winetricks -q atmlib fontsmooth=rgb vcrun2008 vcrun2010 vcrun2012 vcrun2013 atmlib msxml3 msxml6

    #install photoshop
    install_photoshopSE
    
    replacement

    if [ -d $RESOURCES_PATH ];then
        echo "deleting resources folder"
        rm -rf $RESOURCES_PATH
    else
        error "resources folder Not Found"
    fi

    launcher
    echo "when you run photoshop for the first time it may take a while"
    echo "Almost finished..."
    sleep 5
}

function replacement() {
    local filename="replacement.tgz"
    local filepath="$filename"

    wget -O $filename "https://www.dropbox.com/scl/fi/oq1hn78tf77xa63p3hzpx/replacement.tgz?rlkey=ssm600xp46kl0b9i9fj7i8leq&dl=1"
    mkdir replacement
    echo "extract replacement component..."
    tar -xzf $filename -C replacement

    rm -rf "$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Resources/IconResources.idx"
    rm -rf "$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Resources/PSIconsHighRes.dat"
    rm -rf "$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Resources/PSIconsLowRes.dat"

    cd replacement
    cp -f * "$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Resources/" || error "cant copy replacement files..."
    cd ..

    echo "replace component compeleted..."
    unset filename filemd5 filelink filepath
}

function install_photoshopSE() {
    local filename="photoshopCC-V19.1.6-2018x64.tgz"
    local filepath="$filename"

    wget -O $filename "https://www.dropbox.com/scl/fi/6xm3hsm3muvb25gpsdycg/photoshopCC-V19.1.6-2018x64.tgz?rlkey=xjspcevujzm7r6cca5yzu72jy&dl=1"
    mkdir photoshopCC
    echo "extract photoshop..."
    tar -xzf "$filename" -C photoshopCC

    echo "===============| photoshop CC v19 |===============" >> "$SCR_PATH/wine-error.log"
    echo "install photoshop..."
    echo "Please don't change default Destination Folder"

    wine64 "photoshopCC/photoshop_cc.exe" &>> "$SCR_PATH/wine-error.log" || error "sorry something went wrong during photoshop installation"
    
    echo "removing useless helper.exe plugin to avoid errors"
    rm "$WINE_PREFIX/drive_c/users/$USER/PhotoshopSE/Required/Plug-ins/Spaces/Adobe Spaces Helper.exe"

    notify-send "Photoshop CC" "photoshop installed successfully" -i "photoshop"
    echo "photoshopCC V19 x64 installed..."
    unset filename filemd5 filelink filepath
}

check_arg $@
save_paths
main

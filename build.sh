#!/bin/bash

mkdir build

zipdata() {
    echo "zipping up data..."
    cd src/
    zip -9 -r data.love .
    mv data.love ../build/data.love
}

if [ $1 ]
then
if [ $1 = "linux" ]
then
    zipdata
    cd ../build
    mkdir linux && cd linux
    echo "downloading and extracting appimage..."
    wget https://github.com/love2d/love/releases/download/11.4/love-11.4-x86_64.AppImage
    chmod +x love-11.4-x86_64.AppImage
    ./love-11.4-x86_64.AppImage --appimage-extract
    echo "creating exectuable..."
    cat squashfs-root/bin/love ../data.love > squashfs-root/bin/astview
    chmod +x squashfs-root/bin/astview

    echo "recreating desktop file..."
    rm squashfs-root/love.desktop
cat <<EOF > squashfs-root/love.desktop
[Desktop Entry]
Name=ASTView
Comment=Lua based Clang AST Dump viewer
MimeType=application/x-love-game;
Exec=astview 
Type=Application
Categories=Development;Utility;
Terminal=false
Icon=love
NoDisplay=true
EOF
    chmod +x squashfs-root/love.desktop

    echo "downloading appimagetool..."
    wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
    echo "packaging appimage..."
    ./appimagetool-x86_64.AppImage squashfs-root
    mv ASTView-x86_64.AppImage ../ASTView-x86_64.AppImage
    cd ../
    echo "build complete."
elif [ $1 = "windows" ]
then
    zipdata
    cd ../build
    mkdir windows && cd windows
    echo "downloading win64 exe..."
    wget https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip
    unzip love-11.4-win64.zip
    echo "fusing with love2d..."
    cd love-11.4-win64 && cat love.exe ../../data.love > astview.exe && rm love.exe
    echo "zipping build exe..."
    zip -9 -r astview-win64.zip . && mv astview-win64.zip ../../astview-win64.zip
    cd ../

    echo "downloading win32 exe..."
    wget https://github.com/love2d/love/releases/download/11.4/love-11.4-win32.zip
    unzip love-11.4-win32.zip
    echo "fusing with love2d..."
    cd love-11.4-win32 && cat love.exe ../../data.love > astview.exe && rm love.exe
    echo "zipping build exe..."
    zip -9 -r astview-win32.zip . && mv astview-win32.zip ../../astview-win32.zip
    cd ../../
    echo "build complete."
elif [ $1 = "macos" ]
then
    echo "macOS building is not supported via this script!"
else
    echo "astview build script: please provide operating system to build for."
fi
else
    echo "astview build script: please provide operating system to build for."
fi

echo "deleting remaining build data..."
rm data.love
rm -rf linux
rm -rf windows
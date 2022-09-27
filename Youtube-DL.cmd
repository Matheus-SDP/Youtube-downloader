@SETLOCAL ENABLEDELAYEDEXPANSION
@echo off

FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {374DE290-123F-4565-9164-39C4925E467B}`) DO (
    set dowfolder=%%A %%B
set dowfolder=!dowfolder:~0,-1!
    )

set/p link=Link (Playlist ou Video):

echo. 
echo Formato de saida:
echo 1. Video Compactado (*.Mkv)
echo 2. Video Original (*.Mp4)
echo 3. Audio (*.Mp3)
set /p scale=Escolha: 
echo. 

IF "%scale%"=="1" ( 
    call :Original 
    GOTO :EOF
) ELSE IF "%scale%"=="2" ( 
    call :Mp4 
    GOTO :EOF
) ELSE (  
    call :MP3
    GOTO :EOF
)


:Original
yt-dlp.exe -o "%dowfolder%\%%(title)s.%%(ext)s" -i "%link%"   --hls-prefer-native --format bestvideo+bestaudio/best --merge-output-format mkv --youtube-skip-dash-manifest --add-metadata --embed-subs --sub-lang en --write-auto-sub --convert-subtitles srt  
goto :eof

:Mp4
yt-dlp.exe -o "%dowfolder%\%%(title)s.%%(ext)s"  -i "%link%" --hls-prefer-native -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4 --youtube-skip-dash-manifest --add-metadata --embed-subs --sub-lang en --write-auto-sub --convert-subtitles srt  
goto :eof

:MP3
yt-dlp.exe -o "%dowfolder%\%%(title)s.%%(ext)s" --extract-audio --audio-format mp3 -f bestaudio --metadata-from-title "%%(artist)s - %%(title)s" --add-metadata -i "%link%"  --embed-thumbnail --convert-thumbnails jpg --ppa "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
goto :eof

:End
endlocal


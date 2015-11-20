@ECHO off

powershell -command "& cls"

:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" (set bit=x64) ELSE (set bit=x86)


ECHO #=========================================
ECHO # A Windows installer package written by 
ECHO # Bill Chandler using Chocolatey package 
ECHO # manager.
ECHO #=========================================

ECHO This installer will install software, that you choose, to it's default location which cannot be changed. 
ECHO If there is any software that you would rather choose the installation location please choose no when prompted and install the software manually using the installer from the software website.
ECHO.
ECHO By using this installer you consent to all software installer licenses that are included in this pack. 
ECHO You also consent to Chocolatey package manager being installed on your PC for the specific purpose of installing software. 
ECHO.
ECHO No software will be installed to your machine without prior warning and your consent. Only software that is displayed will be installed.
ECHO.
ECHO If, once the installer is complete, you wish to uninstall chocolatey from your system please follow the instructions found here: http://github.com/chocolatey/choco/wiki/uninstallation
PAUSE

ECHO.
ECHO.
ECHO.
SET /P c=Before we begin would you like to install software (type "install") or check for updates (type "update") for already installed software? Return without input will end this script.
IF /I "%c%" EQU "update" ( 
  goto :update
) ELSE IF /I "%c%" EQU "install" ( 
  goto :basic_installations
) ELSE ( 
  goto :end_installer 
)

:update
ECHO.
ECHO Running Package Updater. This will check for updates for any packages installed using this script.
ECHO This will take quite some time depending on what packages are installed.
ECHO Output to the screen will show which packages were updated.
powershell -command "& cup all -y"
ECHO.
SET c=
SET /P c=All packages were updated. Would you like to install some more packages or exit? Type "install" or "exit"
IF /I "%c%" EQU "install" ( 
  goto :basic_installations
) ELSE IF /I "%c%" EQU "exit" ( 
  GOTO :end_installer 
) ELSE ( 
  GOTO :end_installer 
)

:basic_installations
ECHO Running prerequisites for installation. Please wait...
powershell -command "& Set-ExecutionPolicy -ExecutionPolicy Unrestricted;$a=new-object net.webclient;$a.proxy.credentials=[system.net.credentialcache]::defaultnetworkcredentials;$a.downloadstring('https://chocolatey.org/install.ps1')|iex">NUL
ECHO Prerequisites installed.
ECHO.
ECHO #=========================================
ECHO # BASIC INSTALLATIONS
ECHO # Stuff you need.
ECHO #=========================================

:choose_mbam
ECHO.
SET c=
SET /P c=Would you like to install malwarebytes anti-virus?(y/N)
IF /I "%c%" EQU "Y" ( 
  GOTO :install_mbam
) ELSE IF /I "%c%" EQU "N" ( 
  GOTO :choose_plugins 
) ELSE ( 
  GOTO :choose_plugins
)

:install_mbam
ECHO Installing Malwarebytes
powershell -command "& cinst malwarebytes -y">NUL || ECHO Malwarebytes already installed and up to date.
GOTO :choose_plugins

:choose_plugins
ECHO.
SET c=
set /P c=Would you like to update your plugins eg.flash, silverlight, java?(y/N)
if /I "%c%" EQU "Y" ( 
  goto :install_plugins
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_browser
) ELSE ( 
  GOTO :choose_browser 
)

:install_plugins
ECHO Installing Silverlight
powershell -command "& cinst silverlight -y">NUL
ECHO.
ECHO Installing Flash
powershell -command "& cinst flashplayerplugin -y">NUL
ECHO.
ECHO Installing Java
powershell -command "& cinst jre8 -y">NUL
ECHO.
ECHO Installing .Net 4.5
powershell -command "& cinst dotnet4.5.1 -y">NUL
GOTO :choose_browser

:choose_browser
ECHO.
SET c=
SET /P c=Would you like to install a browser? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_browser
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_7zip
) ELSE ( 
  GOTO :choose_7zip
)

:install_browser
ECHO.
SET c=
SET /P c=Which browser would you like to install? (Please enter: 'c' for Chrome, 'f' for Firefox, 'o' for Opera OR press return without typing to skip to next step)
IF /I "%c%" EQU "C" ( 
  goto :install_chrome
) ELSE IF /I "%c%" EQU "F" ( 
  goto :install_firefox
) ELSE IF /I "%c%" EQU "O" ( 
  goto :install_opera
) ELSE ( 
  GOTO :choose_7zip 
)

:install_chrome
ECHO Installing Google Chrome
IF bit == x64  ( powershell -command "& cinst google-chrome-x64 -y">NUL 
) ELSE ( powershell -command "& cinst googlechrome -y">NUL )
GOTO :choose_7zip 
:install_firefox
ECHO Installing Firefox
powershell -command "& cinst firefox -y">NUL
GOTO :choose_7zip
:install_opera
Installing Opera
powershell -command "& cinst opera -y">NUL
GOTO :choose_7zip

:choose_7zip
ECHO.
SET c=
SET /P c=Would you like to install 7zip? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_7zip
) ELSE IF /I "%c%" EQU "N" ( 
  goto :dev_installations
) ELSE ( 
  GOTO :dev_installations
)

:install_7zip
ECHO Installing 7zip
powershell -command "& cinst 7zip -y">NUL
GOTO :dev_installations

:dev_installations
ECHO.
SET c=
SET /P c=Basic installs complete. Would you like to development software?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :dev_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :media_installations_skipdev
) ELSE ( 
  goto :media_installations_skipdev
)
:dev_next
ECHO.
ECHO #=========================================
ECHO # DEVELOPMENT SOFTWARE
ECHO # For the programmer in you.
ECHO #=========================================
ECHO.

SET c=
SET /P c=Would you like to install a text editor? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :choose_editor
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_vs
) ELSE ( 
  goto :choose_vs
)

:choose_editor
SET c=
SET /P c=Please choose which editor to install or press return without typing to skip to next step. n = notepad++, s = Sublime Text 3, b = Brackets, v = Vim
IF /I "%c%" EQU "N" ( 
  goto :install_notepad++
) ELSE IF /I "%c%" EQU "S" ( 
  goto :install_sublime
) ELSE IF /I "%c%" EQU "B" ( 
  goto :install_brackets
) ELSE IF /I "%c%" EQU "V" ( 
  goto :install_vim
) ELSE ( 
  goto :choose_vs 
) 

:install_notepad++
ECHO Installing Notepad++
powershell -command "& cinst notepadplusplus -y">NUL
GOTO :choose_vs
:install_sublime
ECHO Installing Sublime Text 3 and Sublime Text 3 Package Control
powershell -command "& cinst sublimetext3 sublimetext3.packagecontrol -y">NUL
GOTO :choose_vs
:install_brackets
ECHO Installing Brackets
powershell -command "& cinst brackets -y">NUL
GOTO :choose_vs
:install_vim
ECHO Installing Vim
powershell -command "& cinst vim -y">NUL
GOTO :choose_vs

:choose_vs
ECHO.
SET c=
SET /P c=Would you like to install Visual Studio 2015 Community? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_vs
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_eclipse
) ELSE ( 
  goto :choose_eclipse
)

:install_vs
ECHO Installing Visual Studio 2015. This may take some time.
powershell -command "& cinst visualstudio2015community -y">NUL
GOTO :choose_eclipse

:choose_eclipse
ECHO.
SET c=
SET /P c=Would you like to install Eclipse? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_eclipse
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_unity
) ELSE ( 
  goto :choose_unity
)

:install_eclipse
ECHO.
ECHO Installing Eclipse. This may take some time.
powershell -command "& cinst install eclipse -y">NUL
GOTO :choose_unity

:choose_unity
ECHO.
SET c=
SET /P c=Would you like to install Unity? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_unity
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_putty
) ELSE ( 
  goto :choose_putty
)

:install_unity
ECHO.
ECHO Installing Unity. This may take some time.
powershell -command "& cinst unity -y">NUL
GOTO :choose_putty

:choose_putty
ECHO.
SET c=
SET /P c=Would you like to install puTTY? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_putty
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_git
) ELSE ( 
  goto :choose_git
)

:install_putty
ECHO.
ECHO Installing puTTY.
powershell -command "& cinst putty -y">NUL
GOTO :choose_git

:choose_git
ECHO.
SET c=
SET /P c=Would you like to install Git? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_git
) ELSE IF /I "%c%" EQU "N" ( 
  goto :media_installations
) ELSE ( 
  goto :media_installations
)

:install_git
ECHO.
ECHO Installing Git.
powershell -command "& cinst git -y">NUL
GOTO :media_installations

:media_installations_skipdev
ECHO.
SET c=
SET /P c=Skipping Development installs. Would you like to install media software? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :media_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :gaming_installations_skipmedia
) ELSE ( 
  goto :gaming_installations_skipmedia
)

:media_installations
ECHO.
SET c=
SET /P c=Development software installed. Would you like to install media software? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :media_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :gaming_installations_skipmedia
) ELSE ( 
  goto :media_next 
)

:media_next
ECHO.
ECHO #=========================================
ECHO # MEDIA INSTALLATIONS
ECHO # Audio, Visual and Communication.
ECHO #=========================================

ECHO.
SET c=
SET /P c=Would you like to install Foobar2000? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_foobar
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_vlc
) ELSE ( 
  goto :choose_vlc
)

:install_foobar
ECHO.
ECHO Installing Foobar2000.
powershell -command "& cinst foobar2000 -y">NUL
GOTO :choose_vlc

:choose_vlc
ECHO.
SET c=
SET /P c=Would you like to install VLC player? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_vlc
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_itunes
) ELSE ( 
  goto :choose_itunes
)

:install_vlc
ECHO.
ECHO Installing VLC Player.
powershell -command "& cinst vlc -y">NUL
GOTO :choose_itunes

:choose_itunes
ECHO.
SET c=
SET /P c=Would you like to install Itunes? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_itunes
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_skype
) ELSE ( 
  goto :choose_skype
)

:install_itunes
ECHO.
ECHO Installing Itunes.
powershell -command "& cinst itunes -y">NUL
GOTO :choose_skype

:choose_skype
ECHO.
SET c=
SET /P c=Would you like to install Skype? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_skype
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_paintdotnet
) ELSE ( 
  goto :choose_paintdotnet 
)

:install_skype
ECHO.
ECHO Installing Skype.
powershell -command "& cinst skype -y">NUL
GOTO :choose_paintdotnet

:choose_paintdotnet
ECHO.
SET c=
SET /P c=Would you like to install Paint.Net?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_paintdotnet
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_gimp
) ELSE ( 
  goto :choose_gimp
)

:install_paintdotnet
ECHO.
ECHO Installing Paint.Net
powershell -command "& cinst paint.net -y">NUL
GOTO :choose_gimp

:choose_gimp
ECHO.
SET c=
SET /P c=Would you like to install Gimp?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_gimp
) ELSE IF /I "%c%" EQU "N" ( 
  goto :gaming_installations
) ELSE ( 
  goto :gaming_installations
)

:install_gimp
ECHO.
ECHO Installing Gimp.
powershell -command "& cinst gimp -y">NUL
GOTO :gaming_installations


:gaming_installations_skipmedia
ECHO.
SET c=
SET /P c=Skipping media installs. Would you like to install gaming software? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :gaming_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :extra_installations_skipgaming
) ELSE ( 
  goto :extra_installations_skipgaming
)

:gaming_installations
ECHO.
SET c=
SET /P c=Media installs complete. Would you like to install gaming software? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :gaming_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :extra_installations_skipgaming
) ELSE ( 
  goto :extra_installations_skipgaming 
)

:gaming_next
ECHO.
ECHO #=========================================
ECHO # GAMING INSTALLATIONS
ECHO # Software for gaming
ECHO #=========================================

ECHO.
SET c=
SET /P c=Would you like to install Steam?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_steam
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_battledotnet
) ELSE ( 
  goto :choose_battledotnet
)

:install_steam
ECHO.
ECHO Installing Steam. This may take a while.
powershell -command "& cinst steam -y">NUL
GOTO :choose_battledotnet

:choose_battledotnet
ECHO.
SET c=
SET /P c=Would you like to install Battle.Net?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_battledotnet
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_joy2key
) ELSE ( 
  goto :choose_joy2key 
)

:install_battledotnet
ECHO.
ECHO Installing Battle.Net. This may take a while.
powershell -command "& cinst battle.net -y">NUL
GOTO :choose_joy2key

:choose_joy2key
ECHO.
SET c=
SET /P c=Would you like to install JoyToKey?(y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_joy2key
) ELSE IF /I "%c%" EQU "N" ( 
  goto :extra_installations
) ELSE ( 
  goto :extra_installations 
)

:install_joy2key
ECHO.
ECHO Installing JoyToKey.
powershell -command "& cinst joytokey -y">NUL
GOTO extra_installations


:extra_installations_skipgaming
ECHO.
SET c=
SET /P c=Skipping Gaming installs. Would you like to install some extra software? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :extra_next
) ELSE IF /I "%c%" EQU "N" ( 
  goto :end_installer
) ELSE ( 
  goto :end_installer 
)

:extra_installations
ECHO.
SET c=
SET /P c=Gaming installs complete. Would you like to install some extra software? (y/N)
IF /I "%c%" EQU "Y" ( goto :extra_next
) ELSE IF /I "%c%" EQU "N" ( goto :end_installer
) ELSE ( goto :extra_next )
:extra_next
ECHO.
ECHO #=========================================
ECHO # EXTRA INSTALLATIONS
ECHO # Some software that I like.
ECHO #=========================================

:choose_displayfusion
ECHO.
SET c=
SET /P c=Would you like to install DisplayFusion for Multiple monitors? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_displayfusion
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_sharex
) ELSE ( 
  goto :choose_sharex 
)

:install_displayfusion
ECHO.
ECHO Installing DisplayFusion.
powershell -command "& cinst displayfusion -y">NUL
GOTO :choose_sharex

:choose_sharex
ECHO.
SET c=
SET /P c=Would you like to install ShareX screen capture utility? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_sharex
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_aquasnap
) ELSE ( 
  goto :choose_aquasnap 
)
:install_sharex
ECHO.
ECHO Installing ShareX.
powershell -command "& cinst sharex -y">NUL
GOTO :choose_aquasnap

:choose_aquasnap
ECHO.
SET c=
SET /P c=Would you like to install Aquasnap window manager? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_aquasnap
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_flux
) ELSE ( 
  goto :choose_flux 
)

:install_aquasnap
ECHO.
ECHO Installing Aquasnap.
powershell -command "& cinst aquasnap -y">NUL
GOTO :choose_flux

:choose_flux
ECHO.
SET c=
SET /P c=Would you like to install f.lux for eye strain? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_flux
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_classicshell
) ELSE ( 
  goto :choose_classicshell 
)

:install_flux
ECHO.
ECHO Installing f.lux.
powershell -command "& cinst f.lux -y">NUL
GOTO :choose_classicshell

:choose_classicshell
ECHO.
SET c=
SET /P c=Would you like to install Classic Shell Start Button Replacement? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_classicshell
) ELSE IF /I "%c%" EQU "N" ( 
  goto :choose_torbrowser
) ELSE ( 
  goto :choose_torbrowser 
)

:install_classicshell
ECHO.
ECHO Installing Classic Shell.
powershell -command "& cinst classic-shell -y">NUL
GOTO :choose_torbrowser

:choose_torbrowser
ECHO.
SET c=
SET /P c=Would you like to install Tor Browser for safe VPN web browsing? (y/N)
IF /I "%c%" EQU "Y" ( 
  goto :install_torbrowser
) ELSE IF /I "%c%" EQU "N" ( 
  goto :end_installer
) ELSE ( 
  goto :end_installer 
)

:install_torbrowser
ECHO.
ECHO Installing Tor Browser.
powershell -command "& cinst tor-browser -y">NUL
GOTO :end_installer


:end_installer
ECHO #===========================================================================================
ECHO # Thanks for using this package installer. For more packages please check out chocolate.org.
ECHO # If you missed any packages whilst running this script or would like to check for updates
ECHO # for any of the packages please run this script again.
ECHO # ~Bill 'Proxima' Chandler
ECHO #===========================================================================================
TIMEOUT 10

# Fresh install

Some stuff manually, and then use Chocolatey.

## Manual
- WSL2
- Docker Desktop
- Visual Studio with .NET stuff
- Windows terminal

### Dotnet
Runtime and SDK can be downloaded through Visual studio, no nice way to do it through package manager at the moment.
`winget` was acting up on me, and `choco` don't seem stable for it.
https://dotnet.microsoft.com/en-us/download/dotnet

Install VS externally as well, worked through chocolatey but easier to stick with the standard installation and install .NET stuff at the same time.

## CLI install

### Chocolatey
`choco export` to export packages, note that this includes all packages, not only the ones you've specifically installed.

Here is a clean setup for a work machine:
```
<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="azure-cli" />
  <package id="bitwarden" />
  <package id="curl" />
  <package id="devtoys" />
  <package id="Firefox" />
  <package id="git" />
  <package id="GoogleChrome" />
  <package id="licecap" />
  <package id="kubernetes-cli" />
  <package id="notepadplusplus" />
  <package id="ngrok" />
  <package id="nvm" />
  <package id="postman" />
  <package id="powertoys" />
  <package id="spotify" />
  <package id="vim" />
  <package id="vscode" />
  <package id="winmerge" />
  <package id="zoomit" />
</packages>
```

Here are some more packages, for a home setup:
```
  <package id="brave" />
  <package id="adobedigitaleditions" />
  <package id="calibre" />
  <package id="mullvad-app" />
```

`choco install packages.config` to install packages

### nvm
- `nvm i lts`
- `nvm use lts`

## Setup tools

### Terminal
Use Git Bash with Windows terminal
```
{
      "colorScheme": "Campbell",
      "commandline": "%PROGRAMFILES%/Git/bin/bash.exe -i -l",
      "cursorColor": "#FFFFFF",
      "cursorShape": "bar",
      "font":
      {
         "face": "Cascadia Code",
         "size": 10.0
      },
      "guid": "{4da17522-289c-4cc2-8147-fcd7fcb68ba6}",
      "historySize": 9001,
      "icon": "%PROGRAMFILES%/Git/mingw64/share/git/git-for-windows.ico",
      "name": "Git Bash",
      "opacity": 75,
      "padding": "15",
      "snapOnInput": true,
      "startingDirectory": "C:/repos",
      "useAcrylic": true
},
```

Add `set bell-style none` in `~/.inputrc` if the terminal flickers.
https://github.com/microsoft/terminal/issues/7200#issuecomment-672786518

#### Linux terminal

Run script in [./setup_linux_shell.sh](./setup_linux_shell.sh).

### Npp
Setup Cloud storage to point to OneDrive synced files.
https://superuser.com/a/1278765/986363

## Path
Nothing it seems.

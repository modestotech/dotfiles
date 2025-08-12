# Fresh install

Some stuff manually, and then use Chocolatey.

## Manual
- WSL2
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

See xml files in [./choco](./choco) directory. Invoke `choco install packages.config` to install packages

#### Linux terminal

Activate WSL and once updated, install these, check recommended way:
1. Install zsh
2. Install dotnet-sdk
3. Install nvm and then `nvm install lts`
4. Install docker engine
   - For saving memory, disable docker services with `sudo systemctl disable docker docker.socket`
   - Now to start and stop, use `sudo systemctl start docker docker.socket` and `sudo systemctl stop docker docker.socket`
   - To check status, run `sudo systemctl status docker` or `docker info`

Add gitconfig file from this repo.

### Npp
Setup Cloud storage to point to OneDrive synced files.
https://superuser.com/a/1278765/986363

## Path
Nothing it seems.

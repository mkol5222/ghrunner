#!/bin/bash

curl -OL https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell_7.4.1-1.deb_amd64.deb
sudo dpkg -i powershell_7.4.1-1.deb_amd64.deb
find / -name pwsh
find / -name powershell
rm powershell_7.4.1-1.deb_amd64.deb

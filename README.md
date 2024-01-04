# CapstoneCLI

## Description
This bash-based CLI tool allows users to upload files to a blob storage in Azure. The tool helps users upload multiple items to a specified Azure Blob Storage container.

## Prerequisites
* An active Azure subscription 
* Bash environment 

## Installation
1. Clone the repository
```
git clone https://github.com/kylefon/CapstoneCLI.git
```
2. Change to the Project Directory
```
cd CaptstoneCLU
```
3. Run install.sh
```
chmod +x install.sh 
./install.sh
```
4. Login to Azure by running login.sh
```
chmod +x login.sh
./login.sh
```
5. Input Account Name and Container Name in config.sh

## Usage
Follow the syntax below to upload a file to Azure:
```
./clouduploader.sh /path/to/file 
```

Follow the syntax to upload multiple files to Azure:
```
./clouduploader.sh /path/to/file1 /path/to/file2 ...
```

Generate a shareable link by responding 'Y' after uploading. 
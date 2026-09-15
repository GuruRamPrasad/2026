# Windows Web Server (IIS) Installation Using BAT File

This project contains a simple **BAT script** to install and configure **IIS (Internet Information Services)** on Windows Server.

## Prerequisites

* Windows Server
* Administrator privileges
* Internet connectivity is recommended
* Access to Command Prompt
* IIS should not already be installed

## Installation Steps

### 1. Create the BAT File

Create a file named:

```text
install_iis.bat
```

You can create it using **Notepad**.

Add the following script:

```bat
@echo off

echo ========================================
echo Installing Windows Web Server - IIS
echo ========================================

echo.
echo Installing IIS...

dism /online /enable-feature /featurename:IIS-WebServerRole /all

echo.
echo Starting IIS service...

net start W3SVC

echo.
echo Setting IIS service to Automatic...

sc config W3SVC start= auto

echo.
echo ========================================
echo IIS Installation Completed
echo ========================================

echo.
echo Checking IIS service status...

sc query W3SVC

echo.
echo Open http://localhost in your browser.

pause
```

### 2. Run the BAT File

Right-click:

```text
install_iis.bat
```

Select:

```text
Run as administrator
```

The script will:

* Install IIS
* Start the IIS service
* Configure the IIS service to start automatically
* Display the IIS service status

## Verify IIS Installation

Open a web browser on the Windows Server and enter:

```text
http://localhost
```

If IIS is installed successfully, you should see the **IIS Welcome Page**.

## Check IIS Service

Open Command Prompt as Administrator and run:

```cmd
sc query W3SVC
```

Expected status:

```text
STATE              : 4  RUNNING
```

## IIS Default Web Root

The default IIS website files are stored in:

```text
C:\inetpub\wwwroot
```

You can place your website files in this directory.

For example:

```text
C:\inetpub\wwwroot\index.html
```

## Test Website

Create an `index.html` file inside:

```text
C:\inetpub\wwwroot
```

Example:

```html
<!DOCTYPE html>
<html>
<head>
    <title>My IIS Server</title>
</head>
<body>
    <h1>Hello from Windows IIS Web Server</h1>
</body>
</html>
```

Then open:

```text
http://localhost
```

## Useful Commands

### Check IIS Service

```cmd
sc query W3SVC
```

### Start IIS Service

```cmd
net start W3SVC
```

### Stop IIS Service

```cmd
net stop W3SVC
```

### Restart IIS

```cmd
iisreset
```

### Check IIS Version

```cmd
dism /online /get-features | findstr IIS
```

## Project Structure

```text
windows-iis/
│
├── install_iis.bat
└── README.md
```

## Notes

* The BAT file must be run with **Administrator privileges**.
* IIS uses the **W3SVC (World Wide Web Publishing Service)** service.
* The default website directory is `C:\inetpub\wwwroot`.
* By default, IIS listens on **HTTP port 80**.
* Windows Firewall may need to allow inbound HTTP traffic if the website must be accessed from other machines.

## Conclusion

This script provides a simple way to install and configure **IIS Web Server** on Windows Server using a BAT file.

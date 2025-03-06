param (
    [Alias("S","Source")]
    [Parameter(
        Mandatory,
        Position = 0
    )]
    [string]$FileSourcePath = "c:\test",
    [Alias("D","Destination")]
    [Parameter(
        Mandatory,
        Position = 1
    )]
    [string]$FileDestinationPath = "D:\",
    [string]$force = $true
)

function CheckPath {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory = $true)]
            [string] $Source
    )
    
    if (-not (Test-Path $Source)) {
    Write-Host ("Error: The provided file path does not exist. {0}" -f $Source)
    exit
    }
}

CheckPath -Source $FilePathSource
CheckPath -Source $FilePathDestination

# Obtener todas las carpetas en el directorio
$folders = Get-ChildItem -Path $source -Directory

# Crear la ruta de destino
$DestinationPath = [String]::join("\",$destination,"CA200\Archive")
New-Item -Path $DestinationPath -Force -ItemType Directory

foreach ($folder in $folders) {
    #$zipFilePath = Join-Path -Path $directory -ChildPath "$($folder.Name).zip"
    $ZipFileName = "$($folder.Name).zip"
    $zipFilePath = [String]::Join("\",$destinationPath, $ZipFileName)
    $folderPath = $folder.FullName

    #Crear el archivo zip
    #Compress-Archive -Path "$folderPath\*" -Force -DestinationPath $zipFilePath

    $parameter = @{
        Path = $folderPath
        CompressionLevel = "Fastest"
        Force = [Bool]::Parse($force)
        DestinationPath = $zipFilePath
    }
    Compress-Archive @parameter
}

#mkdir c:\\wix311
#Expand-Archive -Path c:\wix311-binaries.zip -DestinationPath c:\\wix311\\bin
#$env:WIX = "C:\\wix311\\"
#$env:PYTHONIOENCODING = "UTF-8"
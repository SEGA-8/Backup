param (
    [Alias("S","Source")]
    [Parameter(
        #Mandatory,
        Position = 0
    )]
    [string]$FileSourcePath = "C:\test",
    [Alias("D","Destination")]
    [Parameter(
        #Mandatory,
        Position = 1
    )]
    [string]$FileDestinationPath = "D:\test",
    [string]$Update = $false,
    [switch]$help
)

# Mostrar ayuda si se pasa el parámetro -h o -help
if ($help) {
    Write-Output "Ayuda del script:"
    Write-Output "-h, -help      Muestra esta ayuda"
    Write-Output "-param1        Descripción del parámetro 1"
    Write-Output "-param2        Descripción del parámetro 2"
    # Agrega más descripciones según sea necesario
    exit
}

function CheckPath {
    #[CmdletBinding()]
    param (
            [Parameter(Mandatory = $true)]
            [string]$Source,
            [Bool]$Create =$true
    )
    
    if (-not (Test-Path $Source)) {
        Write-Host ("Error: The provided file path does not exist. {0}" -f $Source)
        
        if ($Create) {
            do {
            # Solicitar confirmación del usuario
            $confirmation = Read-Host -Prompt 'Do you want to create it? (yes/no)'

            # Validar la respuesta del usuario
            if ($confirmation -eq 'yes' -or $confirmation -eq 'y') {
                #Write-Output "Has confirmado que deseas continuar."
                $continue = $true
            }
            elseif ($confirmation -eq 'no' -or $confirmation -eq 'n') {
                #Write-Output "Has decidido no continuar."
                $continue = $false
            }
            else {
                Write-Output "Wrong answer, please try 'yes/y' or 'no/n'."
                $continue = $null
            }
            } while ($continue -eq $null)

            # Si $continue es $true, continua con el resto del script
            if ($continue) {
                mkdir $Source
                continue
            }

        }
        exit
    }
}

ShowHelp $Help 
CheckPath -Source $FileSourcePath -Create $false
CheckPath -Source $FileDestinationPath

# Obtener todas las carpetas en el directorio
$folders = Get-ChildItem -Path $FileSourcePath -Directory

# Crear la ruta de destino
#$DestinationPath = [String]::join("\",$FileDestinationPath,"CA200\Archive")
New-Item -Path $FileDestinationPath -Force -ItemType Directory

foreach ($folder in $folders) {
    #$zipFilePath = Join-Path -Path $directory -ChildPath "$($folder.Name).zip"
    $ZipFileName = "$($folder.Name).zip"
    $zipFilePath = [String]::Join("\",$FileDestinationPath, $ZipFileName)
    $folderPath = $folder.FullName

    #Crear el archivo zip
    #Compress-Archive -Path "$folderPath\*" -Force -DestinationPath $zipFilePath

    $parameter = @{
        Path = $folderPath
        CompressionLevel = "Fastest"
        Update = [Bool]::Parse($Update)
        DestinationPath = $zipFilePath
    }
    Compress-Archive @parameter
}

#mkdir c:\\wix311
#Expand-Archive -Path c:\wix311-binaries.zip -DestinationPath c:\\wix311\\bin
#$env:WIX = "C:\\wix311\\"
#$env:PYTHONIOENCODING = "UTF-8"
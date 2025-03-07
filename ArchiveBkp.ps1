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
    [switch]$Update,
    [switch]$Force,
    [switch]$help
)

# Mostrar ayuda si se pasa el parámetro -h o -help
if ($help) {
    Write-Host "ArchiveBkp source [destination] [/U | /F]"
    Write-Host "Ayuda de ArchiveBkp"
    Write-Host "-h, -help      Muestra esta ayuda"
    Write-Host "-source        Especifica los archivos por copiar."
    Write-Host "-destination   Especifica la ubicacion de los nuevos archivos. Si se omite crea una por defecto."
    Write-Host "-u             Actualiza creando nuevos ficheros. No sobreescribe los existentes"
    Write-Host "-f             Fuerza la creacion de nuevos ficheros. Sobreescribe los existentes"

    # Agrega más descripciones según sea necesario
    exit
}

if($Update -and $Force){
    Write-Host "No es posible usar los parametros Update y Force juntos, debe elejir solo uno."
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

    if ($Update){
        $parameter = @{
        Path = $folderPath
        DestinationPath = $zipFilePath
        CompressionLevel = "Fastest"
        Update = $Update
        }
    }else{
        $parameter = @{
        Path = $folderPath
        DestinationPath = $zipFilePath
        CompressionLevel = "Fastest"
        Force = $Force
        }
    }
    Compress-Archive @parameter
}

#mkdir c:\\wix311
#Expand-Archive -Path c:\wix311-binaries.zip -DestinationPath c:\\wix311\\bin
#$env:WIX = "C:\\wix311\\"
#$env:PYTHONIOENCODING = "UTF-8"
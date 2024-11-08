param (
    [string]$baseFolder
)

function Run-CommandInSubfolders {
    param (
        [string]$folder
    )

    $commandTemplate = "fsutil.exe file setCaseSensitiveInfo {0} enable"
    $skipFolders = @(".git", ".nuget", ".vscore", "bin", "obj")  # Define the folders to skip here

    Get-ChildItem -Path $folder -Directory -Recurse | ForEach-Object {
        $subfolderPath = $_.FullName

        # Check if any part of the path contains a folder to skip
        if ($skipFolders | ForEach-Object { $subfolderPath -like "*\$_\*" }) {
            Write-Host "Skipping folder $subfolderPath"
            return
        }

        $command = $commandTemplate -f $subfolderPath
        Write-Host "Running command in $subfolderPath"
        try {
            Invoke-Expression $command
        } catch {
            Write-Host "Error running command in ${subfolderPath}: $_"
        }
    }
}

Run-CommandInSubfolders -folder $baseFolder
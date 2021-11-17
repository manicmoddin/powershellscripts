###############################################################################
## Org Chart Getter                                                          ##
##                                                                           ##
## Populates the Org Chart csv so that it can be updated, and re-imported    ##
##                                                                           ##
## Author : Jimmy Kemp                                      Date: 17/11/2021 ##
##                                                             Version : 0.1 ##
##                                                                           ##
###############################################################################

## Path to output CSV
$outputcsv = "C:/pshell/Resource/orgchart.csv"



#First off, remove the CSV so that it avoids all sorts of clobber

if (Test-Path -Path $outputcsv) {
    Write-Host -ForegroundColor Yellow "Found the CSV, Removing to avoid clobber"
    Remove-Item -Path $outputcsv
}

# Load ADusers into a variable - If wanting to do particular OUs lookinto the searchbase attribute / argument
$users = Get-ADUser -filter * -Properties manager

#Iterate though the users, to put the manager details in a friendly way
foreach ($user in $users) {
    Write-Host "Getting Manager Details for "$user.name
    $managerName = $null
    $manager = $user.manager


    if ($null -ne $manager) {
        $managerName = Get-ADUser $manager #| Select-Object -Property name
        $managerName
    }
    else {
        write-host "There is no manager details for "$user.name
        
    }

    # Object to hold the output
    $outputObj = [PSCustomObject]@{
        user = $user.Name
        manager = $managerName.name
    }

    # And actually Output...
    $outputObj | Export-Csv -Path $outputcsv -NoTypeInformation -Append

}



###############################################################################
## Org Chart Updater                                                         ##
##                                                                           ##
## Populates the manager field in AD based on the manager field of the       ##
## org-chart csv                                                             ##
##                                                                           ##
## Author : Jimmy Kemp                                      Date: 17/11/2021 ##
##                                                             Version : 0.1 ##
##                                                                           ##
###############################################################################

## Import CSV
$csv = Import-Csv -path "C:/pshell/Resource/orgchart.csv"

foreach ($line in $csv) {
    $aduser = $line.user
    $manager = $line.manager
    
    write-host "Working on $aduser"

    #Check to see if the manager field is populated, if so process the row
    if ($manager -ne '') {
        $managerDN = Get-ADUser -filter { name -eq $manager } | Select-Object -Property DistinguishedName
        
        # Now that we have the DistinguishedName of the manager, set the ADuser to be managed by them
        # first to make life esy, get their SAMAccountName
        $samAccountName = get-aduser -filter {name -eq $aduser}
        set-aduser $samAccountName -Manager $managerDN
    }
}
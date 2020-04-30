#David L. 04/27/2020, V0.0.1


#Other possible systems: Conference rooms
#Array of computers to process (EOC systems for now)
$Computers = @('P401018','P401019','P401020','P401021','P401022','P401023','P401024','P401025','P401026','P401027','P401028','P401029','P401153','P401666')

foreach($computer in $Computers){

#Disk Related Data

    #retrieve disk size
    $diskSize = get-WmiObject win32_logicaldisk -Computername $computer -Filter "DeviceID='C:'" |
    Foreach-object{$_.Size}

    #Convert to GB and round to 2 decimal places
    $diskSize = [math]::round($diskSize/1GB,2)

    #retrieve disk free space
    $diskFreeSpace = get-WmiObject win32_logicaldisk -Computername $computer -Filter "DeviceID='C:'" |
    Foreach-object{$_.FreeSpace}

    #Convert to GB and round to 2 decimal places
    $diskFreeSpace = [math]::round($diskFreeSpace/1GB,2)

    #Calculate free disk space as a percentage of disk size
    $freeSpacePercentage = ($diskFreeSpace/$diskSize)
    if($freeSpacePercentage -lt .30){
        $warningTextColor = "yellow"
    }
    elseif($freeSpacePercentage -lt .15){
        $warningTextColor = "red"
    }
    else{
        $warningTextColor = "white"
    }
    $freeSpacePercentage = ($diskFreeSpace/$diskSize).toString("P")

#Profile Related Data (in Progress) Remove user profiles 90 days or older


    #
    $userProfiles = Get-WmiObject -ClassName Win32_UserProfile -ComputerName $computer | Sort-Object LastUseTime


#Other disk cleanup areas
#C:\TEMP, CCMCACHE

#Write output
    Write-Host -ForegroundColor magenta "Asset: $computer" 
    Write-Host "Disk Capacity: $diskSize GB".
    Write-Host "Free Space: $diskFreeSpace GB"
    #if($
    Write-Host "Percentage Free Space: $freeSpacePercentage" -ForegroundColor $warningTextColor
    Write-Host 
    #Write-Host "Asset: $computer" "User Profiles: $userProfiles"

}

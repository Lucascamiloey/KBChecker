# Computer list
#usage: "computer1", "computer2.domain", "computer4"
$computers="FILLTHISVALUES"

# Working Paths
$location="c:\temp\checkKB3080079"
$BATlocation="$location\checkKB3080079.bat"
$ResultFile=$location\Result.log

# Clean up folder
remove-item -Path $location\* -Exclude *.bat

foreach ($computer in $computers){
	#Set Remote Path
	$remotepath="\\$computer\c$\temp"
	#Copy bat file
	copy-item $BATlocation $remotepath\temp.bat -force
	if ($?){
		#Execute the bat on the remote machine
		psexec "\\$computer" c:\temp\temp.bat
		#Copy the logs and clean everything from the remote machine
		copy-item $remotepath\temp.log $location\$computer.log
		remove-item -Path $remotepath\temp.log
		remove-item -Path $remotepath\temp.bat
		
		#Check if the patch was installed
		$helper=get-content $location\$computer.log 
		if (!$helper){
			Write-Output "$computer;NOT INSTALLED" >> $ResultFile
		}else{	
			Write-Output "$computer;INSTALLED" >> $ResultFile
		}
		
	}else{
		#If the copy fails
		Write-Output "$computer;ERROR" >> $ResultFile
	}
}


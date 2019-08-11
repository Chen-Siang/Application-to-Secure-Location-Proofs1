cd D:\Ladybug\wait_process
#$waitstreamPath = ls *000000.pgr
#Resolve-Path *\*\*000000.pgr
[array]$ftmpary = @()
[int]$ftmpCount=0
[int]$frunCount=0
[array]$ntmpary = @()
[int]$ntmpCount=0


#pano Rectified0~5 Spherical
$ImgType = "10000000"
#$ImgType = "10000000"
$outDiskPath = "D:"

echo "start process & find 000000.pgr"
$a = Get-Date
"Date: " + $a.ToShortDateString()
"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
do{
	foreach($item in ls){
	#$host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")
		if($item.Mode -eq "d----"){
			$ftmpary+=Resolve-Path $item
			$ftmpCount++
		}
		elseif($item.Mode -eq "-a---"){
			if($item.name -match "000000.pgr"){
				$ntmpary+=Resolve-Path $item
				$ntmpCount++
			}
		}
	}
	if($frunCount -lt $ftmpCount){#<
		cd $ftmpary[$frunCount]
	}
	$frunCount++
	
}until($ftmpCount+1 -eq $frunCount)
echo "\n"$ntmpary
echo "\f"$ntmpCount
$processcount=1

echo "end find 000000.pgr"
$a = Get-Date
"Date: " + $a.ToShortDateString()
"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
$p1 = "null"
$p2 = "null"
$p3 = "null"
foreach($item in $ntmpary){
	$p = "D:\auto_pgmStreamToimg.ps1 "+$ImgType+" "+$item+" "+$outDiskPath
	
	echo "start p"$processcount" "$p
	$a = Get-Date
	"Date: " + $a.ToShortDateString()
	"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
	
	if($processcount % 3 -eq 1){
		$p1 = start-process powershell -argument $p -Passthru
	}
	elseif($processcount % 3 -eq 2){
		$p2 = start-process powershell -argument $p -Passthru
	}
	elseif($processcount % 3 -eq 0){
		$p3 = start-process powershell -argument $p -Passthru
	}
	$t1=0
	$t2=0
	$t3=0
	if(($processcount % 3 -eq 0) -or $ntmpary.length -le 2){
		do {
			start-sleep -seconds 10
			Try{
				if($p1.HasExited -and $t1 -eq 0 -or $p1 -eq "null"){
					echo "end p1 "
					$a = Get-Date
					"Date: " + $a.ToShortDateString()
					"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
					$t1=1
				}
				
				if($p2.HasExited -and $t2 -eq 0 -or $p2 -eq "null"){
					echo "end p2 "
					$a = Get-Date
					"Date: " + $a.ToShortDateString()
					"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
					$t2=1
				}
				if($p3.HasExited -and $t3 -eq 0 -or $p3 -eq "null"){
					echo "end p3 "
					$a = Get-Date
					"Date: " + $a.ToShortDateString()
					"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second
					$t3=1
				}
			}Catch
			{
				echo "error"
			}
		}until(($t1 -eq 1) -and ($t2 -eq 1) -and ($t3 -eq 1))
	}
	$processcount++
}
echo "end process"
$a = Get-Date
"Date: " + $a.ToShortDateString()
"Time: " + $a.Hour+":"+$a.Minute+":"+$a.Second


cd D:\Ladybug\
echo "[ - Move D:\Ladybug\wait_process\* To D:\Ladybug\stream\ - ]"
move-item D:\Ladybug\wait_process\* D:\Ladybug\stream\

echo "[ - END Process - ]"
cmd /c pause | out-null
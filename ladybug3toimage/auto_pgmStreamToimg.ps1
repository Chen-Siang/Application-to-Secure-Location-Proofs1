function CheckFolderExist($path)
{	
	if ((Test-Path $path) -eq $false)
    {			
		mkdir $path		
    }
}
function ConvertImage($path)
{
	$p = "D:\convertImage.ps1 "+"$path"
	#start-process powershell -argument "D:\convertImage.ps1 aaa"
	start-process powershell -argument $p
}
function slp($second)
{
	start-sleep -seconds $second  #-Milliseconds or seconds
}
$ladybugProcessStream = "D:\PGR"+" "+"Ladybug\bin64\ladybugProcessStream.exe"

#echo $args.count
$ImgType = "01111110"
[string]$ImgType = [string]$args[0]
$item = $args[1]
$outDiskPath = $args[2]
echo $ImgType
echo $item
echo $outDiskPath
#$outDiskPath = "D:"


#$fp = D:\Ladybug\wait_process\2018-01-01\1
#$fp[0] D:
#$fp[1] Ladybug
#$fp[2] wait_process
#$fp[3] 103_11_25
#$fp[4] 1
if($outDiskPath -eq ""){
	$outDiskPath = $fp[0]
}
$fp = $item.tostring().split('\')
$PanoramicOutPath = $outDiskPath+"\"+$fp[1]+"\streamtoimg\"+$fp[3]+"\Panoramic\"+$fp[4]+"\"
$SphericalOutPath = $outDiskPath+"\"+$fp[1]+"\streamtoimg\"+$fp[3]+"\Spherical\"+$fp[4]+"\"
#$GpsOutPath = $outDiskPath+"\"+$fp[1]+"\streamtoimg\"+$fp[3]+"\gps\"+$fp[-1].replace('.pgr','')
$GpsOutPath = $outDiskPath+"\"+$fp[1]+"\streamtoimg\"+$fp[3]+"\gps\"+$fp[4]
$RectifiedOutPath = $outDiskPath+"\"+$fp[1]+"\streamtoimg\"+$fp[3]+"\Rectified\"+$fp[4]+"\"

echo "PanoramicOutPath"$PanoramicOutPath
echo "GpsOutPath"$GpsOutPath
echo "RectifiedOutPath"$RectifiedOutPath
#-x 0.0-22.5-90
#2048x1024
#5400x2700
#8000x4000
$PanoProcess = " -i "+$item.tostring()+" -o "+$PanoramicOutPath+$fp[3]+"_"+" -g "+$GpsOutPath+"\"+$fp[3]+" -t pano -w 8000x4000 -f exif -c hq-gpu -v 1.0 -a true"
$SphericalProcess = " -i "+$item.tostring()+" -o "+$SphericalOutPath+$fp[3]+"_"+" -g "+$GpsOutPath+"\"+$fp[3]+"_Spherical"+" -t spherical -x 0.0-22.5-90 -w 2048x1024 -f exif -c hq-gpu -v 1.0 -a true"

$Rectif0Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam0\"+$fp[3]+"_"+" -t rectify-0 -w 1616x1232 -f bmp -c hq-gpu -a true"
$Rectif1Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam1\"+$fp[3]+"_"+" -t rectify-1 -w 1616x1232 -f bmp -c hq-gpu -a true"
$Rectif2Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam2\"+$fp[3]+"_"+" -t rectify-2 -w 1616x1232 -f bmp -c hq-gpu -a true"
$Rectif3Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam3\"+$fp[3]+"_"+" -t rectify-3 -w 1616x1232 -f bmp -c hq-gpu -a true"
$Rectif4Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam4\"+$fp[3]+"_"+" -t rectify-4 -w 1616x1232 -f bmp -c hq-gpu -a true"
$Rectif5Process = " -i "+$item.tostring()+" -o "+$RectifiedOutPath+"Cam5\"+$fp[3]+"_"+" -t rectify-5 -w 1616x1232 -f bmp -c hq-gpu -a true"
echo "create folder"
echo "stream to img process"

if($ImgType[0] -eq "1"){
	$path = CheckFolderExist $PanoramicOutPath
	$path = CheckFolderExist $GpsOutPath
	$proPano = start $ladybugProcessStream $PanoProcess -Passthru
	#slp(10)
}
if($ImgType[1] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam0\"
	$proRef0 = start $ladybugProcessStream $Rectif0Process -Passthru
	#slp(10)
}
if($ImgType[2] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam1\"
	$proRef1 = start $ladybugProcessStream $Rectif1Process -Passthru
	#slp(10)
}
if($ImgType[3] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam2\"
	$proRef2 = start $ladybugProcessStream $Rectif2Process -Passthru
	#slp(10)
}
if($ImgType[4] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam3\"
	$proRef3 = start $ladybugProcessStream $Rectif3Process -Passthru
	#slp(10)
}
if($ImgType[5] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam4\"
	$proRef4 = start $ladybugProcessStream $Rectif4Process -Passthru
	#slp(10)
}
if($ImgType[6] -eq "1"){
	$path = CheckFolderExist $RectifiedOutPath"Cam5\"
	$proRef5 = start $ladybugProcessStream $Rectif5Process -Passthru
	#slp(10)
}
if($ImgType[7] -eq "1"){
	$path = CheckFolderExist $SphericalOutPath
	$proSpherical = start $ladybugProcessStream $SphericalProcess -Passthru
	#slp(10)
}
$ImgCheckType = $ImgType.ToCharArray()
do {
	slp(10)  #-Milliseconds or seconds
	$ProOK = "false"
	if($ImgCheckType[0] -eq "1"){
		if($proPano.HasExited){
			$ImgCheckType[0] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[1] -eq "1"){
		if($proRef0.HasExited){
			$ImgCheckType[1] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[2] -eq "1"){
		if($proRef1.HasExited){
			$ImgCheckType[2] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[3] -eq "1"){
		if($proRef2.HasExited){
			$ImgCheckType[3] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[4] -eq "1"){
		if($proRef3.HasExited){
			$ImgCheckType[4] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[5] -eq "1"){
		if($proRef4.HasExited){
			$ImgCheckType[5] = 0
			$ProOK = "true"}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[6] -eq "1"){
		if($proRef5.HasExited){
			$ImgCheckType[6] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
	if($ImgCheckType[7] -eq "1"){
		if($proSpherical.HasExited){
			$ImgCheckType[7] = 0
			$ProOK = "true"
		}
		else{
			$ProOK = "false"
			continue
		}
	}
}until ($ProOK -eq "true")
	
echo "convert image"
for($i=1;$i -lt 7;$i++){
	if($ImgType[$i] -eq "1"){
		[string]$CamNum=[string]$i-1
		$convertImg = ConvertImage $RectifiedOutPath"Cam"$CamNum"\"
	}
}
cd "D:\"

#cmd /c pause | out-null

$path = $args[0]
echo $path
cd $path
$imgfile = ls *.bmp
foreach($item in $imgfile){
	convert $item -rotate 90 $item
	echo $item.name
}


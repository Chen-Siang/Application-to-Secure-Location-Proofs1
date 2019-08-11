<?php

//接收上傳影像 
 $target= "./img/";

 $target_path = $target . basename( $_FILES['uploadedfile']['name']);

 if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)){

   $dbtimedate=date("Y:m:d:H:i:s");
   $img = $target_path;
   $exif = exif_read_data($img ,0, true); 
   $Name=$exif['FILE']['FileName'];
   $useid = $exif['IFD0']['Make'];

   $latitude = $exif['GPS']['GPSLatitude'];  
   $longitude = $exif['GPS']['GPSLongitude']; 
   $Slatitude =explode("/",$latitude[2]);
   $latitude =round($latitude[0]+$latitude[1]/60+$Slatitude[0]/$Slatitude[1]/3600,4);
   $Slongitude =explode("/",$longitude[2]);
   $longitude =round($longitude[0]+$longitude[1]/60+$Slongitude[0]/$Slongitude[1]/3600,4);
  
   $json_string = file_get_contents($useid.".json");
   $data = json_decode($json_string,true);  
   $item_num=count($data["item"]);
   $NameID=explode(".",$Name);
   $data["item"][$item_num]["ID"]=$NameID[0];
   //$data["item"][$item_num]["USE"]=$useid;
   $data["item"][$item_num]["GPS"]=$latitude." ".$longitude;

   $gpsDate = $exif['GPS']['GPSDateStamp']; 
   $gpsTime = $exif['GPS']['GPSTimeStamp']; 

   $gpshour=round($gpsTime[0]);
   $gpsMinute=round($gpsTime[1]);
   $gpssecond=round($gpsTime[2]);
   if($gpshour<10)$gpshour="0".$gpshour;
   if($gpsMinute<10)$gpsMinute="0".$gpsMinute;
   if($gpssecond<10)$gpssecond="0".$gpssecond;

   $DateTime=$gpsDate." ".$gpshour.":".$gpsMinute.":".$gpssecond;
   $data["item"][$item_num]["TIME"]=$DateTime;

   $STREEIMG = "無";
   $state = "辨識中"; 
   $failresult = "無"; 

    //人臉辨識
   $command="./test_face_verification.bin"." ./known/".$useid.".JPG"." ./img/".$Name;
   $result=shell_exec($command);
   //$command2="./facedet_test"." ./img/".$Name." ./showimg/".$Name;
   //$result2=shell_exec($command2);
   if ($result>0.65)
   {
      //時間辨識
      $timedate=date("Y:m:d H:i:s");
      
      if((strtotime($timedate)-strtotime($DateTime))<300){
         $command3="./bundler_sfm-master_V4/RunBundler_query.sh ";
	 $result3=shell_exec($command3);
	 $command4="VocabularyTree/VocabMatch/VocabMatch gopro_data/db.4.10.200.matches.out gopro_data/list_keys.txt img/list_keys.txt 3 matches.txt";
	 $result4=shell_exec($command4);

	  $file_path = "matches.txt";
	  if(file_exists($file_path)){
	      $str = file_get_contents($file_path);
	      $str = str_replace("\r\n","<br />",$str);
	      $cut_str =explode(" ",$str);    
      	  }
          $state="成功";
          $STREEIMG = "http://163.22.21.149/streetimage/".($cut_str[1]+1).".jpg";
          $command5="rm -rf ./img/*";
	  $result5=shell_exec($command3);
      }
      else{
          $state="失敗"; 
	  $failresult="時間辨識";
      }
   }
   else{
       $state="失敗";
       $failresult="人臉辨識";
   }
   deldir("./img/");
   $data["database_time"]=$dbtimedate;

   $data["item"][$item_num]["STREEIMG"]=$STREEIMG;
   $data["item"][$item_num]["STATE"]=$state;
   $data["item"][$item_num]["RESULT"]=$failresult;
   $json_strings =str_replace("\/","/", json_encode($data,JSON_UNESCAPED_UNICODE));
   file_put_contents($useid.".json",$json_strings);
   echo "success";
 }
 else{
   echo "fail:".$_FILES['uploadedfile']['error'] ;
 }

function deldir($path){
  if(is_dir($path)){
    $p = scandir($path);
    foreach($p as $val){
      if($val !="." && $val !=".."){
        if(is_dir($path.$val)){
          deldir($path.$val.'/');
          @rmdir($path.$val.'/');
        }else{
          unlink($path.$val);
        }
      }
    }
  }
}
?>

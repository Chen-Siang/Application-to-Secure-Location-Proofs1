clear,clc;

images = imageDatastore('D:\NCNU\Viplad\report\matlab\SIFT match\0','FileExtensions','.jpg');
img1 = imread('11.jpg');
[des1, loc1] = sift(img1);

num = zeros(1,size(images.Files,1));
numkey = zeros(1,size(images.Files,1));
out= zeros(size(images.Files,1),3);
for j=1:size(images.Files)
    img2 = readimage(images,j);
    [des2, loc2] = sift(img2);
    numkey(j)=size(des2,1);
    distRatio = 0.6;   
    des2t = des2'; 
    matchTable = zeros(1,size(des1,1));
    tic
    for i = 1 : size(des1,1)
       dotprods = des1(i,:) * des2t;  
       [vals,indx] = sort(acos(dotprods)); 
       if (vals(1) < distRatio * vals(2))
          matchTable(i) = indx(1);
       else
          matchTable(i) = 0;
       end
    end
    num(j)= sum(matchTable > 0);
    toc
    fprintf('Found %d matches.\n', num(j));
end
[b,i]=sort(num,'descend');
%%
for j=1:size(images.Files)
    out(j,1)=b(j);
    out(j,2)=numkey(i(j));
    out(j,3)=i(j);
end


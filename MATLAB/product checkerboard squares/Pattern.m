%%
%Clear all;
clc,clear;

%%
width=1024;      %棋盤圖的寬
height=768;      %棋盤圖的高
img_final=zeros(height,width);

%%
row=6;                  %棋盤圖中格子行數
col=9;                  %棋盤圖中格子列數
length=112;             %棋盤圖中格子的大小
org_X=(height-row*length)/2;
org_Y=(width-col*length)/2;
color1=1;
color2=color1;
img=zeros(row*length,col*length);

for i=0:(row-1)
    color2=color1;
    for j=0:(col-1)
        if color2==1
        img(i*length+1:(i+1)*length-1,j*length+1:(j+1)*length-1)=color2;
        end
        color2=~color2;
    end
    color1=~color1;
end

img_final(org_X:org_X+row*length-1,org_Y:org_Y+col*length-1)=img;
img_final=~img_final;
figure;
imshow(img_final);
%%
%產生棋盤格影像檔案到目錄下
imwrite(img_final, 'cheesBoard.bmp','bmp');
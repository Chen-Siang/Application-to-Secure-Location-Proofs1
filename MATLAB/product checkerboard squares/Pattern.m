%%
%Clear all;
clc,clear;

%%
width=1024;      %�ѽL�Ϫ��e
height=768;      %�ѽL�Ϫ���
img_final=zeros(height,width);

%%
row=6;                  %�ѽL�Ϥ���l���
col=9;                  %�ѽL�Ϥ���l�C��
length=112;             %�ѽL�Ϥ���l���j�p
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
%���ʹѽL��v���ɮר�ؿ��U
imwrite(img_final, 'cheesBoard.bmp','bmp');
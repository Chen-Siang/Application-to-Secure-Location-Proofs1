%clear,clc;

% Find SIFT keypoints for each image
img1 = imread('41.jpg');
img2 = imread('44.jpg');

[des1, loc1] = sift(img1);
[des2, loc2] = sift(img2);

% distRatio: Only keep matches in which the ratio of vector angles from the nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
matchTable = zeros(1,size(des1,1));
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      matchTable(i) = indx(1);
   else
      matchTable(i) = 0;
   end
end
% save matchdata matchTable

% Create a new image showing the two images side by side.
rows1 = size(img1,1);
rows2 = size(img2,1);

if (rows1 < rows2)
     img1(rows2,1) = 0;
else
     img2(rows1,1) = 0;
end
% Now append both images side-by-side.
img3= [img1 img2];   

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap('gray');
imagesc(img3);
hold on;
cols1 = size(img1,2);
for i = 1: size(des1,1)
  if (matchTable(i) > 0)
    line([loc1(i,2) loc2(matchTable(i),2)+cols1], ...
         [loc1(i,1) loc2(matchTable(i),1)], 'Color', 'c');
  end
end
hold off;
num = sum(matchTable > 0);
fprintf('Found %d matches.\n', num);


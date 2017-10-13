%Inclass 13
clear all
%Part 1. In this directory, you will find an image of some cells expressing a 
% fluorescent protein in the nucleus. 
% A. Create a new image with intensity normalization so that all the cell
% nuclei appear approximately eqully bright.
img_nuc = imread('Dish1Well8Hyb1Before_w0001_m0006.tif');
img_nuc1 = im2double(img_nuc);
img_nuc_sm = imfilter(img_nuc1,fspecial('gaussian',4,2));
img_nuc_bg = imopen(img_nuc_sm,strel('disk',17));
img_nuc_sm_bgsub = imsubtract(img_nuc_sm,img_nuc_bg);
figure(1);imshow(img_nuc_sm_bgsub,[]);

%normalizaiton
img_nuc_dil = imdilate(img_nuc_sm_bgsub,strel('disk',9));
img_nuc_norm = img_nuc_sm_bgsub./img_nuc_dil;
figure(2);imshow(img_nuc_norm,[]);
img_nuc_norm(img_nuc1 < 0.037) = 0;
%figure(25);imshow(img_nuc_norm,[]);


% B. Threshold this normalized image to produce a binary mask where the nuclei are marked true.
nucmask1 = img_nuc_norm > 0.05;
figure(3);imshow(nucmask1,[]);
nucmask1 = imerode(nucmask1,strel('disk',10));
nucmask1 = imdilate(nucmask1,strel('disk',10));
figure(4);imshow(nucmask1,[]);

% C. Run an edge detection algorithm and make a binary mask where the edges
% are marked true.
edge_img = edge (nucmask1,'canny');
figure(5);imshow(edge_img,[]);

% D. Display a three color image where the orignal image is red, the
% nuclear mask is green, and the edge mask is blue. 
img2show = cat(3,imadjust(img_nuc1),nucmask1,edge_img);
figure(6);imshow(img2show);
disp('end part 1')
%%
%Part 2. Continue with your nuclear mask from part 1. 
%A. Use regionprops to find the centers of the objects
nuc_properties = regionprops(nucmask1,'Area','Centroid','Image','PixelIdxList');
nuc_centers = cat(1,nuc_properties.Centroid);
%B. display the mask and plot the centers of the objects on top of the
%objects
figure(7);imshow(nucmask1,[]);
hold on;
plot (nuc_centers(:,1),nuc_centers(:,2),'r*','MarkerSize',20)
hold off;
%C. Make a new figure without the image and plot the centers of the objects
%so they appear in the same positions as when you plot on the image (Hint: remember
%Image coordinates). 

figure(8);
plot((nuc_centers(:,1)),-(nuc_centers(:,2)),'r*','MarkerSize',20)

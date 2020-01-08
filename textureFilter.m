function [I,clrmp,gx,gy,lambdaMaxMin]=textureFilter(ma,Ras)

% textureFilter finds local orientation
%
% SYNOPSIS   [clrmp,J11,J12,J22,gx,gy,gxy,lambdaMaxMin]=textureFilter(ma,Ras)
%
% INPUT      ma           : size of the mask for finding local orientation
%            Ras          : for plotting vectors overlaid the colormap not all points
%                           are used but every Ras-th (Raster)
%
% OUTPUT     I            : image
%            clrmp        : wrapped around colormap of I
%            gx           : gradient of I in X
%            gy           : gradient of I in Y
%            lambdaMaxMin : ratio of eigenvalues 
%                           lambdaMax gives the magnitude of the local gradient
%                           lambdaMin gives the magnitude of the local direction
%
% DEPENDENCES   textureFilter uses { wrappedColors, nrm, gauss2d }
%               textureFilter is used by { }
%
% Alexandre Matov, February 20th, 2003

if nargin == 0  
    DEBUG=1;
    Ras=20;
    ma=19; % mask size
end 

% choose an image
[fileName,dirName] = uigetfile('*.tif','Choose an image');
I=imread([dirName,filesep,fileName]);
I=I(:,:,1);
I=double(I);
I=nrm(I,8);
I=gauss2d(I,1);

% convolution mask
mask=ones(ma);

% gradient
[gx,gy] = gradient(I);

gx2=gx.*gx;
gy2=gy.*gy;
gxy=gx.*gy;

J11=conv2(gx2,mask,'same');
J12=conv2(gxy,mask,'same');
J22=conv2(gy2,mask,'same');

[p,q]=size(I);
n=p*q;   

h=waitbar(0,'Please wait...');
for i=1:n
    
    col=fix(i/p)+1;
    row=mod(i,p);
    if row==0
        row=p;
        col=col-1;
    end
    
    J=[J11(row,col), J12(row,col); J12(row,col), J22(row,col)];
    
    [v,e]=eig(J);
    
    if e(1,1)<e(2,2)
        j=1;
    else
        j=2;
    end
    
    if min(e(1,1),e(2,2))~=0
        lambdaMaxMin(row,col)=max(e(1,1),e(2,2))/(min(e(1,1),e(2,2)));
    else
        lambdaMaxMin(row,col)=NaN;
    end
    
    % vertical movement => moving UP is 0 degrees (blue)
    if v(2,j)~=0 & (max(e(1,1),e(2,2))/min(e(1,1),e(2,2)))>1.1 % only if the Y component is Not 0   
        angle=atan(v(1,j)/v(2,j));
   
        clrmp(row,col)=angle;
    else
        clrmp(row,col)=NaN;  % if the Y component is 0 => the angle is 90 degrees (moving on X)
    end      % end ATAN
    
    % Wait bar
    waitbar(i/n,h);  
end
close(h);
 

% Debug figures

if DEBUG==1
    Xmax=size(clrmp,2)-mod(size(clrmp,2),Ras)-Ras;
    Ymax=size(clrmp,1)-mod(size(clrmp,1),Ras)-Ras;
    
    clrmpS=clrmp(20:20:Ymax,20:20:Xmax);
    [X,Y]=meshgrid(20:20:Xmax,20:20:Ymax);
    
    % colormap
    figure,imshow(clrmp,[])
    colormap('wrappedColors')
    colorbar
    hold on
    h = quiver(X(:),Y(:),sin(clrmpS(:)),cos(clrmpS(:)),'wo','filled');
    set(h(1),'LineWidth',2.5)
    hold off
    
    figure,imshow(lambdaMaxMin,[1 6])
    xlabel('Lambda Max/Min');
    
    figure,quiver(gx,gy)
    axis ij
    xlabel('Gradient')
    
    figure,imshow(I,[])
    xlabel('Image');
end
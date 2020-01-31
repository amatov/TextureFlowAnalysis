function A=accumulator(alpha)

% given a coefficient alpha, function accumulator displays the local motion
% orientation with texture filter based streaks 
%
% SYNOPSIS   A=accumulator(alpha)
%
% INPUT      alpha        :   coefficient
%
% OUTPUT    
%
% DEPENDENCES   accumulator uses { textureFilter.m }
%               accumulator is used by {  }
%
% Alexandre Matov, February 11th, 2003


if nargin==0
    alpha = 0.96;
end


% choose first input directory and its first image
[file1Name,dir1Name] = uigetfile('*.tif','Choose first input directory and its first image');


if(isa(file1Name,'char') & isa(dir1Name,'char'))
   % Recover all file names from the stack
   outFileList1=defineStackNames([dir1Name file1Name]);
   % Number of files 
   n=length(outFileList1);
else
   return
end

aux1=imfinfo([dir1Name,filesep,file1Name]);
BitDepth1=aux1.BitDepth;
if aux1.ColorType~='grayscale'
    error('Not a Gray Scale Image');
end

[y1,x1]=size(imread([dir1Name,filesep,file1Name]));

s=length(num2str(n));
strg=sprintf('%%.%dd',s); 

% choose output directory and file name
[file3Name,dir3Name] = uiputfile('Specify a file name','Choose output directory and file name');

% accumulator
Acc=zeros(y1,x1);

h=waitbar(0,'Please wait! The program is creating the Accumulator images');
for i=1:n

    % Current index
    indxStr=sprintf(strg,i);
    
    % Current filenames
    currentFile1=char(outFileList1(i));
   
    % Read images from disk
    I1=imread(currentFile1);
    
    % Accumulator
    I1=double(I1);
    Acc=double(Acc);
    Acc=alpha*Acc; % a ne image-a!
    Acc=max(I1,Acc);
    
    % Convert image to integer
    switch BitDepth1
    case 8
        Acc=uint8(Acc);
    case 16
        Acc=uint16(Acc);
    otherwise
        error('BitDepth Not Supported');
    end
    
    % Write resulting image to disk
    imwrite(Acc,[dir3Name,filesep,file3Name,indxStr,'.tif']);
    
    waitbar(i/n,h);  
end
close(h);

function [im,embimg,val_i_j]=wtmark(im,wt)
% wtmark function performs watermarking in DCT domain
% it processes the image into 8x8 blocks.

% im     = Input Image
% wt     = Watermark
% embimg = Output Embedded image
% p      = PSNR of Embedded image

% Checking the dimensions
% im=imread('b.jpg');
if length(size(im))>2
    im=rgb2gray(im);
end

im        = imresize(im,[512 512]); % Resize image
watermark = imresize(im2bw((wt)),[32 32]);% Resize and convert to binary
watermark_resized = imresize(wt,[32 32]);

x={}; % empty cell which will consist of all blocks
dct_img=blkproc(im,[8,8],@dct2);% DCT of image using 8X8 block
m=dct_img; % Source image in which watermark will be inserted

k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell

%--------------------------------------------------------------------------
% To divide image in to 4096---8X8 blocks
for ii=1:8:512 % To address row -- 8X8 blocks of image
    for jj=1:8:512 % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of block
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

%--------------------------------------------------------------------------
% To insert watermark in to  blocks
i=[]; j=[]; w=1; wmrk=watermark; welem=numel(wmrk); % welem - no. of elements

prompt = {'Enter embedding location 1 (1-8)','Enter embedding location 2 (1-8)'};
dlg_title = 'Input for watermark embedding location';
num_lines = 1;
def = {'8','8'};
val_i_j = inputdlg(prompt,dlg_title,num_lines,def);
for k=1:4096
    kx=(x{k}); % Extracting block into kx for processing
    for i=1:8 % To address the rows of the blocks
        for j=1:8 % To address the column of the blocks
            if (i==str2num(val_i_j{1})) && (j==str2num(val_i_j{2})) && (w<=welem) % Criteria to insert watermark
                % This will insert the watermark at the user selected
                % location in the 8*8 block
                if wmrk(w)==0
                    kx(i,j)=kx(i,j)+35;
                elseif wmrk(w)==1
                    kx(i,j)=kx(i,j)-35;
                end
            end
        end
    end
    w=w+1;
    x{k}=kx; kx=[]; % Watermark value will be replaced in the block
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% To recombine cells into an image %%%%%%%%%
i=[]; j=[]; data=[]; count=0;
embimg1={}; % Changing the complete row cell of 4096 into 64 row cell
for j=1:64:4096
    count=count+1;
    for i=j:(j+63)
        data=[data,x{i}];
    end
    embimg1{count}=data;
    data=[];
end

% Change 64 row cell into particular columns to form the image
i=[]; j=[]; data=[];
embimg=[];  % final watermark image
for i=1:64
    embimg=[embimg;embimg1{i}];
end
embimg=(uint8(blkproc(embimg,[8 8],@idct2)));
% imwrite(embimg,'out.jpg')
function [wm]=exwmark(embimg,val_i_j)
% exwmark will extract the watermark which was embedded by the wtmark function

% embimg    = Embedded image
% wm        = Extracted Watermark

[row clm]=size(embimg);
m=embimg;

%--------------------------------------------------------------------------
% To divide the image into 8X8 blocks
k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell

for ii=1:8:row % To address row -- 8X8 blocks of image
    for jj=1:8:clm % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of the blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of the blocks
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
% Extracting the watermark
wm=[]; wm1=[]; k=1; wmwd=[]; wmwd1=[];
while(k<1025)
    for i=1:32
        kx=x{k}; % Extracting blocks one by one
        dkx=blkproc(kx,[8 8],@dct2); % Applying Dct
        nn{k}=dkx; % Save DCT values in a new block to cross check
        
        wm1=[wm1 dkx(str2num(val_i_j{1}),str2num(val_i_j{2}))]; % Forming a row of 32 by 8,8 element
        
        wmwd1=[wmwd1 kx(str2num(val_i_j{1}),str2num(val_i_j{2}))];
        k=k+1;
    end
    wm=[wm;wm1]; wm1=[]; % Forming columns of 32x32
    wmwd=[wmwd;wmwd1]; wmwd1=[];
end

for i=1:32
    for j=1:32
        diff=wm(i,j);
        if diff >=0
            wm(i,j)=0;
        elseif diff < 0
            wm(i,j)=1;
        end
    end
end

wm=wm';
% imwrite(wm,'wex.jpg')

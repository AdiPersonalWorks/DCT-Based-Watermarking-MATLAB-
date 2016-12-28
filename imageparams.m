function [ps,ber,mse,ssim_out]=imageparams(processed,original)
% Processed contains the image after watermarking
% original contains the image before watermarking

processed=im2double(processed);
original=im2double(original);
[m n]=size(original);

% mse is the Mean Square Error
error=processed - original; % calculation of error
se=error.*error; % squared error
sumse=sum(sum(se)); % sum of the squared error
mse=sumse/(m*n);%This is used to calculate the mean square error				

ma=max(max(processed));
ps=10*log10(ma*ma/mse); % y contains the psnr value.

% Bit Error Rate Calculation
[~,berratio] = biterr(uint8(original),uint8(processed));
ber = berratio;

% To calculate the SSIM (Structural Similarity)
[ssim_out, ~] = ssim(processed, original);
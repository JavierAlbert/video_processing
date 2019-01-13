function videoStabilization(inPath, outPath, params, textGUI)

%Load video file
InputVid = VideoReader(inPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
StabilizedVid = VideoWriter(outPath);
StabilizedVid.FrameRate = InputVid.FrameRate;
open(StabilizedVid);

I1=readFrame(InputVid);
I1=im2double(rgb2gray(I1));
Hcumulative = eye(3);
i=1;
while hasFrame(InputVid)
    %disp(i)
    textToDisp = sprintf('Processing frame %s out of %s', num2str(i), num2str(numFrames));
    set(textGUI, 'String', textToDisp);
    i = i+1;
    I2_RGB = readFrame(InputVid);
    I2 = im2double(rgb2gray(I2_RGB));
    I1Gauss = imgaussfilt(I1);
    I2Gauss = imgaussfilt(I2);
    H = cvexEstStabilizationTform(I1Gauss,I2Gauss);
    HsRt = cvexTformToSRT(H);
    Hcumulative = HsRt * Hcumulative;
    I2_tag(:,:,1) = imwarp(I2_RGB(:,:,1),affine2d(Hcumulative),'OutputView',imref2d(size(I2)));
    I2_tag(:,:,2) = imwarp(I2_RGB(:,:,2),affine2d(Hcumulative),'OutputView',imref2d(size(I2)));
    I2_tag(:,:,3) = imwarp(I2_RGB(:,:,3),affine2d(Hcumulative),'OutputView',imref2d(size(I2)));
    
    writeVideo(StabilizedVid,I2_tag);
    
    I1=I2;
    
end

close(StabilizedVid);
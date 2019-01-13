function videoNewBackground2(stableVideoPath, maskPath, outPath, mattingPicture, params, textGUI)

warning off

img3 = imread(mattingPicture);
img3 = imresize(img3, [480 848]);
img3 = double(img3);
        
% Read input video, create output video
InputVid = VideoReader(stableVideoPath);
InputMaskVid = VideoReader(maskPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
OutputVid = VideoWriter(outPath);
OutputVid.FrameRate = InputVid.FrameRate;
open(OutputVid);
countCaca = 1;

while hasFrame(InputVid)
    
    textToDisp = sprintf('Processing frame %s out of %s', num2str(countCaca), num2str(numFrames));
    set(textGUI, 'String', textToDisp);
    
    if countCaca == 57
        grgrrr=9;
    end
    
    disp(countCaca)
    countCaca = countCaca + 1;
    
    img1 = readFrame(InputVid);
    imgForTri = readFrame(InputMaskVid);
    img2 = triMapImage(imgForTri(:,:,1));
    
    if ~isequal(imgForTri(:,:,1),img2)
        
        % Get FG image from tri
        imageFG = zeros([480 848]);
        imageBG = zeros([480 848]);
        imageUN = zeros([480 848]);
        imageFG(img2==255) = 1;
        imageBG(img2==0) = 1;
        imageUN(img2==125) = 1;
        [~,IDXfg] = bwdist(imageFG);
        [~,IDXbg] = bwdist(imageBG);
        imageClosestValueFG = imageUN.*imageUN(IDXfg);
        imageClosestValueBG = imageUN.*imageUN(IDXbg);
    
        
        
    
    
    else
        writeVideo(OutputVid,uint8(img3));
    end
    
    % figure('Name', 'Composed Image'); imshow(uint8(img_final)); drawnow;
end
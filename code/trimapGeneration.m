function trimapGeneration(inPath, outPath)

InputVid = VideoReader(inPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
OutputVid = VideoWriter(outPath);
OutputVid.FrameRate = InputVid.FrameRate;
open(OutputVid);

% Read first image
for i = 1:50
    frame = readFrame(InputVid);
end
figure; imshow(frame);

% Ask user to define fg section
hFG = imfreehand('Closed', false);
maskFG = createMask(hFG);
% Ask user to define BG section
hBG = imfreehand('Closed', false);
maskBG = createMask(hBG);

% Use FG and BG masks to generate map
[L,P] = imseggeodesic(frame,maskFG,maskBG,'AdaptiveChannelWeighting', false);
P = im2uint8(P);
figure; imagesc(P(:,:,1)-P(:,:,2));
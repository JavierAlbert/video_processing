function  videoBackgroundRemoval(inPath, outPathExtracted, outPathBinary, params, textGUI)

% params.thresh
% params.windowSize
% params.Erode
% params.Dilate1
% params.Dilate2
% params.GaussianFiltSigma

thresh = params.thresh;     
windowSize = params.windowSize;

% Read input video, create output video
InputVid = VideoReader(inPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
OutputVidExtracted = VideoWriter(outPathExtracted);
OutputVidExtracted.FrameRate = InputVid.FrameRate;
open(OutputVidExtracted);
OutputVidBinary = VideoWriter(outPathBinary);
OutputVidBinary.FrameRate = InputVid.FrameRate;
open(OutputVidBinary);

set(textGUI, 'String', 'Doing pre processing...');
allFramesMatrix = zeros(InputVid.Height, InputVid.Width,numFrames);
% Create all frame matrix
for frameIndex = 1:numFrames
    frame = rgb2gray(readFrame(InputVid));
    allFramesMatrix(:,:,frameIndex) = frame;
end

medianBackground = median(allFramesMatrix,3);
% Mirror matrix at beggining and end floor(windowSize/2)
% allFramesMatrix = padarray(allFramesMatrix,[0 0 floor(windowSize/2)], 'symmetric');

seErode = strel('cube',params.Erode);
seDilate1 = strel('cube',params.Dilate1);
seDilate2 = strel('cube', params.Dilate2);
InputVid = VideoReader(inPath);

% --------------------- process frames -----------------------------------
for i = 1:numFrames
    if i == 50
        stop = 1;
    end
        textToDisp = sprintf('Processing frame %s out of %s', num2str(i), num2str(numFrames));
        set(textGUI, 'String', textToDisp);
        frameRGB = readFrame(InputVid);
        frame_R = frameRGB(:,:,1);
        frame_G = frameRGB(:,:,2);
        frame_B = frameRGB(:,:,3);
        frame = rgb2gray(frameRGB);
        frame = imgaussfilt(double(frame),params.GaussFiltSigma);
        % counter2 = median(allFramesMatrix(:,:,i:(i+2*floor(windowSize/2))),3);
        counter = medianBackground;
        fg = zeros(InputVid.Height, InputVid.Width);
        fg(uint8(abs(counter - frame))>thresh) = 1;
        % Delete pixels on borders
        fg(1:10,:) = 0;
        fg(:,1:10) = 0;
        fg((end-10):end,:) = 0;
        fg(:,(end-10):end) = 0;
        % Erode 
        fgErode = imerode(fg,seErode);
        % Keep biggest object
        fgBigObj = bwareafilt(logical(fgErode),1).*fg;
        % Dilate 1
        fgDilate = imdilate(fgBigObj,seDilate2);
        % Multiply by original
        finalMask = uint8(fgDilate.*fg);
        % Turn to 255
        fgFinal = 255*finalMask;
        %fg = 255*bwareaopen(fg,1000,8);
        fgFinalExtracted(:,:,1) = frame_R.*finalMask;
        fgFinalExtracted(:,:,2) = frame_G.*finalMask;
        fgFinalExtracted(:,:,3) = frame_B.*finalMask;
        writeVideo(OutputVidBinary,uint8(fgFinal));
        writeVideo(OutputVidExtracted, fgFinalExtracted)
end

close(OutputVidExtracted);
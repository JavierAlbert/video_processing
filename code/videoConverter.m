function videoConverter(inPath, outPath)
    InputVid = VideoReader(inPath);
    outVid = VideoWriter(outPath);
    outVid.FrameRate = InputVid.FrameRate;
    numFrames = floor(InputVid.Duration*InputVid.FrameRate);
    open(outVid);
    
    for i = 1:1:numFrames-45
        frame = readFrame(InputVid);
        writeVideo(outVid, frame)
    end

    close(outVid)
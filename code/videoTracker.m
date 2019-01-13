function videoTracker(inPath, outPath, params, s_initial, textGUI)

%% MAIN FUNCTION HW 3, COURSE 0512-4263, TAU 2017
%
%
% PARTICLE FILTER TRACKING
%
% THE PURPOSE OF THIS ASSIGNMENT IS TO IMPLEMENT A PARTICLE FILTER TRACKER
% IN ORDER TO TRACK A RUNNING PERSON IN A SERIES OF IMAGES.
%
% IN ORDER TO DO THIS YOU WILL WRITE THE FOLLOWING FUNCTIONS:
%
% compNormHist.m
% INPUT  = I (image) AND s (1x6 STATE VECTOR, CAN ALSO BE ONE COLUMN FROM S)
% OUTPUT = normHist (NORMALIZED HISTOGRAM 16x16x16 SPREAD OUT AS A 4096x1
%                    VECTOR. NORMALIZED = SUM OF TOTAL ELEMENTS IN THE HISTOGRAM = 1)
%
%
% predictParticles.m
% INPUT  = S_next_tag (previously sampled particles)
% OUTPUT = S_next (predicted particles. weights and CDF not updated yet)
%
%
% compBatDist.m
% INPUT  = p , q (2 NORMALIZED HISTOGRAM VECTORS SIZED 4096x1)
% OUTPUT = THE BHATTACHARYYA DISTANCE BETWEEN p AND q (1x1)
%
% IMPORTANT - YOU WILL USE THIS FUNCTION TO UPDATE THE INDIVIDUAL WEIGHTS
% OF EACH PARTICLE. AFTER YOU'RE DONE WITH THIS YOU WILL NEED TO COMPUTE
% THE 100 NORMALIZED WEIGHTS WHICH WILL RESIDE IN VECTOR W (1x100)
% AND THE CDF (CUMULATIVE DISTRIBUTION FUNCTION, C. SIZED 1x100)
% NORMALIZING 100 WEIGHTS MEANS THAT THE SUM OF 100 WEIGHTS = 1
%
%
% sampleParticles.m
% INPUT  = S_prev (PREVIOUS STATE VECTOR MATRIX), C (CDF)
% OUTPUT = S_next_tag (NEW X STATE VECTOR MATRIX)
%
%
% showParticles.m
% INPUT = I (current frame), S (current state vector)
%         W (current weight vector), i (number of current frame)
%         ID (GROUP_XX_YY as set in line #48)
%
% CHANGE THE CODE IN LINES 48, THE SPACE SHOWN IN LINES 73-74 AND 91-92
%
%
%%
ID = 'GROUP_05_08'; % FIX THIS LINE - LEAVE IT AS A STRING!

% SET NUMBER OF PARTICLES
N = params.numberOfParticles;

% Initial Settings
% images = dir('Images\*.png');
% s_initial = [320   % x center
%     128    % y center
%     23     % half width
%     43     % half height
%     0      % velocity x
%     0   ]; % velocity y

% CREATE INITIAL PARTICLE MATRIX 'S' (SIZE 6xN)
S = predictParticles(repmat(s_initial, 1, N));

InputVid = VideoReader(inPath);
numFrames = floor(InputVid.Duration*InputVid.FrameRate);
OutputVid = VideoWriter(outPath);
OutputVid.FrameRate = InputVid.FrameRate;
open(OutputVid);

% LOAD FIRST IMAGE
% I = imread(['Images\' images(1).name]);
I = readFrame(InputVid);

% COMPUTE NORMALIZED HISTOGRAM USING s_initial
q = compNormHist(I,s_initial);

% COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
% YOU NEED TO FILL THIS PART WITH CODE LINES:
W = zeros(1,N);
for m = 1:N
    W(1,m) = compBatDist(compNormHist(I,S(:,m)),q);
end
W = W/sum(W);

C = cumsum(W);


%% MAIN TRACKING LOOP
polo = 1;
while hasFrame(InputVid)
    %disp(polo)
    textToDisp = sprintf('Processing frame %s out of %s', num2str(polo), num2str(numFrames));
    set(textGUI, 'String', textToDisp);
    polo = polo + 1;
    S_prev = S;
    % LOAD NEW IMAGE FRAME
    % I = imread(['Images\' images(i).name]);
    I = readFrame(InputVid);
    
    % SAMPLE THE CURRENT PARTICLE FILTERS
    S_next_tag = sampleParticles(S_prev,C);
    
    % PREDICT THE NEXT PARTICLE FILTERS (YOU MAY ADD NOISE
    S_next = predictParticles(S_next_tag);
    
    % COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
    % YOU NEED TO FILL THIS PART WITH CODE LINES:
    W = zeros(1,N);
    for m = 1:N
        W(1,m) = compBatDist(compNormHist(I,S_next(:,m)),q);
    end
    W = W/sum(W);
    
    C = cumsum(W);
    
    % SAMPLE NEW PARTICLES FROM THE NEW CDF'S
    S = sampleParticles(S_next,C);
    
    % CREATE DETECTOR PLOTS
    
    
    %    if (mod(i,10)==0)
    showParticles(I,S,W,OutputVid);
    %    end
end

close(OutputVid);
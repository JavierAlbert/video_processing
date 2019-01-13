function handles = getParams(handles)

% Stabilization
handles.params.Stabilization.variables = 1;

% Background removal
handles.params.BackgroundRemoval.thresh = 32;
handles.params.BackgroundRemoval.windowSize = 31;
handles.params.BackgroundRemoval.Erode = 7;
handles.params.BackgroundRemoval.Dilate1 = 5;
handles.params.BackgroundRemoval.Dilate2 = 13;
handles.params.BackgroundRemoval.GaussFiltSigma = 3;

% Matting
handles.params.Matting.mattingVal = 1;

% Tracking
handles.params.Tracking.numberOfParticles = 100;
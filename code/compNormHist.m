function normHist = compNormHist(I,s)

xFrom = max(s(1)-s(3),0);
xTo = min(s(1)+s(3),size(I,2));
yFrom = max(s(2)-s(4),0);
yTo = min(s(2)+s(4),size(I,1));

% Get section of image. Gray levels are 1-16
IPortion = uint8(floor(double(I(yFrom:yTo,xFrom:xTo,:))./16)+1);

histoMatrix = zeros(16,16,16);

for t = 1:size(IPortion,1)
    for j = 1:size(IPortion,2)
            histoMatrix(IPortion(t,j,1),IPortion(t,j,2),IPortion(t,j,3)) = ...
                histoMatrix(IPortion(t,j,1),IPortion(t,j,2),IPortion(t,j,3)) + 1;
    end
end

histoVector = histoMatrix(:);

normHist = histoVector./sum(histoVector);
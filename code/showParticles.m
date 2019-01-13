function showParticles(I,S,W,OutputVideo)
      
% ADD CODE LINES HERE TO PLOT THE RED AND GREEN RECTANGLE ABOVE THE IMAGE
% DO NOT DELETE THE ORIGINAL CODE LINES 3-5 AND 12-13

shapeInserter1 = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor', uint8([255 0 0]));
shapeInserter2 = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor', uint8([0 255 0]));

% Average
averages = round(mean(S,2));

polygon1 = int32([averages(1)-averages(3)...
     averages(2)-averages(4)...
     2*averages(3)...
     2*averages(4)]);
 
% Max weight
[~,ind]=max(W);
maximal = S(:,ind);
polygon2 = int32([maximal(1)-maximal(3)...
     maximal(2)-maximal(4)...
     2*maximal(3)...
     2*maximal(4)]);

J = shapeInserter1(I, polygon1);
J = shapeInserter2(J, polygon2);

writeVideo(OutputVideo, uint8(J));
 
end



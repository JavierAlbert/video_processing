function triMapImage = triMapImage(binaryImage) 
w = 1;
edges = edge(binaryImage,'canny');
se = strel('sphere',w);
unknownArea = imdilate(edges,se);
binaryImage(unknownArea~=0) = 125;
triMapImage = binaryImage;
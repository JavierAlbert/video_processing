function S_next = predictParticles(S_next_tag)

randomMat = randn(6,size(S_next_tag,2));
S_next = S_next_tag;
S_next(1:2,:) = S_next(1:2,:) + S_next(5:6,:); 
for i=1:6
    S_next(i,:) = round(S_next(i,:) + mean(S_next(i,:))*randomMat(i,:)/100);
end

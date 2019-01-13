function S_next_tag = sampleParticles(S_prev, C)

r = rand(1,size(C,2));
S_next_tag = zeros(6,size(C,2));

for i = 1:size(C,2)
    j = find(C>r(i),1);
    try
    S_next_tag(:,i) = S_prev(:,j);
    catch
        cau= 0;
    end
end
 

function zgvec = vec2zigzag(pattern,vec)
    zgvec = zeros(1,64);
    for i=1:8
        for j=1:8
         zgvec(pattern(i,j)) = vec(i,j);
        end
    end
end
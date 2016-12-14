function K = getKey(i, j)
    if i < j
        K = bitshift(uint32(i), 16) + uint32(j);
    else
        K = bitshift(uint32(j), 16) + uint32(i);
    end
end
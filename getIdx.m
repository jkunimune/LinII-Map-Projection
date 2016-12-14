function [i, j] = getIdx(K)
    i = bitshift(K, -16);
    j = mod(K, 65536);
end
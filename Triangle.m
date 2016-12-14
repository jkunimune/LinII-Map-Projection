Image = zeros(100);
size(Image,1)
for i = 1:size(Image)
    i/2
    Image(i, int16((50-(i-2)/2)):int16(50+(i-2)/2)) = 1;
end
imshow(Image)

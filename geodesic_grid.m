function [Points, Springs] = geodesic_grid(filename, num_iterations,ms,cut)
%% generates a geodesic grid with weights based on filename
% num_iterations: number of points is 10*4^num_iterations
% filename: the name of the file that contains the weights data
% ms: should there be more springs?
% cut: should the prime meridian be cut?
% Points: an nx3 array where each row is a point, [x0, y0, m]
% Springs: an mx4 array where each row is a spring, [i, j, k, l0]

PHI = (1+sqrt(5))/2;

PtsOld = [...
     0,  PHI,  1;...
     0, -PHI,  1;...
     0,  PHI, -1;...
     0, -PHI, -1;...
     1,  0,  PHI;...
    -1,  0,  PHI;...
     1,  0, -PHI;...
    -1,  0, -PHI;...
     PHI,  1,  0;...
    -PHI,  1,  0;...
     PHI, -1,  0;...
    -PHI, -1,  0] / norm([1, PHI]);

TriOld = [
    1, 9, 3;...
    1, 3, 10;...
    1, 10, 6;...
    1, 6, 5;...
    1, 5, 9;...
    2, 4, 11;...
    2, 11, 5;...
    2, 5, 6;...
    2, 6, 12;...
    2, 12, 4;...
    3, 9, 7;...
    3, 7, 8;...
    3, 8, 10;...
    4, 12, 8;...
    4, 8, 7;...
    4, 7, 11;...
    5, 11, 9;...
    6, 10, 12;...
    7, 9, 11;...
    8, 12, 10
    ];

%% iterate the polyhedron
for i = 1:num_iterations
    
    numPoints = size(PtsOld,1);
    numFaces = size(TriOld,1);
    
    PtsNew = [PtsOld; zeros(numFaces*3, 3)];
    TriNew = zeros(numFaces*4, 3);
    p_i = numPoints+1;
    t_i = 1;
    
    for j = 1:size(TriOld,1)
        Face = TriOld(j,:);
        
        % add the midpoint of each line to the grid
        PtsNew(p_i,:) = (PtsOld(Face(1),:)+PtsOld(Face(2),:))/2;
        PtsNew(p_i,:) = PtsNew(p_i,:)/norm(PtsNew(p_i,:));
        p_i = p_i+1;
        PtsNew(p_i,:) = (PtsOld(Face(2),:)+PtsOld(Face(3),:))/2;
        PtsNew(p_i,:) = PtsNew(p_i,:)/norm(PtsNew(p_i,:));
        p_i = p_i+1;
        PtsNew(p_i,:) = (PtsOld(Face(3),:)+PtsOld(Face(1),:))/2;
        PtsNew(p_i,:) = PtsNew(p_i,:)/norm(PtsNew(p_i,:));
        p_i = p_i+1;
        
        % add new triangles with the new vertices
        TriNew(t_i,:) = [Face(1), p_i-3, p_i-1];
        t_i = t_i+1;
        TriNew(t_i,:) = [Face(2), p_i-2, p_i-3];
        t_i = t_i+1;
        TriNew(t_i,:) = [Face(3), p_i-1, p_i-2];
        t_i = t_i+1;
        TriNew(t_i,:) = [p_i-3, p_i-2, p_i-1];
        t_i = t_i+1;
    end
    
    % now remove duplicates
    PtsOld = PtsNew;
    PtsNew = zeros(numPoints+numFaces*3/2, 3);
    p_i = 1;
    for j_old = 1:size(PtsOld,1)
        [~,j_new] = ismember(PtsOld(j_old,:),PtsNew,'rows');
        if j_new == 0
            PtsNew(p_i,:) = PtsOld(j_old,:);
            j_new = p_i;
            p_i = p_i+1;
        else
        end
        
        for k = 1:size(TriNew,1) % update all references
            for l = 1:size(TriNew,2)
                if TriNew(k,l) == j_old
                    TriNew(k,l) = j_new;
                end
            end
        end
    end
    
    PtsOld = PtsNew;
    TriOld = TriNew;
    
end

%% prep image stuff
Img = rgb2gray(imread(filename));   % load the image
[img_H, img_W] = size(Img);

COLORMAP = [...
    linspace(.5,0,10).', linspace(.5,0,10).', ones(10,1);...
    zeros(10,1), linspace(1,.5,10).', zeros(10,1)];

%% reformat stuff
Points = zeros(size(PtsOld,1), 3);
Springs = zeros(size(TriOld,1)*3/2, 4);
s_i = 1;
for i = 1:size(PtsOld,1) % assign mass
    LatLon = getLatLon(PtsOld(i,:));
    idx1 = int32((pi/2-LatLon(1))/pi*img_H) + 1;
    idx2 = int32((LatLon(2)+pi)/(2*pi)*img_W) + 1;
    if idx1 >= img_H
        idx1 = img_H;
    end
    if idx2 >= img_W
        idx2 = img_W;
    end
    mass = double(Img(idx1,idx2)+10)/265.0;
    ph = LatLon(1);
    th = LatLon(2);
    Points(i,:) = [th/1.7, (1+sqrt(2)/2)*tan(ph/2)/1.7, mass];
end
for i = 1:size(TriOld,1) % assign spring constants
    for j = 1:3
        v1 = TriOld(i,j);
        v2 = TriOld(i,mod(j,3)+1);
        if v1 < v2
            P1 = PtsOld(v1,:);
            P2 = PtsOld(v2,:);
            there_should_be_a_spring =...
                ~cut ||...
                (P1(2)<0) == (P2(2)<0) ||...
                P1(1) > 0 || P2(1) > 0;
            if there_should_be_a_spring
                m1 = Points(v1, 3);
                m2 = Points(v2, 3);
                k = (m1+m2);
            else
                k = 0;
            end
            d = pdist([PtsOld(v1,:);PtsOld(v2,:)]);
            Springs(s_i,:) = [v1, v2, k, d];
            s_i = s_i+1;
        end
    end
end

%% add more springs
if ms
    
    SprNew = zeros(size(Spring_Array,1)*2, 4);
    
    
end

%% plot it
figure;
colormap(COLORMAP);
hold on;
for i = 1:size(Springs,1)
    P1 = PtsOld(Springs(i,1),:);
    P2 = PtsOld(Springs(i,2),:);
    k = Springs(i,3);
    plot3([P1(1);P2(1)], [P1(2);P2(2)], [P1(3);P2(3)],...
        'Color',[1-k/2 1-k/2 1-k/2],'LineStyle','-');
end
scatter3(PtsOld(:,1), PtsOld(:,2), PtsOld(:,3), 1000, Points(:,3),...
    'Marker','.');
axis equal;


    function philam = getLatLon(Cartesian)
        % assume norm(Cartesian) == 1
        x = Cartesian(1);
        y = Cartesian(2);
        z = Cartesian(3);
        philam = [asin(z), atan2(y,x)];
        
    end

%% misc
    function tup = keyFromVal

end
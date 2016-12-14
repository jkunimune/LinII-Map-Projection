function animateMaps( Pts, Spr, T, M )
%animateMaps    plots a bunch of points as they move in time
%   Pts: 2xnxm matrix; Pts(i,1,j) is the x-position of point i at time
%   index j, and Pts(i,2,j) is the y-position of point i at time index j
%   Y: nxm matrix; Y(i,j) is the y-position of point i at time index j
%   T: m vector; T(j) is the time at index j
%   M: n vector; M(i) is the mass of point i

COLORMAP = [...
    linspace(.5,0,10).', linspace(.5,0,10).', ones(10,1);...
    zeros(10,1), linspace(1,.5,10).', zeros(10,1)];
figure;
colormap(COLORMAP);
waitforbuttonpress();

for t = 1:length(T)
    
    clf;
    hold on;
%     for i = 1:size(Spr,1)
%         P1 = Pts(Spr(i,1),:,t);
%         P2 = Pts(Spr(i,2),:,t);
%         k = Spr(i,3);
%         plot([P1(1);P2(1)], [P1(2);P2(2)],...
%             'Color',[1-k 1-k 1-k],'LineStyle','-');
%     end
    scatter(Pts(:,1,t), Pts(:,2,t), 500, M(:), 'Marker','.');
    axis equal;
    axis([-2,2,-1.25,1.25]);
    if t < length(T)
        pause(T(t+1)-T(t));
    end
    
end

end
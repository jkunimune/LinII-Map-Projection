%% Spring Sim Advanced

%This simulates a series of masses connected togeather by springs.
% Points: an nx3 array where each row is a point, [phi, lambda, m]
% Springs: an mx4 array where each row is a spring, [i, j, k, l0]
%Point_Array = [[0,0,10];[.4,.4,1];[1.4,.6,1];[.4,1.7,1]];
%Springs_Array = [[1,2,1,10];[1,3,2,6];[1,4,1.5,8];[2,3,1,10];[3,4,3,5]];

[Point_Array, Springs_Array] = geodesic_grid('weights/landmass.jpg',3,true);

Velocity_Array = zeros(length(Point_Array),2);
damp = .1;


t = 10;
t_step = 200;
dt =  t/t_step;
damp = 1-damp*dt;

points_vs_time = zeros(length(Point_Array), 2, t_step);

for j = 1:t_step
    disp(j/t_step);
    for p = 1:length(Springs_Array)
        %% Initialization of Variables
        i_1 = Springs_Array(p,1);
        i_2 = Springs_Array(p,2);
        k = Springs_Array(p,3);
        rest = Springs_Array(p,4);
        P1 = Point_Array(i_1,1:2);
        P2 = Point_Array(i_2,1:2);
        m1 = Point_Array(i_1,3);  
        m2 = Point_Array(i_2,3);

        %% Calculate Accelerations
        X = [P1;P2];
        d = pdist(X,'euclidean');
        F = -k*(d-rest);
        a_1 = F/m1;
        a_2 = F/m2;
        norm = (P2-P1)/d;
        d_v1 = -dt*a_1*norm;
        d_v2 = dt*a_2*norm;

        Velocity_Array(i_1,:) = Velocity_Array(i_1,:)*damp+d_v1;
        Velocity_Array(i_2,:) = Velocity_Array(i_2,:)*damp+d_v2;

    end

    for i = 1:length(Point_Array)
        P = Point_Array(i,1:2);
        v = Velocity_Array(i,:);
        P = P+dt*v;
        Point_Array(i,1:2) = P;
    end
    points_vs_time(:,:,j) = Point_Array(:,1:2);
end

animateMaps(points_vs_time, Springs_Array,...
    linspace(0,t,t_step), Point_Array(:,3))

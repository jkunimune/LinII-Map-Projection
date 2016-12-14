%This simulates a series of masses connected togeather by springs. 
% Points: an nx3 array where each row is a point, [phi, lambda, m]
% Springs: an mx4 array where each row is a spring, [i, j, k, l0]
Point_Array = [[0,0,1];[.4,.4,1];[1.4,.6,1];[.4,1.7,1]];
Springs_Array = [[1,2,1,10];[1,3,2,6];[1,4,1.5,8];[2,3,1,10]];


P1 = [2,0]
P2 = [-2,0]
k = 1;
D_rest = 2;
M1 = .1;
M2 = .1;
p1_v = P1;
p2_v = P2;
v_1 = [0,0];
v_2 = [0,0];

t =5;
t_step = 1000;
dt =  t/t_step;

for i = 0:t_step
    for s = 1:length(Point_Array)
        
        X = [P1;P2];
        d = pdist(X,'euclidean');
        F = -k*(d-D_rest);
        a_1 = F/M1;
        a_2 = F/M2;
        norm = (P2-P1)/d;
        d_v1 = dt*a_1*norm;
        d_v2 = dt*a_2*norm;

        v_1 = v_1+d_v1;
        v_2 = v_2+d_v2;

        P1 = P1-dt*v_1;
        P2 = P2+dt*v_2;
        p1_v = [p1_v;P1];
        p2_v = [p2_v;P2];
    end
end

for t = 1:t_step;
clf;
axis square;
plot(p1_v(t,1),p1_v(t,2), '-ro');
hold on
plot(p2_v(t,1),p2_v(t,2), '-bo');
axis([-3,3,-3,3]);
pause(dt);
end
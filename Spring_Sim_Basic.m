%This simulates a series of masses connected togeather by springs. 
P1 = [0,0];
P2 = [3,2];
k = 1;
D_rest = 2;
M1 = 1;
M2 = 1;
p1_v = P1;
p2_v = P2;
v_1 = [0,0];
v_2 = [0,0];

t =5;
t_step = 1000;
dt =  t/t_step;

for i = 0:t_step
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
comet(p1_v(:,1),p1_v(:,2));
close all;
clear all;

h = [1, 0.5, 0.25, 0.125];
p = [1:4];

l2 = ...
    [...
        +1.142584e+00 , +6.869424e-01 , +1.846014e-01 , +5.101423e-02 ; ...
        +1.083507e+00 , +2.502310e-01 , +4.834511e-02 , +6.440845e-03 ; ...
        +7.455027e-01 , +9.920041e-02 , +5.990588e-03 , +3.872178e-04 ; ...
        +3.379661e-01 , +2.092672e-02 , +1.002601e-03 , +3.386611e-05 ; ...
    ];

P = size(p, 2);
H = size(h, 2);

delta = zeros(P, H - 1);

for i = 1:H-1
  delta(:, i) = ...
    (log10(l2(:, i + 1)) - log10(l2(:, i))) / ...
    (log10(1/h(i + 1))   - log10(1/h(i)));
end

delta

figure;
loglog(1./h, l2', '-*');
grid;
title('tet: Edge');

xlabel('1/h [-]');
ylabel('L2 Error [-]');

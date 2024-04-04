% This script assumes you've run the 'getdata' script to set up all the data matrices:
% the ``reflectance'' curve matrix R, wavelength vector w.

% Even though the paint colors were measured under different light sources, their
% computed reflectance curves should be approximately the same (we hope).

% Let's investigate that...

% The 'crayola-blue' colors for each lamp from the 'measurement' vector are in
% columns:
%  7 GrowLight
% 20 incandescent
% 31  LED
% 46 xenon

plot(w, R(:,7), w, R(:,20), w, R(:,31), w, R(:,46))
legend(measurement{7}, measurement{20}, measurement{31},measurement{46}, 'Location', 'northwest')

%% All look pretty good!

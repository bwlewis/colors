% This script assumes you've run the 'getdata' script to set up all the data matrices:
% the ``reflectance'' curve matrix R, wavelength vector w.

% Even though the paint colors were measured under different light sources, their
% computed reflectance curves should be approximately the same (we hope).

% Let's investigate that...

% The 'crayola-blue' colors for each lamp from the 'measurement' vector are in
% columns:
%  5  GrowLight-crayola-blue
% 18  incandescent-crayola-blue
% 30  LED-crayola-blue
% 43  xenon-cray-blue
% 44  xenon-cray-blue2

plot(w, R(:,5), w, R(:,18), w, R(:,30), w, R(:,43), w, R(:,44))
legend(measurement{5}, measurement{18}, measurement{30}, measurement{43}, measurement{44}, 'Location', 'northwest')

%% These are all pretty close **except** for the xenon-cray-blue2, which looks wrong. So let's not use that color.

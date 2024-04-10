%% This code assumes you've run the 'getdata' MATLAB script already.

%% Want to integrate the CIE XYZ values for a particular light source and color.
%% Let's pick the xenon light and green paint swatch for example.
%% The `measurement` variable has the column names of each measurement.
%% The xenon white measurement is in column 59.
%% The xenon green measurement is in column 47.

%% The CIE matrix contains the CIE reference curves.

%% We'll use the white paint swatch interpolated power measurement in the Mi matrix
%% to represent the light source power curve p(lambda).


%% CIE k constant for the xenon lamp:
k = 100 / sum(Mi(:,59) .* CIE(:,3))

disp("green")
%% CIE integrated X,Y,Z values using left-hand rule for the xenon lamp/green color:
X = k * sum(Mi(:,59) .* R(:,47) .* CIE(:,2))
Y = k * sum(Mi(:,59) .* R(:,47) .* CIE(:,3))
Z = k * sum(Mi(:,59) .* R(:,47) .* CIE(:,4))

%% Compare those XYZ values with a very different color, let's say crayola red.
%% That color is in column 45.

disp("Crayola red")
%% CIE integrated X,Y,Z values using left-hand rule for the xenon lamp/crayola red color:
X = k * sum(Mi(:,59) .* R(:,45) .* CIE(:,2))
Y = k * sum(Mi(:,59) .* R(:,45) .* CIE(:,3))
Z = k * sum(Mi(:,59) .* R(:,45) .* CIE(:,4))

%% Now let's try xenone crayola blue in column 43:
disp("Crayola blue")
%% CIE integrated X,Y,Z values using left-hand rule for the xenon lamp/crayola blue color:
X = k * sum(Mi(:,59) .* R(:,43) .* CIE(:,2))
Y = k * sum(Mi(:,59) .* R(:,43) .* CIE(:,3))
Z = k * sum(Mi(:,59) .* R(:,43) .* CIE(:,4))

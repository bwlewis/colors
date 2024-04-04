% check for a local data cache, otherwise download from the internet...
cache = "color_data_cache.mat";


if exist('color_data_cache.mat', 'file') == 2
  load(cache)
else
  % Load the CIE 1964 standard observer
  % This is a 471-row by 4-column matrix. The first column are the wavelengths.
  % The 2,3,4 columns are the x,y,z observers, respectively.
  CIE =readcolor("https://files.cie.co.at/CIE_xyz_1964_10deg.csv");
  % some of the CIE data is messed up...fix it:
  CIE = CIE(1:471,:);    % omit a spurious row
  CIE(isnan(CIE)) = 0;   % replace 'NaN' values with 0
  
  % character string vectors in Matlab use the {} brackets
  % (numeric vectors use []) -- this is irritating!
  % These are all the measurements we made in class:
  measurement = {"GrowLight-artminds-blue", "GrowLight-artminds-red", "GrowLight-artminds-yellow", "GrowLight-black", "GrowLight-crayola-blue", "GrowLight-crayola-red", "GrowLight-crayola-yellow", "GrowLight-green", "GrowLight-paper", "GrowLight-pink", "GrowLight-purple", "GrowLight-purple2", "GrowLight-white", "incandescent-artminds-blue", "incandescent-artminds-red", "incandescent-artmminds-yellow", "incandescent-black", "incandescent-crayola-blue", "incandescent-crayola-red", "incandescent-crayola-yellow", "incandescent-green", "incandescent-paper", "incandescent-pink", "incandescent-purple", "incandescent-white", "LED-artminds-blur", "LED-artminds-red", "LED-artminds-yellow", "LED-black", "LED-crayola-blue", "LED-crayola-yellow", "LED-cray-red", "LED-green", "LED-paper", "LED-pink", "LED-purple", "LED-white", "LED-white2", "xenon-artminds-blue", "xenon-artminds-red", "xenon-ArtMinds-yellow", "xenon-black", "xenon-cray-blue", "xenon-cray-blue2", "xenon-crayred", "xenon-crayyellow", "xenon-green", "xenon-paper", "xenon-pink", "xenon-purple", "xenon-target-green", "xenon-target-orangish", "xenon-target-orangish2", "xenon-target-pinkish", "xenon-target-purplish", "xenon-target-purplish2", "xenon-target-rocketred", "xenon-target-yellow", "xenon-white", "GrowLight", "incandescent", "LED", "xenon"};
  url = "https://raw.githubusercontent.com/bwlewis/colors/main/2024-april-2-experiments/";
  % the spectrophotometer wavelenghts are the same for all measurements...
  wavelengths = readcolor(strcat(url, measurement{1}));   %% MATLAB is very dumb here, one can't apply (1,:) to this...
  wavelengths = wavelengths(1,:)';
  M = [];
  % Now read in the measured values for each measurement into columns of the matrix M in the same order as the list above:
  for i = 1:length(measurement)
    z = readcolor(strcat(url, measurement{i}));
    z = z(2,:)';
    M = [M, z];
  end
  % cache data locally to avoid needing to load again from the internet...
  save(cache);
end

% OK now you've got the data:
% measurement is a vector of 59 measurement names corresponding to the coulmns in M below
% M is a matrix with 59 columns corresponding to the measurements above that were made in class
% wavelengths is a vector of 640 wavelength values corresponding to the rows of M
% CIE is a matrix with 471 rows and 4 columns: The first column are the wavelenghts and the rest are the CIE x,y,z observers


%% Note 1: The CIE wavelengths and the spectrophotometer wavelenghts are different. There are many more measured wavelengths
%% from the spectrophotometer. We need to match wavelengths between the two sets of data.
%% The CIE wavelengths range frmo 360, 361, 362, ..., 830 nm.
%% The spectrophotometer wavelengths range from 200 to 900 nm not evenly spaced!
%% You can use the MATLAB/Octave 'interp1' function to construct a linear interpolant of the spectrophotometer data
%% along the wavelengths used by the CIE data, see help interp1 for details:
%% The code below creates a new interpolated measurement wavelength vector 'w' and matrix of interpolated spectrophotometer
%% measurements Mi:

w = CIE(:,1);  % The CIE wavelenghts
Mi = [];
for i = 1:length(measurement)
  Mi = [Mi, interp1(wavelengths, M(:,i), w)];
end

%% Note 2: We can plot the measurements now easily. For example, here are the indices of the measurements of
%% just the new direct lighting:
%% 60 GrowLight, 61 incandescent, 62, LED, 63 xenon.
%% Let's plot them:

plot(w, Mi(:,60), w, Mi(:,61), w, Mi(:,62), w, Mi(:,63), 'LineWidth', 2);
xlabel('Wavelength (nm)', 'FontSize', 24);
ylabel('Intensity', 'FontSize', 24);
title('Light sources reflected by paper', 'FontSize', 24);
set(gca, 'FontSize', 24);
legend(measurement{60:63}, 'northwest', 'FontSize', 24)


%% Note 3: Let's look at all the colors we measured under one light source, the xenon lamp.
%% Those measurements are in the following columns:
%% 39 = xenon-artminds-blue
%% 40 = xenon-artminds-red
%% 41 = xenon-ArtMinds-yellow
%% 42 = xenon-black
%% 43 = xenon-cray-blue
%% 44 = xenon-cray-blue2
%% 45 = xenon-crayred
%% 46 = xenon-crayyellow
%% 47 = xenon-green
%% 49 = xenon-pink
%% 50 = xenon-purple
%% 51 = xenon-target-green
%% 52 = xenon-target-orangish
%% 53 = xenon-target-orangish2
%% 54 = xenon-target-pinkish
%% 55 = xenon-target-purplish
%% 56 = xenon-target-purplish2
%% 57 = xenon-target-rocketred
%% 58 = xenon-target-yellow
%% 59 = xenon-white

%% Let's see!  -- The color spectra are all really different!
plot(w, Mi(:,39));
hold on;
for i=39:47
  plot(w, Mi(:,i));
end
for i=49:49
  plot(w, Mi(:,i));
end
hold off;


%% Note 4: We need to convert these raw spectrophotometer light energy
%% measurements into % percent reflectance for each color. Let's make each curve
%% relative to the direct light measurement and call that percent reflectance.

%% We'll put the reflectance curves into a matrix called
%% R that will be exactly the same size as Mi (wavelength in rows, measurements/reflectance in columns).


R = Mi;   % make a copy of the interpolated measurements
%% now go through by each illuminant light bulb:
%% GrowLight 
p = R(:,60);
for i = 1:13    %% all the GrowLight measurements...
  R(:,i) = R(:,i) ./ p;
end
p = R(:,61);
for i = 14:25    %% all the incandescent measurements...
  R(:,i) = R(:,i) ./ p;
end
p = R(:,62);
for i = 26:38    %% all the LED measurements...
  R(:,i) = R(:,i) ./ p;
end
p = R(:,63);
for i = 39:59    %% all the xenon measurements...
  R(:,i) = R(:,i) ./ p;
end


%% EXERCISE 1:   Write a MATLAB program that uses
%%   a) "reflectance" values in the matrix R
%%   b) THE CIE x,y,z VALUES IN THE MATRIX CIE  (columns 2,3,4)
%%   c) The 'white' paint power values in the matrix Mi for each illuminant (columns 59,38,25,13)
%% and the numerical integration formula for CIE X,Y,Z in our notes to compute CIE X,Y,Z values for each
%% color and each illuminant.
%% You are free to use any interpolation rule you like.




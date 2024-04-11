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
  measurement = {"GrowLight-artminds-blue", "GrowLight-artminds-red", "GrowLight-artminds-yellow", "GrowLight-black", "GrowLight-crayola-blue", "GrowLight-crayola-red", "GrowLight-crayola-yellow", "GrowLight-green", "GrowLight-pink", "GrowLight-purple", "GrowLight-purple2", "GrowLight-white", "incandescent-artminds-blue", "incandescent-artminds-red", "incandescent-artmminds-yellow", "incandescent-black", "incandescent-crayola-blue", "incandescent-crayola-red", "incandescent-crayola-yellow", "incandescent-green", "incandescent-pink", "incandescent-purple", "incandescent-white", "LED-artminds-blur", "LED-artminds-red", "LED-artminds-yellow", "LED-black", "LED-crayola-blue", "LED-crayola-yellow", "LED-cray-red", "LED-green", "LED-pink", "LED-purple", "LED-white", "LED-white2", "xenon-artminds-blue", "xenon-artminds-red", "xenon-ArtMinds-yellow", "xenon-black", "xenon-cray-blue", "xenon-cray-blue2", "xenon-crayred", "xenon-crayyellow", "xenon-green", "xenon-white", "xenon-pink", "xenon-purple", "xenon-target-green", "xenon-target-orangish", "xenon-target-orangish2", "xenon-target-pinkish", "xenon-target-purplish", "xenon-target-purplish2", "xenon-target-rocketred", "xenon-target-yellow"};
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
% measurement is a vector of measurement names corresponding to the coulmns in M below
% M is a matrix with columns corresponding to the measurements above that were made in class
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


%% ------------------ Estimation of Reflectance Curves -----------------------------------
%% We need to convert these raw spectrophotometer light energy
%% measurements into % percent reflectance for each color. Let's make each curve
%% relative to the max reflectance paint measurement and call that percent reflectance.

%% We'll put the reflectance curves into a matrix called
%% R that will be exactly the same size as Mi (wavelength in rows, measurements/reflectance in columns).


R = Mi;   % make a copy of the interpolated measurements
%% now go through by each illuminant light bulb:
p = max(Mi(:,1:12), [], 2);    %% the GrowLight max reflectance paint reference
for i = 1:12    %% all the GrowLight measurements...
  R(:,i) = R(:,i) ./ p;
end
p = max(Mi(:,13:23),[],2);     %% the incandescent reference
for i = 13:23    %% all the incandescent measurements...
  R(:,i) = R(:,i) ./ p;
end
p = max(Mi(:,24:35),[],2);     %% the LED  reference
for i = 24:35    %% all the LED measurements...
  R(:,i) = R(:,i) ./ p;
end
p = max(Mi(:,36:55),[],2);   %% the xenon  reference
for i = 36:55    %% all the xenon measurements...
  R(:,i) = R(:,i) ./ p;
end

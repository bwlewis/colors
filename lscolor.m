%% Example full-spectrum least-squares color mixture solution
%% using the Kubelka-Munk color mixture model.
%% This code assumes getdata was run.

%% This is a function that takes the following arguments
%% r  -- the reflectance curve to match
%% P  -- a matrix of pigment reflectance curves to use
%% w  -- vector of wavelengths
%% n  -- vector of pigment names

%% It plots the original curve and estimated mixture,
%% and returns a vector of pigment concentrations.
%%
%% For example to match the pinkish target using the following 11 pigments in columns:
%% 39 xenon-artminds-blue
%% 40 xenon-artminds-red
%% 41 xenon-ArtMinds-yellow
%% 42 xenon-black
%% 43 xenon-cray-blue
%% 45 xenon-crayred
%% 46 xenon-crayyellow
%% 47 xenon-green
%% 49 xenon-pink
%% 50 xenon-purple
%% 59 xenon-white

%% The xenon-lamp illuminated target colors are in columns:
%% 51  xenon-target-green
%% 52  xenon-target-orangish
%% 53  xenon-target-orangish2
%% 54  xenon-target-pinkish
%% 55  xenon-target-purplish
%% 56  xenon-target-purplish2
%% 57  xenon-target-rocketred
%% 58  xenon-target-yellow


%% the function call is something like:

%% pinkish = R(:,54);
%% i = [39,40,41,42,43,45,46,47,49,50,59];
%% xenon_pigments = R(:,i);
%% names = measurement(i);
%% mix = lscolor(pinkish,  xenon_pigments, w, names)

function x = lscolor(r, P, w, n)

  %% wavelength range ... limit result to visible spectrum between 400 and 700 nanometers:
  k = (400 <= w & w <= 700);

  A = f(P(k,:));
  x = lsqnonneg(A, f(r(k,:)));
  plot(w(k,:), finv(f(r(k,:))), w(k,:), finv(A * x));
  legend("Target color", "Estimated match");
  x = x / sum(x);       %% re-scale into per-cent

  printf("Percent\tPigment\n");
  for i = 1:length(n)
    printf("%02.1f\t%s\n", 100*x(i), n(i){1});
  end

endfunction

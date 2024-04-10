%% Example full-spectrum least-squares color mixture solution
%% using the Kubelka-Munk color mixture model.
%% This code assumes getdata was run.

%% This is a function that takes the following arguments
%% r  -- the reflectance curve to match
%% P  -- a matrix of pigment reflectance curves to use
%% w  -- vector of wavelengths
%% It plots the original curve and estimated mixture,
%% and returns a vector of pigment concentrations.
%%
%% For example to match the pinkish target using the following 11 pigments:
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

%% the function call is something like:
%% pinkish = R(:,54);
%% xenon_pigments = [R(:,39), R(:,40), R(:,41), R(:,42), R(:,43), R(:,45), R(:,46), R(:,47), R(:,49), R(:,50), R(:,59)];
%% mix = lscolor(pinkish,  xenon_pigments, w)

function x = lscolor(r, P, w)

  A = f(P);
  x = lsqnonneg(A, f(r));
  plot(w, finv(f(r)), w, finv(A * x));
  legend("Target color", "Estimated match");
  x = x / sum(x);       %% re-scale into per-cent

endfunction

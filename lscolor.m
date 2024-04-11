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

%% the function call is something like:

% getdata2
% lscolor(R(:,1:11), R(:,12) w, measurement);   %% match 'green' color using all paints

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

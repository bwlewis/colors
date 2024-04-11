%% Example full-spectrum least-squares color mixture solution
%% using the Kubelka-Munk color mixture model.
%% This code assumes getdata was run.

%% This is a function that takes the following arguments
%% r  -- the  index of the reflectance curve to match
%% p  -- column indices of pigment reflectance curves to use
%% R  -- the matrix  of spectral reflectance curves
%% w  -- vector of wavelengths
%% n  -- vector of pigment names

%% It plots the original curve and estimated mixture,
%% and returns a vector of pigment concentrations.

function x = lscolor(r, p, R, w, n)

  %% wavelength range ... limit result to visible spectrum between 400 and 700 nanometers:
  k = (400 <= w & w <= 700);

  A = f(R(k,p));
  x = lsqnonneg(A, f(R(k,r)));
  plot(w(k,:), finv(f(R(k,r))), w(k,:), finv(A * x));
  legend("Target color", "Estimated match");
  x = x / sum(x);       %% re-scale into per-cent

  printf("Percent\tPigment\n");
  for i = 1:length(p)
    printf("%02.1f\t%s\n", 100*x(i), n(p(i)){1});
  end

endfunction

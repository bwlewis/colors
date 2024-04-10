%% Example full-spectrum least-squares color mixture solution
%% using the Kubelka-Munk color mixture model.

%% This code assumes getdata was run.


%% Step 1. Pick a target color. The names of the colors are in the 'measurement' list.
%% In this example, we'll use "xenon-target-pinkish" which is in column 54.

pinkish = R(:,54);

%% For instance, this color's reflectance curve looks like:
plot(w, pinkish);


%% Let's use the xenon lamp illuminated palette of paints. There are
%% 11 total paint colors in these columns:

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

%% That means that the least squares column will have 11 columns and 11 model coefficients.
%% Here is the model matrix:

A = [f(R(:,39)), f(R(:,40)), f(R(:,41)), f(R(:,42)), f(R(:,43)), f(R(:,45)), f(R(:,46)), f(R(:,47)), f(R(:,49)), f(R(:,50)), f(R(:,59))];

%% Here is one MATLAB way to solve an ordinary least-squares problem:

disp("Un-constrained least-squares pinkish solution:");
x = A \ f(pinkish)

%% This, in theory, gives the relative concentrations of pigments to best match the pinkish color.
%% NOTE! Many of the pigments have *negative* amounts -- this is not possible. It's one of the
%% problems associated with this model: the solution is not constrained.

%% Fortunately, MATLAB/Octave has a form of least-squares that can constrain the answer to be
%% non-negative, the function lsqnonneg:

disp("Nonnegative-constrained least-squares pinkish solution:");
x = lsqnonneg(A, f(pinkish));
x = x / sum(x)       %% re-scale into per-cent






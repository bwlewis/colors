%% Kubelka-Munk color mixture support function
%% Notice that f(1) = 0. This means that 100% reflectance colors -- which we are using as the white paint swatch in this example --
%% will be not usable. (Normally a much more reflective reference is used.)

function ans = f(x)

  ans = (1 - x) .* (1 - x) ./ (2 * x);

endfunction



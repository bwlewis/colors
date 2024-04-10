%% Kubelka-Munk color mixture support function

function ans = finv(y)

  y(y > 1) = 1;
  ans = 1 + y - sqrt(y .* (y + 2));

endfunction



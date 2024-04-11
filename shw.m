
function shw(k, w, p, names)

  plot(w, p(:, k(1)));
  hold on;
  for i = 2:length(k)
    plot(w, p(:, k(i)));
  end
  hold off;
  legend(names{k}, 'FontSize', 20);

endfunction

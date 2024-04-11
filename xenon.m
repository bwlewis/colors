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


k = [39,40,41,42,43,44,45,46,47,49,50,59];
l = (400 <= w & w <= 700);  %% visible spectrum
plot(w(l), R(l,k(1)));
hold on;
for(i = 2:length(k))
  plot(w(l), R(l,k(i)));
end
hold off;
legend(measurement(k));

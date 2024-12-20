
function [pwav] = p_wav(x, a_pwav, d_pwav, t_pwav, li) 
  l = li;
  a = a_pwav;
  x = x + t_pwav;   %time vector + duration of interval
  b = (2*l)/d_pwav;    %scaling factor(whole wave is defined in the time interval)
  n = 100;    %no. of harmonics 
  p1 = 1/l;   
  p2 = 0;
  for i = 1:n
      harm1 = (((sin((pi/(2*b))*(b-(2*i))))/(b-(2*i))+(sin((pi/(2*b))*(b+(2*i))))/(b+(2*i)))*(2/pi))*cos((i*pi*x)/l);             
      p2 = p2 + harm1;
  end
  
  pwav1 = p1 + p2;
  pwav = a * pwav1;
  
end

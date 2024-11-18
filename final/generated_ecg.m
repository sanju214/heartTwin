clc;
clear all;
close all;

% Load the dataset
data = readtable('ecg_parameters.csv');

% Extract parameters from the dataset
heartRate = data.heartRate;
pwav  = [data.p_amp, data.p_dur, data.p_pr];
qwav  = [data.q_amp, data.q_dur, 0.166];
qrswav  = [data.qrs_amp, data.qrs_dur];
swav  = [data.s_amp, data.s_dur, 0.09];
twav  = [data.t_amp, data.t_dur, data.t_st];
uwav  = [data.u_amp, data.u_dur, 0.433];

interval = 0.5;
t = 0:0.01:5;
li = 30 / heartRate;

fprintf('\n\nECG Simulator is running...');
fprintf('\n[ Press Control + C to stop ]\n');

% Initialize an empty array to store the generated ECG signal
ecg_signal = [];

figure('name', 'ECG Simulation', 'numbertitle', 'off', 'Units', 'normalized', 'Position', [0.02 0.4 0.9 0.5]);

while(true)
  t = t + 0.25;
  
  % P wave output
  pwav_result = p_wav(t, pwav(1), pwav(2), pwav(3), li);

  % Q wave output
  qwav_result = q_wav(t, qwav(1), qwav(2), qwav(3), li);

  % QRS wave output
  qrswav_result = qrs_wav(t, qrswav(1), qrswav(2), li);

  % S wave output
  swav_result = s_wav(t, swav(1), swav(2), swav(3), li);

  % T wave output
  twav_result = t_wav(t, twav(1), twav(2), twav(3), li);

  % U wave output
  uwav_result = u_wav(t, uwav(1), uwav(2), uwav(3), li);

  % ECG output
  ecg = pwav_result + qwav_result + qrswav_result + swav_result + twav_result + uwav_result;

  % Store the generated ECG signal
  ecg_signal = [ecg_signal, ecg];

  plot(t, ecg);
  grid minor;
  xlim([min(t), max(t)]);
  
  pause(interval);

 
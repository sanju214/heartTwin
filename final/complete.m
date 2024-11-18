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

interval = 0.5;   % Time between each update
t = 0:0.01:40;  % Time vector: starts at 0, ends at 5, increments by 0.01s
li = 60 / heartRate; 

fprintf('\n\nECG Simulator is running...');
fprintf('\n[ Press Control + C to stop ]\n');

figure('name', 'ECG Simulation', 'numbertitle', 'off', 'Units', 'normalized', 'Position', [0.02 0.4 0.9 0.5]);

total_duration = 5; % Duration of generation cycle in seconds
num_iterations = total_duration / interval;  % Number of iterations

ecg_signal = [];  % Initialize an empty array to store the generated ECG signal
t_total = [];     % Initialize an empty array to store the time vector

for k = 1:num_iterations
    t = t + 0.25; % Updating the time vector to show new portions of the ECG signal over time
  
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

    % ECG output
    ecg = pwav_result + qwav_result + qrswav_result + swav_result + twav_result;

    % Store the generated ECG signal and time vector
    ecg_signal = [ecg_signal, ecg];
    t_total = [t_total, t];
    
    plot(t, ecg);
    grid minor;
    xlim([min(t), max(t)]);
    
    pause(interval);
end

% Save the generated ECG signal
save('generated_ecg_signal.mat', 'ecg_signal', 't_total');

 % Load the generated ECG signal
load('generated_ecg_signal.mat');
% Example: Detect R-peaks
[~, locs_R] = findpeaks(ecg_signal, 'MinPeakHeight', 0.5, 'MinPeakDistance', 50);
% Detect P, Q, S, T waves around the R-peaks
% Example: Detecting P-waves before R-peaks
window = 50; % Search window size
locs_P = [];
for i = 1:length(locs_R)
   [~, locs_P_temp] = findpeaks(ecg_signal(max(1, locs_R(i)-window):locs_R(i)), 'NPeaks', 1, 'SortStr', 'descend');
   locs_P = [locs_P, locs_R(i) - window + locs_P_temp - 1];
end
% Similar detection for Q, S, T waves
locs_Q = [];
locs_S = [];
locs_T = [];
for i = 1:length(locs_R)
   % Q wave
   [~, locs_Q_temp] = findpeaks(-ecg_signal(max(1, locs_R(i)-window):locs_R(i)), 'NPeaks', 1, 'SortStr', 'descend');
   locs_Q = [locs_Q, locs_R(i) - window + locs_Q_temp - 1];
  
   % S wave
   [~, locs_S_temp] = findpeaks(-ecg_signal(locs_R(i):min(end, locs_R(i)+window)), 'NPeaks', 1, 'SortStr', 'descend');
   locs_S = [locs_S, locs_R(i) + locs_S_temp - 1];
  
   % T wave
   [~, locs_T_temp] = findpeaks(ecg_signal(locs_R(i):min(end, locs_R(i)+window)), 'NPeaks', 1, 'SortStr', 'descend');
   locs_T = [locs_T, locs_R(i) + locs_T_temp - 1];
end
% Plot the signal with detected peaks
figure;
plot(t_total, ecg_signal);
hold on;
plot(t_total(locs_R), ecg_signal(locs_R), 'rv', 'MarkerFaceColor', 'r');
plot(t_total(locs_P), ecg_signal(locs_P), 'bo', 'MarkerFaceColor', 'b');
plot(t_total(locs_Q), ecg_signal(locs_Q), 'go', 'MarkerFaceColor', 'g');
plot(t_total(locs_S), ecg_signal(locs_S), 'mo', 'MarkerFaceColor', 'm');
plot(t_total(locs_T), ecg_signal(locs_T), 'ko', 'MarkerFaceColor', 'k');
hold off;
title('ECG Signal with Detected Peaks');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
legend('ECG Signal', 'R Peaks', 'P Peaks', 'Q Peaks', 'S Peaks', 'T Peaks');
% Extract amplitudes, durations, and intervals
P_amplitudes = ecg_signal(locs_P);
Q_amplitudes = ecg_signal(locs_Q);
R_amplitudes = ecg_signal(locs_R);
S_amplitudes = ecg_signal(locs_S);
T_amplitudes = ecg_signal(locs_T);
% Calculate durations (example: assuming 0.01s time step)
P_durations = diff(t_total(locs_P));
Q_durations = diff(t_total(locs_Q));
R_durations = diff(t_total(locs_R));
S_durations = diff(t_total(locs_S));
T_durations = diff(t_total(locs_T));
% Calculate intervals
PR_intervals = t_total(locs_R) - t_total(locs_P);
ST_intervals = t_total(locs_T) - t_total(locs_S);
% Calculate heart rate
RR_intervals = diff(t_total(locs_R));
heart_rate = 60 ./ RR_intervals; % beats per minute
% Display extracted parameters
disp('P Wave Amplitudes:');
disp(P_amplitudes);
disp('PR Intervals:');
disp(PR_intervals);
disp('Q Wave Amplitudes:');
disp(Q_amplitudes);
disp('Q Wave Durations:');
disp(Q_durations);
disp('R Wave Amplitudes:');
disp(R_amplitudes);
disp('QRS Durations:');
disp(R_durations);
disp('S Wave Amplitudes:');
disp(S_amplitudes);
disp('S Wave Durations:');
disp(S_durations);
disp('ST Intervals:');
disp(ST_intervals);
disp('T Wave Amplitudes:');
disp(T_amplitudes);
disp('T Wave Durations:');
disp(T_durations);

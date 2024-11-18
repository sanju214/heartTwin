% Load the .mat file
data = load('generated_ecg.mat');

% Access the ecg_signal variable
ecg_signal = data.ecg_signal;

% Display the first few values of ecg_signal
disp(ecg_signal(1:10));

% Load the .mat file
data = load('generated_ecg.mat');

% Access the ecg_signal variable
ecg_signal = data.ecg_signal;

% Plot the ECG signal
figure;
plot(ecg_signal);
title('ECG Signal');
xlabel('Sample Number');
ylabel('Amplitude');
grid on;

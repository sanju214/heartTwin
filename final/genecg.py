import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint

# Define the parameters for resistance, capacitance, and inductance
R1, R2, R3 = 1000, 1500, 500  # Resistances in ohms
C1, C2 = 1e-6, 2e-6           # Capacitances in farads
L1 = 0.002                    # Inductance in henrys

# Define the heart rate and sampling frequency
heart_rate = 70  # Beats per minute
fs = 500        # Sampling frequency in Hz
T = 60 / heart_rate  # Period of one beat in seconds
t = np.linspace(0, 10, fs*10)  # 10-second signal

# Function to model the ECG signal using a simple differential equation
def ecg_model(y, t, R1, R2, C1, C2, L1):
    V1, V2, I = y
    dV1_dt = (I - V1/R1) / C1
    dV2_dt = (I - V2/R2) / C2
    dI_dt = (V1 - V2) / L1
    return [dV1_dt, dV2_dt, dI_dt]

# Initial conditions
y0 = [0, 0, 0]

# Solve the differential equations
solution = odeint(ecg_model, y0, t, args=(R1, R2, C1, C2, L1))
V1, V2, I = solution.T

# Generate a synthetic ECG signal using the solution
ecg_signal = V1 - V2

# Plot the simulated ECG signal
plt.figure(figsize=(10, 5))
plt.plot(t, ecg_signal)
plt.title("Simulated ECG Signal")
plt.xlabel("Time (s)")
plt.ylabel("Voltage (mV)")
plt.grid(True)
plt.show()

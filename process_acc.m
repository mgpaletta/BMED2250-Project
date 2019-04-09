%BMED2250 Project - accelerometer Preprocessing Function

%Creating a function that takes in time series accelerometer data, converts it to
%frequency space, filters it with a high-pass filter, and converts
%it back to the time domain using an inverse FFT. This data is then ready
%to be fed to the predictive algorithm for Parkinsonian tremor.

%function assumes input has already been correctly sized via a sliding
%window

%Fs = sampling frequency, low = low freq cutoff

function acc_out = process_acc(acc_in, Fs, low)
%remove DC offset (constant term) from accelerometer signal
raw = acc_in - mean(acc_in)
%perform FFT on data and take the absolute value
fast = fft(raw)
fast_abs = abs(fft(raw))
%calculate the length of the sample, L
L = length(raw)
%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(fast_abs/L)
P1 = P2(1:L/2+1)
P1(2:end-1) = 2*P1(2:end-1)
%calculate the period, T
T = 1/Fs
%find the sample time in seconds.
t = L*T
%highpass filter the raw signal
filtered = fast
filtered(1:low*t+1)= 0
filtered(L-low*t+1:L)= 0
%perform iFFT to put data back in time domain
acc_out = ifft(filtered)
end






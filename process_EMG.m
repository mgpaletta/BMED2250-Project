%BMED2250 Project - EMG Preprocessing Function

%Creating a function that takes in time series EMG data, converts it to
%frequency space, filters it with a bandpass filter, and converts
%it back to the time domain using an inverse FFT. This data is then ready
%to be fed to the predictive algorithm for Parkinsonian tremor.

%function assumes input has already been correctly sized via a sliding
%window

%Fs = sampling frequency, hi = high freq cutoff, low = low freq cutoff

function EMG_out = process_EMG(EMG_in, Fs, low, hi)
%remove DC offset (constant term) from EMG signal
raw = EMG_in - mean(EMG_in);
%perform FFT on data and take the absolute value
fast = fft(raw);
fast_abs = abs(fft(raw));
%calculate the length of the sample, L
L = length(raw);
%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(fast_abs/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
%calculate the period, T
T = 1/Fs;
%find the sample time in seconds.
t = L*T;
%bandpass filter the raw signal
filtered = fast;
filtered(1:low*t) = 0;
filtered(hi*t+1:L-hi*t) = 0;
filtered(L-low*t+1:L) = 0;
%put data back in time domain with iFFT
EMG_out = ifft(filtered,'symmetric');
end







%BMED2250 Project - Predictive Algorithm

%creating a function that can take in filtered EMG data that has
%tremor frequencies added to it at random and make a prediction of whether
%or not tremor will occur based on the amplitudes of frequencies within the
%signal. 

function [prediction] = predicto(data,window,stride,fs,tremor_cutoff,baseline_cutoff,threshold_ratio)
    %make a spectrogram for the data and take the absolute value
    %for spect--rows are freq bins, columns are time
    %rows go from lowest frequency bands to highest?
    bin_width = fs/window;
    data = data - mean(data);
    spect = abs(spectrogram(data,window,window-stride,window,fs,'yaxis'));
    tremor_band_amplitude = mean(spect(1:tremor_cutoff/bin_width, :));
    baseline_band_amplitude_mean = mean(spect((tremor_cutoff/bin_width)+1:baseline_cutoff/bin_width, :), 'all');
%     plot(tremor_band_amplitude);
%   spectrogram(data,window,window-stride,window,fs,'yaxis')
    prediction = tremor_band_amplitude > threshold_ratio * baseline_band_amplitude_mean;
    prediction = [zeros(1, window - stride, 'logical') repelem(prediction, stride)];
    %should output times a prediction is made--add this
    %function that takes diffs between 0 and 1
end







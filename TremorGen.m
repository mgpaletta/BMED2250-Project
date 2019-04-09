%BMED2250 Project - TremorGen Function

%Creating a function that models Parkinsonian tremor data by adding
%component sine waves from 3-18Hz to data collected from non-Parkinsonian
%test subjects. This should be added in random areas to the filtered data,
%and those areas will be recorded by the function to be graphed later and
%ensure that the predictive algorithm is successfully able to predict the
%modeled tremor.

%Fs = sampling frequency of input data, low = low freq cut off for added
%waves, hi = hi freq cut off for added waves, Amp = amplitude for sine
%waves

function [tremor_data,tremor_times] = TremorGen(data, Fs, low, hi, Amp)
%randomly generate number of tremors between 0 and 5
tremor_count = randi([0,5]);
%randomly generate start and end samples for tremor
cuts = randsample(length(data), tremor_count *2)';
%sort cuts from low to high to create intervals, and pair them
cuts_sorted = sort(cuts);
ints = [cuts_sorted(1:2:end); cuts_sorted(2:2:end)]';
%convert start samples to times
tremor_times = ints/Fs;
%generate sine waves
size(data);
tremor_data = data;
for i = 1:tremor_count;
    %find start and end times
    start = ints(i,1);
    fin = ints(i,2);
    L = (fin - start) + 1;
    f = randi([low,hi]); %generate frequency for waves
    T = 1/Fs; %sampling period
    t = T*L;  %number of samples*period
    times = 0:T:t; %time vector
    tremor = Amp * sin(2*pi*f*times(1:end-1)); %generate sine wave
    %put tremor into the original data
    tremor_data(start:fin) = tremor_data(start:fin)' + tremor;
end
end







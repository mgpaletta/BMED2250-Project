%BMED2250 Project - Prediction Script

%load data
% load('S1_20140620T021349.mat')
load('S2_20140623T203911.mat')

%first dimension of data_EMG is samples
%second dimension is EMG channel (6)
%third is 189 trials

%should probably create a way to randomize which data to use with each run
%here is an example data piece
EMG = data_EMG(:,1,2);

%add tremor to the data using TremorGen
[EMG_tremor_data,EMG_tremor_times] = TremorGen(EMG, 4000, 3, 18, 0.01);
EMG_tremor_times

tremor_occurence = zeros(1,20000,'logical')
tremor_samps = round(EMG_tremor_times * 4000);

%create a logical vector that shows where tremor is occurring to compare to
%predictions made by the algorithm
for i = 1:size(tremor_samps,1)
    tremor_occurence(tremor_samps(i,1):tremor_samps(i,2)) = true
end
    
%process the sample data with process_EMG function
% p_EMG = process_EMG(EMG_tremor_data, 4000, 3, 40);

% EMG_tremor_data = awgn(EMG_tremor_data, 80);

% spectrogram test
% figure
% sp = spectrogram(p_EMG,800,700,800,4000,'yaxis');
% spectrogram(p_EMG,800,700,800,4000,'yaxis');
% figure
EMG_tremor_data_spect = EMG_tremor_data - mean(EMG_tremor_data);
spectrogram(EMG_tremor_data_spect,400,300,400,4000,'yaxis');
title('EMG spectrogram with SNR=80')
%data, window width, window overlap, fft samples, sampling freq


prediction = predicto(EMG_tremor_data, 400, 100, 4000, 20, 100, 0.12);

prediction_diff = diff(prediction);
prediction_starts = find(prediction_diff == 1) + 1;

correct = sum(prediction == tremor_occurence)/20000

fp_vec = (prediction & ~tremor_occurence);
false_pos = sum(fp_vec)/20000

fn_vec = (~prediction & tremor_occurence);
false_neg = sum(fn_vec)/20000

check = false_neg + false_pos + correct

%graph them using GraphGen
figure
hold on
GraphGen(EMG_tremor_data,EMG_tremor_times,prediction_starts,4000);
title('Single Trial EMG with SNR=80')
xlabel('time (s)')
ylabel('voltage (mV)')
% GraphGen(p_EMG,4000);
hold off


%need to figure out true positives, false positives, false negatives, etc.
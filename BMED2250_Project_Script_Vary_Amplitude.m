%BMED2250 Project - Project Script for Varied Amplitude

%% Load Data
% data = load('S1_20140620T021349.mat');
% data_EMG = data.data_EMG;
% data = load('S2_20140623T203911.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S3_20140623T192807.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S4_20140627T223453.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S5_20140703T205312.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S6_20140703T220200.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S7_20140707T233403.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S8_20140724T163311.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S9_20140728T153220.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);
% data = load('S10_20140728T164447.mat');
% data_EMG = cat(3, data_EMG, data.data_EMG);

%% Setup amplitude loop
%first dimension of data_EMG is samples
%second dimension is EMG channel (6)
%third is 189 trials

amp_vec = 0.0001:0.0001:0.02;

agg_mean_accuracy = zeros(1, length(amp_vec));
agg_mean_precision = zeros(1, length(amp_vec));
agg_mean_sensitivity = zeros(1, length(amp_vec));
agg_mean_specificity = zeros(1, length(amp_vec));


for amp_i = 1:length(amp_vec)
    
%% Single amplitude test

% amp_i = 100;

agg_accuracy = zeros(1, size(data_EMG,3));
agg_precision = zeros(1, size(data_EMG,3));
agg_sensitivity = zeros(1, size(data_EMG,3));
agg_specificity = zeros(1, size(data_EMG,3));



%loop over all the trials
for i = 1:size(data_EMG,3)

%should probably create a way to randomize which data to use with each run
%here is an example data piece
EMG = data_EMG(:,1,i);

%add tremor to the data using TremorGen
[EMG_tremor_data,EMG_tremor_times] = TremorGen(EMG, 4000, 3, 18, amp_vec(amp_i));


tremor_occurence = zeros(1,20000,'logical');
tremor_samps = round(EMG_tremor_times * 4000);

%create a logical vector that shows where tremor is occurring to compare to
%predictions made by the algorithm
for j = 1:size(tremor_samps,1)
    tremor_occurence(tremor_samps(j,1):tremor_samps(j,2)) = true;
end
    
%process the sample data with process_EMG function
p_EMG = process_EMG(EMG_tremor_data, 4000, 3, 40);


prediction = predicto(EMG_tremor_data, 400, 200, 4000, 20, 100, 0.12);

prediction_diff = diff(prediction);
prediction_starts = find(prediction_diff == 1) + 1;



% accuracy = (TP + TN)/(TP + TN + FP + FN)
accuracy = sum(prediction == tremor_occurence)/20000;

% precision = TP / (TP + FP)
tp_vec = (prediction & tremor_occurence);
if sum(prediction) == 0
    precision = 1;
else
    precision = sum(tp_vec)/sum(prediction);
end

% sensitivity(hit rate) = TP/(TP + FN)
if sum(tremor_occurence) == 0
    sensitivity = 1;
else
    sensitivity = sum(tp_vec)/sum(tremor_occurence);
end

% specificity = TN/(FP + TN)
tn_vec = (~prediction & ~tremor_occurence);
if sum(~tremor_occurence) == 0
    specificity = 1;
else 
    specificity = sum(tn_vec)/sum(~tremor_occurence);
end

% fp_vec = (prediction & ~tremor_occurence);
% if sum(~tremor_occurence) == 0
%     false_pos = 0;
% else
%     false_pos = sum(fp_vec)/sum(~tremor_occurence);
% end
% 
% fn_vec = (~prediction & tremor_occurence);
% if sum(tremor_occurence) == 0
%     false_neg = 0;
% else
%     false_neg = sum(fn_vec)/sum(tremor_occurence);
% end


agg_accuracy(i) = accuracy;
agg_precision(i) = precision;
agg_sensitivity(i) = sensitivity;
agg_specificity(i) = specificity;

end

mean_accuracy = mean(agg_accuracy);
mean_precision = mean(agg_precision);
mean_sensitivity = mean(agg_sensitivity);
mean_specificity = mean(agg_specificity);

%% End single amplitude test

agg_mean_accuracy(amp_i) = mean_accuracy;
agg_mean_precision(amp_i) = mean_precision;
agg_mean_sensitivity(amp_i) = mean_sensitivity;
agg_mean_specificity(amp_i) = mean_specificity;



end

% accuracy = (TP + TN)/(TP + TN + FP + FN) - done
% precision = TP / (TP + FP)
% sensitivity(hit rate) = TP/(TP + FN)
% specificity = TN/(FP + TN)

scatter(amp_vec,agg_mean_accuracy)
title('mean accuracy vs. tremor amplitude')
xlabel('amplitude (mV)')
ylabel('mean accuracy')
figure
scatter(amp_vec,agg_mean_precision)
title('mean precision vs. tremor amplitude')
xlabel('amplitude (mv)')
ylabel('mean precision')
figure
scatter(amp_vec,agg_mean_sensitivity)
title('mean sensitivity vs. tremor amplitude')
xlabel('amplitude (mV)')
ylabel('mean sensitivity')
figure
scatter(amp_vec,agg_mean_specificity)
title('mean specificity vs. tremor amplitude')
xlabel('amplitude (mV)')
ylabel('mean specificity')

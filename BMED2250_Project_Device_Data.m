% hello there

% file1 = fopen('forearm.txt','r')
% file1 = fopen('desk.txt','r')
% file1 = fopen('extensor_digitorum_communis.txt','r')
% file1 = fopen('flexor_carpi_radialis.txt','r')
file1 = fopen('extensor_carpi_ulnaris.txt','r')
% file1 = fopen('extensor_carpi_ulnaris_rest.txt','r')


data1 = fscanf(file1,'%f') / 1024;

data1 = data1 - mean(data1);

figure
spectrogram(data1,100,75,100,1000,'yaxis');

prediction1 = predicto(data1, 100, 75, 1000, 20, 100, 3.05);

prediction_diff1 = diff(prediction1);
prediction_starts1 = find(prediction_diff1 == 1) + 1;

figure

Fs=1000

T = 1/Fs;
L = length(data1);
t = T*(L-1);
times = 0:T:t;
length(times);
length(data1);
%create a graph of the raw signal
hold on
plot(times,data1);
title('EMG recording from flexor carpi radialis')
ylabel('voltage (mV)')
xlabel('time (s)')
% prediction_starts1 = prediction_starts1/Fs;
% scatter(prediction_starts1,zeros(1,length(prediction_starts1)),150,'p','filled','k')
hold off

snr1 = snr(data1)

tremor_occurence1 = zeros(1,length(prediction1));

% accuracy = (TP + TN)/(TP + TN + FP + FN)
accuracy1 = sum(prediction1 == tremor_occurence1)/length(prediction1);
accuracy1

% precision = TP / (TP + FP)
tp_vec1 = (prediction1 & tremor_occurence1);
if sum(prediction1) == 0
    precision1 = 1
else
    precision1 = sum(tp_vec1)/sum(prediction1)
end

precision1

% sensitivity(hit rate) = TP/(TP + FN)
if sum(tremor_occurence1) == 0
    sensitivity1 = 1;
else
    sensitivity1 = sum(tp_vec1)/sum(tremor_occurence1);
end

sensitivity1

% specificity = TN/(FP + TN)
tn_vec1 = (~prediction1 & ~tremor_occurence1);
if sum(~tremor_occurence1) == 0
    specificity1 = 1;
else 
    specificity1 = sum(tn_vec1)/sum(~tremor_occurence1);
end

specificity1


%% data

file2 = fopen('forearm2.txt','r')

data2 = fscanf(file2,'%f') / 1024

data2 = data2 - mean(data2)

figure
plot(data2)

figure
spectrogram(data1,100,75,100,1000,'yaxis');


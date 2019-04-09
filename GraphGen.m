%BMED2250 Project - GraphGen Function

%Creating a function that graphs data to visualize the filtered data, show
%where tremors were added via TremorGen.m, and where tremor was predicted
%by the algorithm.

function GraphGen(data,tremors,predictions,Fs)
    %find time for the data
    T = 1/Fs;
    L = length(data);
    t = T*(L-1);
    times = 0:T:t;
    length(times);
    length(data);
    %create a graph of the raw signal
    hold on
    plot(times,data);
    tremor_samps = round(tremors * Fs);
    for i = 1:size(tremor_samps,1)
    plot(times(tremor_samps(i, 1):tremor_samps(i, 2)), data(tremor_samps(i, 1):tremor_samps(i, 2)))
    end
    predictions = predictions/Fs;
    scatter(predictions,zeros(1,length(predictions)),150,'p','filled','k')
end
    
    
    
    
    
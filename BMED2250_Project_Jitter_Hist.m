% BMED2250 project - finding the jitter between sampling intervals on the
% sensor

file1 = fopen('jitter.txt','r')

jitters = fscanf(file1,'%f');

% compile jitters into bins of ?? width

% histogram('BinEdges',edges,'BinCounts',counts)

edges = 0:100:10000
bincounts = jitters(1:2:end) + jitters (2:2:end)

figure
histogram('BinEdges',edges,'BinCounts',bincounts)
title('histogram of sample intervals')
xlabel('time (microseconds)')

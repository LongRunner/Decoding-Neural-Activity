load array_3

orientationAxis = sort(unique(ori));
[~, sidx] = sort(ori);
nNeurons = size(neur_param, 1);
nRepeats = 50;
nOrientations = numel(orientationAxis);
T = 2560e-3;
assert(size(spk_times, 2) == nRepeats * nOrientations);

%% Generate Tuning curve (including the blank period)
counts = cellfun('length', spk_times);
H = kron(eye(nOrientations), ones(nRepeats, 1)) / nRepeats; % averaging matrix

figure(1009); clf;
for kNeuron = 1:nNeurons
    plot(orientationAxis, counts(kNeuron, sidx) * H / T);
    ylabel('mean spike rate (Hz)');
    xlabel('orientation');
    xlim([0 360]);
    pause;
end

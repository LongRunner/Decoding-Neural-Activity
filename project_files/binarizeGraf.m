function [dataPerOri, ori, orientationAxis] = binarizeGraf(arrayNum, binSize, windowSizeL, windowSizeR, m, collapseOverOrientations)

%
if nargin < 1; arrayNum = 3; end
if nargin < 2; binSize = 16; end
if nargin < 3; windowSizeL = 400; end
if nargin < 4; windowSizeR = 1200; end
if nargin < 5; m = []; end
if nargin < 6; collapseOverOrientations = false; end

[spk_times, T, ori, orientationAxis, nRepeats, nOrientations] = loadGraf2011(arrayNum);
if isempty(m) || m <= 0
    m = size(spk_times, 1);
end

if(collapseOverOrientations)
    orientationAxis = unique(mod(orientationAxis,180));
    nOrientations = numel(orientationAxis);
end

nBins = ceil(T*1e3/binSize);
binEdges = binSize/2:binSize:nBins * binSize;
windowStartIdx = ceil(windowSizeL/binSize); % after the onset response
windowEndIdx = ceil(windowSizeR/binSize); % just before stimulus went off

dataPerOri = cell(nOrientations,1);
for kOrientation = 1:nOrientations
    oriChosen = orientationAxis(kOrientation);
    oidx = find(ori == oriChosen);

    
    % bin spike trains
    binnedData = zeros(m, nBins, numel(oidx));
    for kNeuron = 1:m
	for kTrial = 1:numel(oidx)
	    st = spk_times{kNeuron, oidx(kTrial)};
	    if ~isempty(st)
		binnedData(kNeuron, :, kTrial) = histc(st, binEdges);
	    end
	end
    end

    %%
    data = reshape(binnedData(:, windowStartIdx:windowEndIdx, :), m, []); % words x time binary vector
    data(data ~= 0) = 1; % binarize response
    dataPerOri{kOrientation} = data;
end

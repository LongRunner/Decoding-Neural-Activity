function [spk_times, T, ori, orientationAxis, nRepeats, nOrientations] = loadGraf2011(arrayNumber)
% [spk_times, T, ori, orientationAxis, nRepeats, nOrientations] = loadGraf2011(arrayNumber);
% Load the Graf V1 drifting orientation grating response data.
%
% Input:
%   arrayNumber: the dataset contains 5 arrays. choose one!
%
% Output:
%   spk_times: {Nx3600} N simultaneously recorded spike trains
%		for 3600 conditions in ms
%

assert(ismember(arrayNumber, 1:5), 'There are only 5 sets of data');
load(['array_' num2str(arrayNumber)]);

orientationAxis = sort(unique(ori));
nNeurons = size(neur_param, 1);
nRepeats = 50;
nOrientations = numel(orientationAxis);
T = 2560e-3;
assert(size(spk_times, 2) == nRepeats * nOrientations);

function out = spkTime_to_spkCount(spk_times)
[r,c]=size(spk_times);
for i = 1:r
    for j = 1:c
        out(i,j)=numel(spk_times{i,j}(200<=spk_times{i,j} & spk_times{i,j}<=1280));
    end
end
end
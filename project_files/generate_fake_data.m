function [spk_count,ori] = generate_fake_data(true_tcs,ori_tot,number_of_repeats_per_ori)
ori=[];
spk_count=[];
for i = 1:length(ori_tot)
    for j = 1:number_of_repeats_per_ori
        spk_count(:,j+((i-1)*number_of_repeats_per_ori))=poissrnd(true_tcs(:,i));
        ori(j+((i-1)*number_of_repeats_per_ori))=ori_tot(i);
    end
end
end
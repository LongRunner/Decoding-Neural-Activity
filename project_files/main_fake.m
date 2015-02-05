clear all;

%parameters....
n_neurons=75;
sigma=(20*pi)/n_neurons;
max_fixing_rate=.5;
stim_grid=linspace(0,2*pi,n_neurons);
n_trials=50;
epsilon=inv(n_trials);
proportion=.90;
repeat=1;
s.rand_a=1; %tcs with random amplitudes????

%spaces the preferred response from 0 to 355 degres, converted to
    %radians...
ori_tot=0:5*(pi/180):2*pi-5*(pi/180);

%safer to add epsilon after fake data is generated, since some est_tcs can
    %have zero firing, even though the tcs_true had a minimium firing rate
    %of epsilon to begin with...
tcs_true=tc_function(stim_grid,ori_tot,sigma,max_fixing_rate-epsilon,s);
[spk_x,ori]=generate_fake_data(tcs_true,ori_tot,n_trials);
tcs_true=tcs_true+epsilon;
spk_x=spk_x+epsilon;

[training_ori,training_spk_count,testing_ori,testing_spk_count]=split_data(spk_x,proportion,ori,ori_tot);
tcs_est=get_tcs(training_spk_count,training_ori,ori_tot);
% 
% for i=1:size(tcs_est,1)
%     plot(tcs_est(i,:))
%     %ylim([0 100]);
%     pause(.2)
% end

error_array=[];
error_ori=[];
for i = 1:repeat
    [error_temp,ori_temp] = crack_the_code(testing_spk_count,testing_ori,ori_tot,tcs_est,0,1);
    error_array=cat(2,error_array,error_temp);
    error_ori=cat(2,ori_temp,error_ori);
end

figure
hist(error_array,50)

figure
bar(ori_tot,get_mean_error_at_each_ori(error_array,error_ori,ori_tot));
title('avg error @ each ori');xlabel('orientation');ylabel('error');
axis tight;

figure
bar(ori_tot,get_std_error_at_each_ori(error_array,error_ori,ori_tot));
title('std of error @ each ori');xlabel('orientation');ylabel('error');
axis tight;

error_mean=get_mean_error_at_each_ori(error_array,error_ori,ori_tot);
error_std=get_std_error_at_each_ori(error_array,error_ori,ori_tot);
%save('p_75_r_1000.mat','error_array','error_ori','error_mean','error_std');

figure
%plot the data
subplot(1,2,1)
plot(error_ori',error_array','ok','MarkerFaceColor','k')
xlabel('ori');ylabel('error(mle-ori)');title('error vs ori');

%now divide into 3 clusters using k-means
IDX = kmeans(error_array',3,'dist','city','replicates',20);

%plot the k-means results
subplot(1,2,2)
scatter(error_ori',error_array',50,IDX,'filled')
xlabel('ori');ylabel('error(mle-ori)');title('error vs ori clustered');

clear all;
load('array_4.mat');

proportion=.90;
epsilon=inv(n_trial);

%returns spike counts from 100ms to 1280ms after stimulus presentation
spk_count=spkTime_to_spkCount(spk_times);

%pick 74 neurons with the highest mean firing rate
spk_count_mean=mean(spk_count,2);
% DONT FORGET TO CHANGE THE NUMBER OF NEURONS TO SELECT....................
for threshold = 0:.001:6 if length(spk_count_mean(threshold<spk_count_mean))==74 break; end; end;
spk_count=spk_count(threshold<spk_count_mean,:);

[training_ori,training_spk_count,testing_ori,testing_spk_count]=split_data(spk_count,proportion,ori,ori_tot);

repeat=1;
%%    PID

pid_error=[];
true_ori=[];
for i = 1:repeat
    [training_ori,training_spk_count,testing_ori,testing_spk_count]=split_data(spk_count,proportion,ori,ori_tot);
    tcs_est=get_tcs(training_spk_count,training_ori,ori_tot);
    tcs_est(find(tcs_est==0))=epsilon;
    [error_temp,true_ori] = crack_the_code(testing_spk_count,testing_ori,ori_tot,tcs_est,0,0);
    pid_error=cat(2,pid_error,error_temp);
    true_ori=cat(2,true_ori,true_ori);
end

figure;
%pid_error=pid_error(-220<pid_error & pid_error<220);
hist(pid_error,50);title('PID errors');


%%    Graf Multiclass SVM
svm_error_graf=[];

for i = 1:repeat
    [training_ori,training_spk_count,testing_ori,testing_spk_count]=split_data(spk_count,proportion,ori,ori_tot);
    training_ori=training_ori';
    training_spk_count=training_spk_count';
    testing_ori=testing_ori';
    testing_spk_count=testing_spk_count';
    ll=graf_multisvm(training_spk_count,training_ori,testing_spk_count);
    [~,ind]=min(ll,[],2);
    mle = ori_tot(ind);
    svm_error_graf=cat(2,svm_error_graf,mle-testing_ori');
end

figure;
%svm_error_graf=svm_error_graf(-220<svm_error_graf & svm_error_graf<220);
hist(svm_error_graf,50);
title('Graf SVM errors');


%%    ISM Multiclass SVM

svm_error_ism=[];
for i = 1:repeat
    [training_ori,training_spk_count,testing_ori,testing_spk_count]=split_data(spk_count,proportion,ori,ori_tot);
    training_ori=training_ori';
    training_spk_count=training_spk_count';
    testing_ori=testing_ori';
    testing_spk_count=testing_spk_count';
    svm_ori=multisvm(training_spk_count,training_ori,testing_spk_count);
    svm_error_ism=cat(2,svm_error_ism,svm_ori-testing_ori');
end


%svm_error_ism=svm_error_ism(-220<svm_error_ism & svm_error_ism<220);
figure;
hist(svm_error_ism,50); title('ism svm errors');

%%
display(sprintf('pid svm stats: mean error-> %.1f std error-> %.1f\n',mean(pid_error),std(pid_error)))
display(sprintf('graf svm stats: mean error-> %.1f std error-> %.1f\n',mean(svm_error_graf),std(svm_error_graf)))
display(sprintf('ism svm stats: mean error-> %.1f std error-> %.1f\n',mean(svm_error_ism),std(svm_error_ism)))

%%
%{
clear all
cd('/Users/isaiah/Dropbox/Documents/MATLAB/j_rotation_proj/real/save_runs')
d=dir;

for j = 1:length(d)
    if (length(str2num(d(j).name))>=1)
        cd(d(j).name)
        load('error.mat')
        eval(sprintf('pid_error_%s=pid_error;',d(j).name))
        eval(sprintf('svm_error_ism_%s=svm_error_ism;',d(j).name))
        eval(sprintf('svm_error_graf_%s=svm_error_graf;',d(j).name))
        cd('..')
        clear pid_error svm_error_ism svm_error_graf;
    end
end

pid_error_5=correct(pid_error_5);
pid_error_4=correct(pid_error_4);
pid_error_3=correct(pid_error_3);
pid_error_2=correct(pid_error_2);
pid_error_1=correct(pid_error_1);

svm_error_graf_1=correct(svm_error_graf_1);
svm_error_graf_2=correct(svm_error_graf_2);
svm_error_graf_3=correct(svm_error_graf_3);
svm_error_graf_4=correct(svm_error_graf_4);
svm_error_graf_5=correct(svm_error_graf_5);

svm_error_ism_1=correct(svm_error_ism_1);
svm_error_ism_2=correct(svm_error_ism_2);
svm_error_ism_3=correct(svm_error_ism_3);
svm_error_ism_4=correct(svm_error_ism_4);
svm_error_ism_5=correct(svm_error_ism_5);

total_pid=cat(2,pid_error_5, pid_error_4, pid_error_3, pid_error_2, pid_error_1);
total_graf=cat(2,svm_error_graf_1, svm_error_graf_5, svm_error_graf_4, svm_error_graf_3, svm_error_graf_2);
total_ism=cat(2,svm_error_ism_1, svm_error_ism_5, svm_error_ism_4, svm_error_ism_3, svm_error_ism_2);

display(sprintf('pid svm stats: mean error-> %.1f std error-> %.1f',mean(abs(total_pid)),std(abs(total_pid))))
display(sprintf('graf svm stats: mean error-> %.1f std error-> %.1f',mean(abs(total_graf)),std(abs(total_graf))))
display(sprintf('ism svm stats: mean error-> %.1f std error-> %.1f\n',mean(abs(total_ism)),std(abs(total_ism))))

for i = 1:5
    display(sprintf('pid svm stats: mean error-> %.1f std error-> %.1f',mean(abs(eval(sprintf('pid_error_%i',i)))),std(abs(eval(sprintf('pid_error_%i',i)))) ))
end
display(' ')
for i = 1:5  
    display(sprintf('graf svm stats: mean error-> %.1f std error-> %.1f',mean(abs(eval(sprintf('svm_error_graf_%i',i)))),std(abs(eval(sprintf('svm_error_graf_%i',i)))) ))
end
display(' ')
for i = 1:5
    display(sprintf('ism svm stats: mean error-> %.1f std error-> %.1f',mean(abs(eval(sprintf('svm_error_ism_%i',i)))),std(abs(eval(sprintf('svm_error_ism_%i',i)))) ))
end


mat=[total_pid',total_graf',total_ism'];

[p,tbl,stats] = anova1(mat);
[c,m] = multcompare(stats)

%{
[muhat,sigmahat,muci,sigmaci]=normfit(total_pid);
[muhat,sigmahat,muci,sigmaci]=normfit(total_graf);
[muhat,sigmahat,muci,sigmaci]=normfit(total_ism);
%}

hist(total_pid,-250:5:250);title('PID errors');
xlabel('degrees');ylabel('number of occurrences');
figure
hist(total_graf,-250:5:250);title('ELD errors');
xlabel('degrees');ylabel('number of occurrences');
figure
hist(total_ism,-250:5:250);title('One vs. All errors');
xlabel('degrees');ylabel('number of occurrences');
%}


















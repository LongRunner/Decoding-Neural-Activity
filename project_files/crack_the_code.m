function [error_array,true_ori] = crack_the_code(testing_spk_count,testing_ori,ori_tot,tcs,varargin)
assert(size(testing_ori,2)==size(testing_spk_count,2),...
    'testing spikes and test ori must have same # cols');
assert(nargin<7,'only 4-6 inputs can be passed to fx');
if(nargin>4)
    %input is true or false
    conv_rad_to_degs=varargin{1};
    %input is true or false
    graphics=varargin{2};
    if(conv_rad_to_degs)
        testing_ori=radtodeg(testing_ori);
        ori_tot=radtodeg(ori_tot);
    end
    if(graphics)
        subplot(511);
        plot(ori_tot,tcs);
        title('tc all neuron');xlabel('prefered stim');ylabel('spike count');
        axis tight;
    end
else
    graphics=0;
end
error_array=[];
true_ori=[];
for i = 1:size(testing_spk_count,2)
    true_ori=testing_ori(i);
    resp_inst_rnd=testing_spk_count(:,i);
    
    ll=likelihood(resp_inst_rnd',tcs');
    [~,ind_max] = max(ll);
    mle = ori_tot(ind_max);
    error_array(i)=mle-true_ori;
    true_ori(i)=true_ori;
    
    if(graphics)
        subplot(512);
        plot(resp_inst_rnd,'-*');
        title('Rnd Resp Instance');xlabel('Neuron #');ylabel('spike count');
        axis tight;
        
        subplot(513);
        plot(ori_tot,ll);
        title('log(likelihood) vs neuron pref');xlabel('neuron pref stim');ylabel('log(likelihood)');
        axis tight;
        
        subplot(514);
        li = exp(ll-max(ll));
        plot(ori_tot,li, mle,1,'r*', true_ori*[1 1], [min(li) max(li)], 'g');
        title('likelihood');
        axis tight;
        
        subplot(515);
        hist(error_array,50);
        title('hist of decoding error');
        axis tight;
        
        display(sprintf('stim true = %.0f',true_ori));
        display(sprintf('mle = %.0f',mle));
        display(' ');
        drawnow;
    end
end
end
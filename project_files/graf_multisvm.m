function out = graf_multisvm(training_set,training_labels,test_set)
u=unique(training_labels);
options.MaxIter=92233720368;
for j=2:length(u)
    current=u(j);
    prev=u(j-1);
    labels=[training_labels(find(prev==training_labels));training_labels(find(current==training_labels))];
    training_set_selected=[training_set(find(prev==training_labels),:);training_set(find(current==training_labels),:)];
    models(j)=svmtrain(training_set_selected,labels, 'Options', options);
end
llr=zeros(size(test_set,1),numel(u));
predictions=zeros(numel(u), 1);
for j=1:size(test_set,1)
    for k=2:numel(u)
        b=models(k).Bias;
        w=models(k).SupportVectors'*models(k).Alpha;
        predictions(k)=scale_and_shift_data(models(k),test_set(j,:))*w+b;
    end
    llr(j,:)=predictions;
end
out=cumsum(llr,2);
end
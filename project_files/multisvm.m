function [result] = multisvm(TrainingSet,LabelsTrain,TestSet)
%one vs everyone else
u=unique(LabelsTrain);
options.MaxIter = 92233720368;
for k=1:length(u)
    G1vAll=(LabelsTrain==u(k));
    models(k) = svmtrain(TrainingSet,G1vAll, 'Options', options);
end
for j=1:size(TestSet,1)
    for k=1:length(u)
        b = models(k).Bias;
        w = models(k).SupportVectors'*models(k).Alpha;
        predictions(k) = scale_and_shift_data(models(k),TestSet(j,:)) * w + b;
    end
    [~,ind]=min(predictions);
    result(j) = u(ind);
    %result(j,:)=predictions';
end
end
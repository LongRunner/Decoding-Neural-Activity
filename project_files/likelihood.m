function y = likelihood(ri, tcs)
y = log(tcs)*ri' - sum(tcs,2);
%makes nan values the min real number in y
y(isnan(y)) = nanmin(y);
%makes -Inf values the min number greater then -Inf
if(length(find(y>-Inf))>=1)
    y(find(y==-Inf))=min(y(find(y>-Inf)));
end

end
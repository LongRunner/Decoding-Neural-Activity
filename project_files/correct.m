function out = correct(array)
for i = 1:length(array)
    if (array(i)>220)
        array(i)=array(i)-180;
    elseif(array(i)<-220)
        array(i)=array(i)+180;
    end
end
out=array;
end
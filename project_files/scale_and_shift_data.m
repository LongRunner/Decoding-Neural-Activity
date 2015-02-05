function out = scale_and_shift_data(m,data)
out=repmat(m.ScaleData.scaleFactor,size(data,1),1).*(data+repmat(m.ScaleData.shift,size(data,1),1));
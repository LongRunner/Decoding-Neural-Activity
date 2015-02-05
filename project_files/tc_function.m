function out = tc_function(x,u,s,a,varargin)
% Input
%   x: (N x L) or scalar
%   u: (N x L) or scalar
%   s: float
%   a: (N x L) or scalar
%   varargin{1}: struct
%                feilds: epsilon (float), rand_a  (boolean)
assert(nargin<6,'only 4-5 inputs can be passed to fx');
epsilon=0.0;
rand_a=0;
if(nargin>4)
    if isfield(varargin{1},'epsilon')
        epsilon=varargin{1}.epsilon;
    end
    if isfield(varargin{1},'rand_a')
        rand_a=varargin{1}.rand_a;
    end
end

% if x is a row vector make it a col vector
if(size(x,2)>size(x,1))
    x=x';
end

%if x's # of cols not equal to u's, then make x have a similar #
if(size(x,2)~=size(u,2))
    x=repmat(x,1,size(u,2));
end

%if u's # of rows not equal to x's, then make u have a similar #
if(size(x,1)~=size(u,1))
    u=repmat(u,size(x,1),1);
end

assert(size(x,2)==size(u,2) && size(x,1)==size(u,1),'row size of x and u must be the same');
assert(length(s)==1,'input -> s must be a scalar');

if rand_a==0
    a=a.*ones(size(x,1),size(x,2));
else
    a=(a.*repmat(rand(size(x,1),1),1,size(x,2))) + (.1.*randn(size(x,1),size(x,2)));
end


%x && u need to be in radians
out = ((a-epsilon).*exp(-sin(x-u).^2 ./ (2*s^2)))+epsilon;
out(find(out<0))=0;
end
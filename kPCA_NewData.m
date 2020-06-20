%   Y: new data martix
%   X: training data matrix, each row is one observation, each column is one feature
%   d: reduced dimension
%   type: type of kernel, can be 'simple', 'poly', or 'gaussian'
%   para: parameter for computing the 'poly' and 'gaussian' kernel, 
%       for 'simple' it will be ignored
%   Z: dimensionanlity-reduced data
%   eigVector: eigen-vector, will later be used for pre-image
%       reconstruction

function Z=kPCA_NewData(Y,X,eigVector,type,para)

K=kernel_NewData(Y,X,type,para);
Z=K*eigVector;

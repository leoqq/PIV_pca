function [ Result ] = Perform_GaussianKernelPCA( velo_data, center_index, nDimension  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



%% Data formatting
% Find No. of locations and snapshots
[ nLoc, nSnap ] = size( velo_data );

% Check whether the data need to be centered
ensemble_mean = mean( velo_data, 2 );                                       % Ensemble mean, nLoc * 1
switch center_index
    case 'Centered'
        velo_data_POD = velo_data - repmat( ensemble_mean, 1, nSnap );      % Ensemble mean is subtracted from each snapshot before conducting POD
    case 'NotCentered'
        velo_data_POD = velo_data;                                          % Use original data while conducting POD
        if ensemble_mean ~= 0
            warning( 'The input data for POD is not centered around ensemble mean, which is not recommended.' )
        end
    otherwise
        error( 'Wrong ''POD_center_index'' index. Please type ''help Perform_POD'' for detail.' )
end


% Format velocity matrix
C = [ real( velo_data_POD ); imag( velo_data_POD ) ];                       % Rows: Locations * 2, Columns: Snapshots



%% Gaussian kernel PCA

DIST=distanceMatrix(C);
DIST(DIST==0)=inf;
DIST=min(DIST);
para=5*mean(DIST);



disp('Performing Gaussian kernel PCA...');
[K0, eigVector]=kPCA(C,'gaussian',para);


KPCA_DimensionReduced = zeros( nLoc, nSnap, length(nDimension) );
% dimensionality reduction
for jj = 1:length(nDimension)
    fprintf( 'Dimension = %.0f \n', nDimension(jj) )
    reduced_eigVector = eigVector( :, 1:nDimension(jj) );
    reduced_Y = K0*reduced_eigVector;
    
    % pre-image reconstruction for Gaussian kernel PCA
    disp('Performing kPCA pre-image reconstruction...');
    PI=zeros(size(C)); % pre-image
    parfor i=1:size(C,1)
        PI(i,:)=kPCA_PreImage(reduced_Y(i,:)',reduced_eigVector,C,para)';
    end
    
    KPCA_DimensionReduced(:,:,jj) = complex(PI( 1 : nLoc , : ), ... 
           PI( ( nLoc + 1 ) : end , : ) );                            % Express real number modes in complex form  
       
end



%% Outputs
Result.nDimension = nDimension;
Result.CenterIndex = center_index;
Result.EnsembleMean = ensemble_mean; 
Result.eigVector = eigVector;
Result.K0 = K0;
Result.KPCA_DimensionReduced = KPCA_DimensionReduced;

end


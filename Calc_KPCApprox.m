function [ PODApprox ] = Calc_KPCApprox( PODResult, nModes, CycleNo, nRowsInOriginal, nColsInOriginal, IndexInOriginal )
%UNTITLED4 Summary of this function goes here orignial
%   Detailed explanation goes here

switch PODResult.CenterIndex
    case 'Centered'
      %   KPCAresults=sum(PODResult.KPCA,2);     
     
          KPCAresults=PODResult.KPCA;    
          PODcumsum = KPCAresults + PODResult.EnsembleMean;        
end

PODApprox.U = nan( nRowsInOriginal, nColsInOriginal, 1, length( CycleNo ) );
PODApprox.V = nan( nRowsInOriginal, nColsInOriginal, 1, length( CycleNo ) );
for jj = 1 : length(CycleNo)
    PODApprox.U(:,:,1,jj) = Convert_PODFormat( real( PODcumsum(:,jj) ), 'POD2Original', nRowsInOriginal, nColsInOriginal, IndexInOriginal );
    PODApprox.V(:,:,1,jj) = Convert_PODFormat( imag( PODcumsum(:,jj) ), 'POD2Original', nRowsInOriginal, nColsInOriginal, IndexInOriginal );
end

end


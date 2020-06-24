function [ PODApprox ] = Calc_PODApprox( PODResult, nModes, CycleNo, nRowsInOriginal, nColsInOriginal, IndexInOriginal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

switch PODResult.CenterIndex
    case 'Centered'
        if mod( nModes, 1 ) == 0 && nModes > 0 && nModes <= PODResult.nMode
            PODcumsum = PODResult.Mode( :, 1:nModes ) * PODResult.Coeff( 1:nModes, : ) + PODResult.EnsembleMean;
        elseif nModes == 0
            PODcumsum = PODResult.EnsembleMean;
        else
            error( 'Invalid nModes' )
        end
    case 'NotCentered'
        if mod( nModes, 1 ) == 0 && nModes > 0 && nModes <= PODResult.nMode
            PODcumsum = PODResult.Mode( :, 1:nModes ) * PODResult.Coeff( 1:nModes, : );
        elseif nModes == 0
            error( 'nModes = 0 is not supported when the POD is performed on a non-centered data.' )
        else
            error( 'Invalid nModes' )
        end
end

PODApprox.U = nan( nRowsInOriginal, nColsInOriginal, 1, length( CycleNo ) );
PODApprox.V = nan( nRowsInOriginal, nColsInOriginal, 1, length( CycleNo ) );
for jj = 1 : length( CycleNo )
    PODApprox.U(:,:,1,jj) = Convert_PODFormat( real( PODcumsum(:,jj) ), 'POD2Original', nRowsInOriginal, nColsInOriginal, IndexInOriginal );
    PODApprox.V(:,:,1,jj) = Convert_PODFormat( imag( PODcumsum(:,jj) ), 'POD2Original', nRowsInOriginal, nColsInOriginal, IndexInOriginal );
end

end


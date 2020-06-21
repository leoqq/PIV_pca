%%
clear 
close all
clc

%%
% myData = matfile( 'x20180810_Tumble_CR11_T2_C33_DVA_Motored_Processed.mat' );
% PODData = myData.PODData;
% Tumble_270 = load( 'TumbleCR11T2C33DVA_CA_270.mat' );

myData = matfile( 'x20190605_CrossTumble_CR11_T2_C33_DVA_Motored_Processed.mat' );
PODData = myData.PODData;

CTP_300 = load( 'CTPCR11T2C33DVA_CA_300.mat' );

%%
close all
InputResults = CTP_300;
nModes = [ 1:2:101, 299 ];
CycleNo = 11;


[ ~, CA_Index ] = ismember( InputResults.CurrentCrankAngle, PODData.CrankAngle );

% [ ~, d_Index ] = ismember( nDimension, InputResults.KPCAResult.nDimension );
% 

for m = 1 : length( nModes )
% Calculate POD approximations
POD_Approx = InputResults.PODResult.Mode( :, 1:nModes(m) ) * InputResults.PODResult.Coeff( 1:nModes(m), : ) + InputResults.PODResult.EnsembleMean;        


figure;
quiver( PODData.X{ CA_Index }, PODData.Y{ CA_Index }, real( POD_Approx( :,CycleNo ) ), imag( POD_Approx( :,CycleNo ) ), 1.5, 'b' )

title( ['POD Approx m = ', num2str( nModes(m) )] )
% axis( [ -27 27 -30 10 ] )
axis( [ -25 25 -20 5 ] )
axis equal

export_fig( [ 'CTP Cycle ', num2str( CycleNo ), ' POD Approx at -', num2str( abs( InputResults.CurrentCrankAngle ) ), ' CAD aTDCf' ], '-pdf', '-nocrop', '-append' )
close all

end

for d = 1 : length( InputResults.KPCAResult.nDimension )
KPCA_Approx = InputResults.KPCAResult.KPCA_DimensionReduced( :, :, d ) + InputResults.KPCAResult.EnsembleMean;
    
figure;    
quiver( PODData.X{ CA_Index }, PODData.Y{ CA_Index }, real( KPCA_Approx( :,CycleNo ) ), imag( KPCA_Approx( :,CycleNo ) ), 1.5, 'r' )
title( ['KPCA Approx d = ', num2str( InputResults.KPCAResult.nDimension(d) )] )
% axis( [ -27 27 -30 10 ] )
axis( [ -25 25 -20 5 ] )
axis equal
export_fig( [ 'CTP Cycle ', num2str( CycleNo ), ' KPCA Approx at -', num2str( abs( InputResults.CurrentCrankAngle ) ), ' CAD aTDCf' ], '-pdf', '-nocrop', '-append' )
close all
end
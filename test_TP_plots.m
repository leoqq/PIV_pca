clear 
close all
clc

%%
% load( 'x20180810_Tumble_CR11_T2_C33_DVA_Motored_Processed.mat' )


myData = load( 'TumbleCR11T2C33DVA_CA_270.mat' );


%%
clear figureprop cycle_No nMode_PODApprox nKernel_KPCAApprox
figureprop.axes_lim = [ -25 25 -30 10 ];
figureprop.xlabel = '{\it x} (mm)';
figureprop.ylabel = '{\it z} (mm)';

figureprop.sparse_vector = 2;
figureprop.Clim = [ 0 50 ];

cycle_No = 10;

nMode_PODApprox = [ 0 1 10 110 299 ]; %0:1:299;

nDimension_KPCAApprox = [ 1 10 110 1010 ]; %myData.KPCAResult.nDimension;

%% POD approx.
close all
for mm = 1 : length( nMode_PODApprox )
    [ PODApprox ] = Calc_PODApprox( myData.PODResult, nMode_PODApprox(mm), cycle_No, myData.PODGrid.nRowsInOriginal, myData.PODGrid.nColsInOriginal, myData.PODGrid.IndexInOriginal );
    figure_output = ColourQuiver( myData.OriginalGrid.X, myData.OriginalGrid.Y, PODApprox.U, PODApprox.V, figureprop );
    title( [ 'POD Approx., Order = ', num2str( nMode_PODApprox(mm) )] );
%     export_fig( [ 'TP Cycle ', num2str( cycle_No ), ' POD Approx at -270 CAD aTDCf' ], '-pdf', '-nocrop', '-append' )
%     close all
end


    
%% KPCA approx.
[ nDimension_KPCAApprox_plotted, ~, IndexInKPCAResults ] = intersect( nDimension_KPCAApprox, myData.KPCAResult.nDimension );
for kk = 1 : length( IndexInKPCAResults )
    temp_KPCA_field = myData.KPCAResult.KPCA_DimensionReduced(:,cycle_No,IndexInKPCAResults(kk)) + myData.KPCAResult.EnsembleMean;
    uu = Convert_PODFormat( real( temp_KPCA_field ), 'POD2Original', myData.PODGrid.nRowsInOriginal, myData.PODGrid.nColsInOriginal, myData.PODGrid.IndexInOriginal );
    vv = Convert_PODFormat( imag( temp_KPCA_field ), 'POD2Original', myData.PODGrid.nRowsInOriginal, myData.PODGrid.nColsInOriginal, myData.PODGrid.IndexInOriginal );
    
    ColourQuiver( myData.OriginalGrid.X, myData.OriginalGrid.Y, uu, vv, figureprop );
    title( [ 'KPCA Approx., Dimension = ', num2str( nDimension_KPCAApprox_plotted(kk) ) ] );
%     export_fig( [ 'TP Cycle ', num2str( cycle_No ), ' KPCA Approx at -270 CAD aTDCf' ], '-pdf', '-nocrop', '-append' )
%     close all
end


% figure
% hold on
% [cs,hc]=contourf(Xq,Rq,phiq,[550:20:2400]); %,[0:1e-4:5e-3]
% colormap('jet')
% %colorbar;
% caxis([550 2400])
% %txt = '0.70 ms';
% %text(1,8,txt,'FontSize',14)
% set(hc,'EdgeColor','none')
% shading interp;
% set(gca, 'Position',[0 0 1 1])
% % colorbar
% % caxis([600 2400])
% axis equal
% axis([0 60 -10 10])
% set(gca,'XTick',0:10:60); 
% set(gca,'YTick',-10:5:10); 
% axis off
% set(gcf, 'Units','centimeters', 'Position',[0 0 12 4]) 

% filename2 = sprintf('LESYao_temp_08ms_plane%d', i) ;
% print( filename2, '-dpng','-r600') ;
% Codes to perform PIV dimenstion reduction techniques
% Author(s): Li (Sam) Shen
% sam-li.shen@eng.ox.ac.uk
% Last updated date: 2020.04.28

%% Clean up
clear all %#ok<CLALL>
close all
clc

%% Load data
myData = matfile( 'x20180810_Tumble_CR11_T2_C33_DVA_Motored_Processed.mat' );
MaskedData = myData.MaskedData;
PODData = myData.PODData;

%% Parameters setting
AnalysisResult.CrankAngle = [ -270, -295];                                 % Change this line to allow more crank angles (avaiable from -295 to -60 CAD aTDCf)
AnalysisResult.PODApprox.nModes = 10;                                       % Change this line to include more POD components into POD approximations
AnalysisResult.PODApprox.CycleNo = 1:300;                                   % Do not change this line
AnalysisResult.KPCAApprox.Kvalue = 10;                                       % Change this line to include more POD components into POD approximations

%% POD Analysis
[ ~, AnalysisResult.CrankAngleIndex ] = ismember( AnalysisResult.CrankAngle, PODData.CrankAngle );

AnalysisResult.PODResult = cell( length( AnalysisResult.CrankAngleIndex ), 1 );
AnalysisResult.PODApprox.U = nan( PODData.nRowsInOriginal, PODData.nColsInOriginal, length( AnalysisResult.CrankAngleIndex ), length( AnalysisResult.PODApprox.CycleNo ) );
AnalysisResult.PODApprox.V = nan( PODData.nRowsInOriginal, PODData.nColsInOriginal, length( AnalysisResult.CrankAngleIndex ), length( AnalysisResult.PODApprox.CycleNo ) );

for ca_No = 1 : length( AnalysisResult.CrankAngleIndex )
    % Perform POD
    temp_velo_data = complex( PODData.U{ AnalysisResult.CrankAngleIndex( ca_No ) }, PODData.V{ AnalysisResult.CrankAngleIndex( ca_No ) } );
    temp_PODResult = Perform_POD( temp_velo_data, 'Centered', 'Direct' );
    AnalysisResult.PODResult{ ca_No } = temp_PODResult;
    
    % Calculate POD approximations and convert the result back to normal data format
    temp_PODApprox = Calc_PODApprox( temp_PODResult, AnalysisResult.PODApprox.nModes, AnalysisResult.PODApprox.CycleNo,...
                                     PODData.nRowsInOriginal, PODData.nColsInOriginal, PODData.IndexInOriginal{ AnalysisResult.CrankAngleIndex( ca_No ) } );
   
    %Calculate KPCA approximations and convert the result back to normal data format
    temp_KPCApprox = Calc_KPCApprox( temp_PODResult, AnalysisResult.KPCAApprox.Kvalue, AnalysisResult.PODApprox.CycleNo,...
                                     PODData.nRowsInOriginal, PODData.nColsInOriginal, PODData.IndexInOriginal{ AnalysisResult.CrankAngleIndex( ca_No ) } );                             
                                 
    PODApprox.U(:,:,ca_No,:) = temp_PODApprox.U;
    PODApprox.V(:,:,ca_No,:) = temp_PODApprox.V;    
    
    KPCApprox.U(:,:,ca_No,:) = temp_KPCApprox.U;
    KPCApprox.V(:,:,ca_No,:) = temp_KPCApprox.V;    
    
end
clear temp_*

PODApprox.X = MaskedData.X;
PODApprox.Y = MaskedData.Y;

%% Example plots
ExampleData.CycleNo = 9;                                                   % Change this line to examine other cycles
ExampleData.CrankAngle = -270;                                              % Change this line to examine other crank angles (must be the crank angles calculated before, defined by 'AnalysisResult.CrankAngle')

[ ~, ExampleData.CrankAngleIndex ] = ismember( ExampleData.CrankAngle, AnalysisResult.CrankAngle );

figure
hold on
box on
quiver( PODApprox.X, PODApprox.Y, PODApprox.U( :, :, ExampleData.CrankAngleIndex, ExampleData.CycleNo ), PODApprox.V( :, :, ExampleData.CrankAngleIndex, ExampleData.CycleNo )  )
axis equal
temp_axeslim = axis;
title( 'POD Approx' )

figure
hold on
box on
quiver(PODApprox.X, PODApprox.Y, KPCApprox.U( :, :, ExampleData.CrankAngleIndex, ExampleData.CycleNo ), KPCApprox.V( :, :, ExampleData.CrankAngleIndex, ExampleData.CycleNo )  )
axis equal
temp_axeslim = axis;
title( 'KPCA Approx' )


figure
hold on
box on
quiver( PODData.X{ ExampleData.CrankAngleIndex },PODData.Y{ ExampleData.CrankAngleIndex }, PODData.U{ ExampleData.CrankAngleIndex }(:,ExampleData.CycleNo),PODData.V{ ExampleData.CrankAngleIndex }(:,ExampleData.CycleNo),'m' )
axis equal
axis( temp_axeslim );
title( 'Original Data' )

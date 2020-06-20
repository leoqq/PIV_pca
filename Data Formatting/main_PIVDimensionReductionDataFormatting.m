% Codes to pre-format data before performing PIV dimenstion reduction techniques
% Author(s): Li (Sam) Shen
% sam-li.shen@eng.ox.ac.uk
% Last updated date: 2020.04.28


%% Clean up
clear all %#ok<CLALL>
close all
clc

%% Load data
myData = matfile( 'x20180810_Tumble_CR11_T2_C33_DVA_Motored.mat' );
PIVData = myData.PIVData;
Parameters = myData.Parameters;

RawData.X = PIVData.Data.x;
RawData.Y = PIVData.Data.z;
RawData.U = PIVData.Data.u;
RawData.V = PIVData.Data.w;
RawData.CrankAngle = PIVData.Data.CrankAngle;

%% Format data
[ InterpolatedData, MaskedData, PODData ] = PIVDataFormatting( RawData.X, RawData.Y, RawData.U, RawData.V, RawData.CrankAngle );

%% Check data
CheckData.CycleNo = 10;
CheckData.CrankAngle = -270;

[ ~, CheckData.CrankAngleNo_Raw ] = ismember( CheckData.CrankAngle, RawData.CrankAngle );
[ ~, CheckData.CrankAngleNo_Using ] = ismember( CheckData.CrankAngle, MaskedData.CrankAngle );

close all
figure
hold on
box on
quiver( PIVData.Data.x,PIVData.Data.z, PIVData.Data.u(:,:,CheckData.CrankAngleNo_Raw,CheckData.CycleNo),PIVData.Data.w(:,:,CheckData.CrankAngleNo_Raw,CheckData.CycleNo),'k' )

figure
hold on
box on
quiver( InterpolatedData.X,InterpolatedData.Y, InterpolatedData.U(:,:, CheckData.CrankAngleNo_Using,CheckData.CycleNo),InterpolatedData.V(:,:, CheckData.CrankAngleNo_Using,CheckData.CycleNo),'b' )
quiver( MaskedData.X,MaskedData.Y, MaskedData.U(:,:, CheckData.CrankAngleNo_Using,CheckData.CycleNo),MaskedData.V(:,:, CheckData.CrankAngleNo_Using,CheckData.CycleNo),'r' )

figure
box on
quiver( PODData.X{ CheckData.CrankAngleNo_Using },PODData.Y{ CheckData.CrankAngleNo_Using }, PODData.U{ CheckData.CrankAngleNo_Using }(:,CheckData.CycleNo),PODData.V{ CheckData.CrankAngleNo_Using }(:,CheckData.CycleNo),'m' )

%% Save data
temp_answer = questdlg( 'Do you want to save the data (into the current MATLAB working folder)',...
    'Data Saving Check', 'Save', 'Do not save', 'Do not save' );
switch temp_answer
    case 'Save'
        savepath = uigetdir;
        save( fullfile( savepath, [ matlab.lang.makeValidName( Parameters.Info.save_name ), '_Processed' ] ), 'Parameters', 'InterpolatedData', 'MaskedData', 'PODData' );
        fprintf( 'Data saved under:\n %s \n Data filename is: %s \n', savepath, [ matlab.lang.makeValidName( Parameters.Info.save_name ), '_Processed' ] )
    case 'Do not save'
        fprintf( 'Data saving is skipped by the user.' )
end

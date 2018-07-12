%%####################################################################
%  STAGE IMFT                                        Adrien Rouviere
%                          -- MESH --
%           -- �COULEMENT AUTOUR D'UN DISQUE POREUX --
%                                                   
%#####################################################################

clear all;
close all;
clc

%% 0 - Pr�chauffage

run('../SOURCES_MATLAB/SF_Start.m');

ff = 'FreeFem++ -v 0';
ffdatadir = 'WORK/'; %% to be fixed : this should be "./WORK" but some of the solvers are not yet operational
figureformat = 'png';

verbosity = 10;

%% 1 - G�n�ration MAILLAGE et BASEFLOW

Rx = 3;

% G�om�trie
Rayon = 1;
Diametre = 2*Rayon;
Epaisseur = 1/(2*Rx);
Xmin = -20*Rayon;
Xmax = 50*Rayon;
Ymax = 20*Rayon;

boxx = [-Epaisseur/2, Epaisseur/2, Epaisseur/2, -Epaisseur/2, -Epaisseur/2];
boxy = [0, 0, Rayon, Rayon, 0];

% SF_Init
it=0;
baseflow=SF_Init('mesh_Disk.edp',[Diametre Epaisseur Xmin Xmax Ymax]);

% Plot mesh initial
figure;
plotFF(baseflow,'mesh','Title',['Maillage initial du domaine de calcul'],'Xlabel',['x'],'Ylabel',['r']);
hold on;fill(boxx,boxy,'y','FaceAlpha', 0.3);hold off;

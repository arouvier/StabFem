%%####################################################################
%  STAGE IMFT                                        Adrien Rouviere
%                          -- MESH --
%           -- ÉCOULEMENT AUTOUR D'UN DISQUE POREUX --
%                                                   
%#####################################################################

clear all;
close all;
clc

%% 0 - Préchauffage

run('../SOURCES_MATLAB/SF_Start.m');
addpath ./Resultats

ff = 'FreeFem++ -v 0';
ffdatadir = 'WORK/'; %% to be fixed : this should be "./WORK" but some of the solvers are not yet operational
figureformat = 'png';

verbosity = 100;

%% 1 - Génération MAILLAGE et BASEFLOW

Rx = 3;

% Géométrie
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
%mycp(['./Resultats/*'],[ffdatadir 'BASEFLOWS/']);

% Plot mesh initial
figure;
baseflow.xlabel=('x');baseflow.ylabel=('r');
plotFF(baseflow,'mesh','title',['Maillage initial du domaine de calcul']);
hold on;fill(boxx,boxy,'y','FaceAlpha', 0.3);hold off;

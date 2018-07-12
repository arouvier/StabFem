%%####################################################################
%  STAGE IMFT                                        Adrien Rouviere
%               -- ANALYSE DE STABILIT� GLOBALE --
%           -- �COULEMENT AUTOUR D'UN DISQUE POREUX --
%                                                   
%#####################################################################

clear all;
close all;
clc

%% 0 - Pr�chauffage

run('../SOURCES_MATLAB/SF_Start.m');
addpath ./Resultats

ff = 'FreeFem++ -v 0';
ffdatadir = 'WORK/'; %% to be fixed : this should be "./WORK" but some of the solvers are not yet operational
figureformat = 'png';

verbosity = 100;

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
%mycp(['./Resultats/*'],[ffdatadir 'BASEFLOWS/']);

% Plot mesh initial
figure;
baseflow.xlabel=('x');baseflow.ylabel=('r');
plotFF(baseflow,'mesh','title',['Maillage initial du domaine de calcul']);
hold on;fill(boxx,boxy,'y','FaceAlpha', 0.3);hold off;

%% 2 - G�n�ration du BASEFLOW pour un certain Re

% Param�tres de calcul
Re_start = [10 50 100 150 200 250];
Omega = [0.];
Darcy = [1e-6];
Porosite = [0.95];

    it=it;
    for Re = Re_start
        it=it+1
        baseflow = SF_BaseFlow(baseflow,'Re',Re,'Omegax',Omega,'Darcy',Darcy,'Porosity',Porosite);
        if (mod(it,2)
            baseflow = SF_Adapt(baseflow,'Hmin',1e-7);
        end
    end

% %             --- Plot mesh intermediaire
%             baseflow.xlabel=('x');baseflow.ylabel=('r');
%             baseflow.plottitle = ['Maillage intermediaire Re = ' num2str(baseflow.Re) ' du domaine de calcul'];
%             plotFF2(baseflow,'mesh');
%             hold on;fill(boxx,boxy,'y','FaceAlpha', 0.3);hold off;
    
% Plot mesh final
figure;
baseflow.xlabel=('x');baseflow.ylabel=('r');
plotFF(baseflow,'mesh','title',['Maillage final du domaine de calcul']);
hold on;fill(boxx,boxy,'y','FaceAlpha', 0.3);hold off;

% Plot ux
figure;
baseflow.xlabel=('x');baseflow.ylabel=('r');
plotFF(baseflow,'ux','Contour','on','Levels',[0,1e-50],'title',['Champ de vitesse u_x pour Re = ' num2str(baseflow.Re)],'ColorMap','parula');
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot ur
figure;
plotFF(baseflow,'ur','title',['Champ de vitesse u_r pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot uphi
figure;
plotFF(baseflow,'uphi','title',['Champ de vitesse u_\phi pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot P
figure;
plotFF(baseflow,'p','title',['Champ de pression P pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot Vorticit�
figure;
plotFF(baseflow,'vort','title',['Champ de vorticit� \omega pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot Lignes de courant
figure;
plotFF(baseflow,'psi','Contour','on','Levels',50,'title',['Lignes de courant pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

%% 3 - Spectrum exploration

% first exploration for m=1
[ev1,em1] = SF_Stability(baseflow,'m',1,'shift',1-.5i,'nev',20,'PlotSpectrum','yes');
[ev2,em2] = SF_Stability(baseflow,'m',1,'shift',1,'nev',20,'PlotSpectrum','yes');
[ev3,em3] = SF_Stability(baseflow,'m',1,'shift',1+.5i,'nev',20,'PlotSpectrum','yes');

figure;
plot(real(ev1),imag(ev1),'+',real(ev2),imag(ev2),'+',real(ev3),imag(ev3),'+');
title(['spectrum for m=1, Re=' num2str(baseflow.Re) ', Omega=' num2str(Omega) ', Porosity=' num2str(Porosite)])

%% 4 - Sability curves

Re_LIN = [80 : 2 : 95];

baseflow=SF_BaseFlow(baseflow,'Re',80);
[ev,em] = SF_Stability(baseflow,'m',1,'shift',ev1(1),'nev',1);
lambda1_LIN=[];
    for Re = Re_LIN
        baseflow = SF_BaseFlow(baseflow,'Re',Re);
        [ev,em] = SF_Stability(baseflow,'nev',1,'shift','cont');
        lambda1_LIN = [lambda1_LIN ev];
    end    

baseflow=SF_BaseFlow(baseflow,'Re',80);
[ev,em]=SF_Stability(baseflow,'m',1,'shift',ev2(1),'nev',1);
lambda2_LIN=[];
    for Re = Re_LIN
        baseflow = SF_BaseFlow(baseflow,'Re',Re);
        [ev,em] = SF_Stability(baseflow,'nev',1,'shift','cont');
        lambda2_LIN = [lambda2_LIN ev];
    end   
    
baseflow=SF_BaseFlow(baseflow,'Re',80);
[ev,em]=SF_Stability(baseflow,'m',1,'shift',ev3(1),'nev',1);
lambda3_LIN=[];
    for Re = Re_LIN
        baseflow = SF_BaseFlow(baseflow,'Re',Re);
        [ev,em] = SF_Stability(baseflow,'nev',1,'shift','cont');
        lambda3_LIN = [lambda3_LIN ev];
    end   

figure();
plot(Re_LIN,real(lambda1_LIN),'b+-',Re_LIN,real(lambda1_LIN),'r+-',Re_LIN,real(lambda3_LIN),'b+-');
xlabel('Re');ylabel('$\sigma$','Interpreter','latex');
% box on; pos = get(gcf,'Position'); pos(4)=pos(3);set(gcf,'Position',pos); % resize aspect ratio
% set(gca,'FontSize', 18);
saveas(gca,'PorousDisk_sigma_Re',figureformat);

figure();hold off;
plot(Re_LIN,imag(lambda1_LIN),'b+-',Re_LIN,imag(lambda1_LIN),'r+-',Re_LIN,imag(lambda3_LIN),'b+-');
xlabel('Re');ylabel('$\omega$','Interpreter','latex');
% box on; pos = get(gcf,'Position'); pos(4)=pos(3);set(gcf,'Position',pos); % resize aspect ratio
% set(gca,'FontSize', 18);
saveas(gca,'PorousDisk_omega_Re',figureformat);    

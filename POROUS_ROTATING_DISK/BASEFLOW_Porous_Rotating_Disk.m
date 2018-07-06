%%####################################################################
%  STAGE IMFT                                        Adrien Rouviere
%                         -- BASEFLOW --
%           -- ÉCOULEMENT AUTOUR D'UN DISQUE POREUX --
%                                                   
%#####################################################################

clc;

%% 2 - Génération du BASEFLOW pour un certain Re

% Paramètres de calcul
Re_start = [10 50 100 150 200 250];
Omega = [0.];
Darcy = [1e-6];
Porosite = [0.95];

    it=it;
    for Re = Re_start
        it=it+1
        baseflow = SF_BaseFlow(baseflow,'Re',Re,'Omegax',Omega,'Darcy',Darcy,'Porosity',Porosite);
        if (mod(it,3)
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

% Plot Vorticité
figure;
plotFF(baseflow,'vort','title',['Champ de vorticité \omega pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;

% Plot Lignes de courant
figure;
plotFF(baseflow,'psi','Contour','on','Levels',50,'title',['Lignes de courant pour Re = ' num2str(baseflow.Re)]);
hold on;plot(boxx, boxy, 'w-');hold off;
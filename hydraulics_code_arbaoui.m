clear all;
tic;
N_cycle = 100;
% Donn�es relatives au camion
Mv = 2250; % Masse � vide [kg]
Mp = 3500; % Masse charge pleine [kg]
G = 10; % Pesenteur [m/s^2]
A = 7; % Surface frontale
Mva = 1.292; % Masse volumique de l'aire [Kg/m^3]
Ca = 0.8; % Coeff de r�sistance � l'air
Cr = 0.015; % Coeff de frottement des roues
Ntr = 72; % Rendement de la transmission [%]
% Donn�es relatives au cycle de fonctionnement
% 1) Distance de convoyage
Dconv_min = 2000; % Distance de convoyage minimale [m]
Dconv_max = 5000; % Disance de convoyage maximale [m]
Dconv_moy = (Dconv_min+Dconv_max)/2; % Distance moyenne de convoyage 
Dconv_ecart = 500; % Ecart type de la distance de convoyage
% 2) Vitesse de convoyage
Vconv_min = 20; % Vitesse de convoyage minimale [km/h]
Vconv_max = 50; % Vitesse de convoyage maximale [km/h]
Vconv_moy = (Vconv_min+Vconv_max)/2; % Vitesse moyenne de convoyage 
Vconv_ecart = 5; % Ecart type de la Vitesse de convoyage
% 3) Vitesse de travail
Vtrav_min = 10; % Vitesse de travail minimale [km/h]
Vtrav_max = 15; % Vitesse de travail maximale [km/h]
Vtrav_moy = (Vtrav_min+Vtrav_max)/2; % Vitesse moyenne de travail 
Vtrav_ecart = 0.83; % Ecart type de la Vitesse de travail
% 4) Distance de travail
Dtrav_min = 28; % Distance de travail minimale [m]
Dtrav_max = 66; % Distance de travail maximale [m]
Dtrav_moy = (Dtrav_min+Dtrav_max)/2; % Distance moyenne de travail 
Dtrav_ecart = 6.33; % Ecart type de la Distance de travail
% 5) Temps de ramassage � l'arr�t du camion
Tram_min = 35; % Temps de ramassage minimal [s]
Tram_max = 50; % Temps de ramassage maximal [s]
Tram_moy = (Tram_min+Tram_max)/2; % Temps de ramassage moyen
Tram_ecart = 2.5; % Ecart type du Temps de ramassage
% 6) Poids d'une poubelle
PB_min = 12; % Poids d'une poubelle minimal [kg]
PB_max = 28; % Poids d'une poubelle maximal [kg]
PB_moy = (PB_min+PB_max)/2; % Poids d'une poubelle moyen
PB_ecart = 2.67; % Ecart type du Poids d'une poubelle
% 7) Pente de la route
PR_min = -8; % Pente de la route minimale [%]
PR_max = 8; % Pente de la route maximale [%]
PR_moy = (PR_min+PR_max)/2; % Pente de la route moyenne
PR_ecart = 2.67; % Ecart type de la Pente de la route
Pmoy = double(zeros(1,N_cycle));
TR=double(zeros(1, 6e3));
D_reel=double(zeros(1, 6e3));
V_reel=double(zeros(1, 6e3));
A_reel=double(zeros(1, 6e3));
MRC=double(zeros(1, 6e3));
PR=double(zeros(1, 6e3));
Fac=double(zeros(1, 6e3));
Fr=double(zeros(1, 6e3));
Fg=double(zeros(1, 6e3));
Fai=double(zeros(1, 6e3));
Ft=double(zeros(1, 6e3));
Ft_sim=double(zeros(1, 6e3));
V_R=double(zeros(1, 6e3));
Tme=double(zeros(1, 6e3));
Pis=double(zeros(1, 6e3));
V_reel1 = double(zeros(1, 6e3));
for z = 1:N_cycle
  % II  G�n�ration des param�tres de fonctionnement al�atoire
  % 1) Camion en mode de transfert initial : mode 1
  Pas_tps = 1; % Pas du temps
  TR(1) = 0;
  D_reel(1) = 0;
  V_reel(1) = 0;
  A_reel(1) = 0;
  MRC(1) = Mv;
  PR(1) = normrnd(PR_moy,PR_ecart);
  Dconv_reel = normrnd(Dconv_moy,Dconv_ecart);
  i = 2;
  while (D_reel(i-1)< Dconv_reel) 
        V_reel(i) = normrnd(Vconv_moy,Vconv_ecart);
        TR(i) = TR(i-1)+Pas_tps;
        D_reel(i) = D_reel(i-1)+Pas_tps*(V_reel(i)*1000/3600);
        A_reel(i) = ((V_reel(i)-V_reel(i-1))*1000/3600)/Pas_tps;
        MRC(i) = Mv;
        PR(i) = normrnd(PR_moy,PR_ecart);
        i=i+1;
  end
  V_reel(i-1) = 0;
  A_reel(i-1) = ((V_reel(i-1)-V_reel(i-2))*1000/3600)/Pas_tps;
  % 2) Camion en mode collecte : mode 2
  Mc = Mv;
  i=i-1;
  %F1 = size(1, ii);
  while(Mc < Mp)
        Tram_reel = normrnd(Tram_moy,Tram_ecart);
        IT = TR(i);
        while (TR(i)-IT < Tram_reel)
            i = i+1;
            TR(i)=TR(i-1)+Pas_tps;
            V_reel(i) = 0;
            D_reel(i) = D_reel(i-1);
            A_reel(i) = ((V_reel(i)-V_reel(i-1))*1000/3600)/Pas_tps;
            MRC(i) = Mc;
            PR(i) = PR(i-1);
        end
        ii=i-1;
        PB_reel = normrnd(PB_moy,PB_ecart);
        Mc = Mc+PB_reel;
        if (Mc >= Mp) break;
        else
            Dtrav_reel = normrnd(Dtrav_moy,Dtrav_ecart);
            Distance = D_reel(i)+Dtrav_reel;
            while (D_reel(i)< Distance) 
                i = i+1;
                V_reel(i) = normrnd(Vtrav_moy,Vtrav_ecart);
                TR(i) = TR(i-1)+Pas_tps;
                D_reel(i) = D_reel(i-1)+Pas_tps*(V_reel(i)*1000/3600);
                A_reel(i) = ((V_reel(i)-V_reel(i-1))*1000/3600)/Pas_tps;
                MRC(i) = Mc;
                PR(i) = normrnd(PR_moy,PR_ecart);
            end
        end
    end
    % 3) Camion en mode de transfert final : mode 3
    i = i-1;
    Dconvf_reel = normrnd(Dconv_moy,Dconv_ecart);
    Distance = D_reel(i)+Dconvf_reel;
    while (D_reel(i)< Distance) 
         i = i+1;
         V_reel(i) = normrnd(Vconv_moy,Vconv_ecart);
         TR(i) = TR(i-1)+Pas_tps;
         D_reel(i) = D_reel(i-1)+Pas_tps*(V_reel(i)*1000/3600);
         A_reel(i) = ((V_reel(i)-V_reel(i-1))*1000/3600)/Pas_tps;
         MRC(i) = Mc;
         PR(i) = normrnd(PR_moy,PR_ecart);
    end
    V_reel(i) = 0;
    A_reel(i) = ((V_reel(i)-V_reel(i-1))*1000/3600)/Pas_tps;
    % III  Calculs des efforts et de la puissance du camion
    V_reel1(1:i) = V_reel(1:i)*(1000/3600);
    Fac(1:i) = MRC(1:i).*A_reel(1:i);
    Fr(1:i) = Cr*G*MRC(1:i).*cos(atan(PR(1:i)/100));
    Fg(1:i) = G*MRC(1:i).*sin(atan(PR(1:i)/100));
    Fai(1:i) = 0.5*Mva*A*Ca*(V_reel1(1:i).^2);
    Ft(1:i) = Fac(1:i)+Fr(1:i)+Fg(1:i)+Fai(1:i);
    Ft_sim(1:i) = Ft(1:i)';
    V_R(1:i) = V_reel1(1:i)';
    Tme(1:i) = TR(1:i)';
    Pis(1:i)= V_R(1:i).*Ft_sim(1:i);
    Pmoy(z)=mean(Pis(1:i));
    %% affichage des résultats %%%%%
%    figure(1); 
%    %subplot(3,2,1);
%    plot(TR,V_reel);
%    grid;
%    title('profil de la vitesse');
%    xlabel('T');
%    ylabel('V');
%    figure(2); 
%    %subplot(3,D_reel2,2);
%    plot(TR,D_reel);
%    grid;
%    title('Distance');
%    xlabel('T');
%    ylabel('D');
%    figure(3); 
%    %subplot(3,2,3);
%    plot(TR,A_reel);
%    grid;
%    title('Acc�leration du camion');
%    xlabel('T');
%    ylabel('A');
%    figure(4); 
%    %subplot(3,2,4);
%    plot(TR,MRC);
%    grid;
%    title('Masse du camion');
%    xlabel('T');
%    ylabel('M');
%    figure(5);  
%    %subplot(3,2,5);
%    plot(TR,PR);
%    title('pente');
%    grid;
%    xlabel('T');
%    ylabel('P');
%    figure(6);  
%    %subplot(3,2,6);
%    plot(TR,Ft);
%    title('Force');
%    grid;
%    xlabel('T');
%    ylabel('F');
end
toc

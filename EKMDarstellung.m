function [] = EKMDarstellung(EKM, name, ex, eem)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

multiplier = eem(1,1)*10^-1;
em = EKM(1,2:end);
konz= EKM(2:end,1)/multiplier;
intensitaet = EKM(2:end,2:end);

mesh(em, konz, intensitaet);

%dim = [.2 .8 .5 .5];
%str = {strcat('Excitation: ', num2str(ex), 'nm')};

%annotation('textbox',dim,'String',str,'FitBoxToText','on');
xlabel('Emission [nm]');
switch multiplier
    case 10^-3
        ylabel('Cocnentration [mM]');
    case 10^-6
        ylabel('Concentration [µM]');
    case 10^-9
        ylabel('Concentration [nM]');
end      

zlabel('Intensity [AU]');
title(strcat('Emission-Concentration of:',{' '},name))
view(45,45)
end

%size zeige
function [] = multiPlotter(struct)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Max = struct(1).globalMax;

%% Concentraion-Intensity Dependency of Steady State Fluorescence
subplot(3,4,1)
darstellungKIVektor(struct(Max).ci, struct(Max).name,...
    struct(Max).emissionMaximum, struct(Max).excitationMaximum,... 
    struct(Max).exEEM(:,:));

%% EEM Mesh
subplot(3,4,4)

M = struct(Max).exEEM(2:end, 2:end);

mesh(struct(Max).emission, struct(Max).excitation, M','edgecolor', 'k');
xlabel("Emission [nm]");
ylabel("Excitation [nm]");
zlabel("Intensity [AU]");
title(strcat(struct(Max).name,", Mesh Diagram"));
view(45,45)


%% Fluorescence Spectrum
subplot(3,4,[2,3])
plot(struct(Max).emission, struct(Max).fluorescenceSpectrum, 'k');
xlabel("Emission [nm]");
ylabel("Intensity [AU]");
title(strcat("Fluorescence Spectrum \lambda_X=", ...
    num2str(struct(Max).excitationMaximum),"nm"));
grid minor
%% Excitation Spectrum
subplot(3,4,[8,12])
plot(struct(Max).excitationSpectrum, struct(Max).excitation, 'k');
xlabel("Intensity [AU]");
ylabel("Excitation [nm]");
title(strcat("Excitation Spectrum \lambda_E=", ...
    num2str(struct(Max).emissionMaximum),"nm"));
grid minor
%% Absorption Spectrum
subplot(3,4,[5,9])
plot(struct(Max).excitationSpectrum./10000, struct(Max).excitation, 'k');
set(gca, 'XDir','reverse')
xlabel("Absorption [AU]");
ylabel("Wavelength [nm]");
title("Absorption Spectrum");
grid minor

%% EEM Contour
subplot(3,4,[6,7,10,11])

M = struct(Max).exEEM(2:end, 2:end,end);

contourf(struct(Max).emission,...
    struct(Max).excitation, M','ShowText' , 'on');
colormap(flipud(gray(256)))
grid minor
caxis([0,10000]) %Minimum and Maximum Threshold
xlabel("Emission [nm]");
ylabel("Excitation [nm]");
%colorbar;
title(strcat(struct(Max).name,", Contour Diagram at Concentration: ",...
    num2str(struct(Max).concentration)," M"));

end


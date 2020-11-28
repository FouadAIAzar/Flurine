function [] = plotContourEEM(EEM, name)
%Plots EEMs
%   plots all matrices from JASCO
%Data files must contain in the first row excitation (EX) the first coloumn emission (EM)
[dimx,dimy,dimz] = size(EEM);

%if (removeRayleigh == 'true')
%    for k=1:dimz
%        for j = 2:dimy
%            for i = 2:dimx
%                if(i==j)
%                    EEM(i,j,k) = 0;
%                    EEM(i+1,j,k) = 0;
%                end
%            end
%        end
%    end
%end

    

h = [];
for k = 1:dimz
    EX = EEM(1,2:end,1);
    EM = EEM(2:end,1,1);
    M = EEM(2:end, 2:end,k);
    
    figure(k)
    contourf(EM, EX, M',20);
    xlabel('Emission [nm]');
    ylabel('Excitation [nm]');
    colorbar;
    title(name);
    h(k) = figure(k);
    
    
    %figure(k+1)
    %contour(EM, EX, M',20);
    %xlabel('Emission [nm]');
    %ylabel('Excitation [nm]');
    %colorbar;
    %zlabel('Intensity [AU]');
    %title(strcat('EEM of', name));
    %h(k+1) = figure(k+1)
    
    figure(k+1)
    mesh(EM, EX, M');
    xlabel('Emission [nm]');
    ylabel('Excitation [nm]');
    zlabel('Intensity [AU]');
    title(name);
    view(45,45)
    h(k+1) = figure(k+1);
    
%    savefig(h(k),strcat(name,'_1.fig'));
%    saveas(h(k),strcat(name,'_1.jpg'));
%    savefig(h(k+1),strcat(name,'_2.fig'));
%    saveas(h(k+1),strcat(name,'_2.jpg'));
    
%     
%     counter = 1;
%     figure(k+3)
%     for i = 1: dimx-1
%         for j = 1:dimy-1
%             if(EX(j) == EM(i)-5)
%                 rayleigh(counter) = [M(i+1,j)'];
%                 counter = counter +1;
%             end
%         end
%     end
%     if(length(EX) > length(EM))
%         plot(EM,rayleigh(1:length(EM)-1,1:length(EM)-1))
%         xlabel('wavelength [nm]')
%         ylabel('Intensity [AU]')
%     else
%         plot(EX,rayleigh)
%         xlabel('wavelength [nm]')
%         ylabel('Intensity [AU]')
%         title(strcat('Rayleigh of', name));
%     end
%     legend


end
end


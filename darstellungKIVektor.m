function darstellungKIVektor(KI, name, em, ex, eem)
% darstellungKIVektor nimmt einen Konuentration-Intensitï¿½tsvektor und
% macht einen 2D-Plot und mit dem Titel-name und stellt dazu auch eine
% Trendlinie dar

%% Plot Data 2D
digits(2)
multiplier = eem(1,1)*10^-1;
x = KI(:,1)/multiplier;
y = KI(:,2);

plot(x,y,'.','Color', 'k');

switch multiplier
    case 10^-3
        xlabel('Concentration [mM]');
    case 10^-4
        xlabel('Concentration [mM]');
    case 10^-5
        xlabel('Concentration [mM]');    
    case 10^-6
        xlabel('Concentration [µM]');
    case 10^-7
        xlabel('Concentration [µM]');
    case 10^-8
        xlabel('Concentration [µM]');    
    case 10^-9
        xlabel('Concentration [nM]');
    case 10^-10
        xlabel('Concentration [pM]');
    case 10^-11
        xlabel('Concentration [pM]');
    case 10^-12
        xlabel('Concentration [pM]');    
    case 1
        xlabel('Concentration [M]');
end  

ylabel('Intensity [AU]');
title(strcat('Concentration-Intensity')) %newline, name, ' bei Emission' 
    %num2str(em), 'nm und Excitation ', num2str(ex),'nm'));

hold on

%% Trendlinie

p = polyfit(x,y,1);
yfit = p(1)*x + p(2);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1)* var(y);
rsq = 1-SSresid/SStotal;
Y = polyval(p,x);
plot(x,Y,'k')

dim = [.2 .28 .5 .5];
str = {strcat('R^2: ', num2str(rsq))};

annotation('textbox',dim,'String',str,'FitBoxToText','on');

digits(2)

legend(strcat(name,' measured'), strcat('Trendline:',' ',...
    num2str(round(p(1))), 'x + (', num2str(round(p(2))),')'),...
    'Location', 'northwest' );
grid minor

hold off
end
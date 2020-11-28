function [KIvektor,p] = KISuchFunktion(eem,EM,EX)
% KISuchFunktion nimmt die Matrizen "Sammlung", sucht nach der Intensität 
% entsprechend der vom Benutzer gebenen Emission(EM) und Excitation (EX) 
% aller Matrizen. 

%% Definiere Grundparameter
KIvektor = []; %Worin alle Konzentrationen und Int. gespeichert werden
[dx,dy,dz] = size(eem); %nimmt x,y und z größe der Matrix sammlung

for i = 1:dz
   index_EX = find(eem(1,2:end,i) == EX);
   index_EM = find(eem(2:end,1,i) == EM);
   KIvektor(i,1) = eem(1,1,i);
   KIvektor(i,2) = eem(index_EM,index_EX,i);
end

multiplier = eem(1,1)*10^-1;
x = KIvektor(:,1)/multiplier;
y = KIvektor(:,2);

p = polyfit(x,y,1);
yfit = p(1)*x + p(2);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1)* var(y);
rsq = 1-SSresid/SStotal;
Y = polyval(p,x);
end


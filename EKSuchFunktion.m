function EKM = EKSuchFunktion(eem,EX)
% KISuchFunktion nimmt die Matrizen "Sammlung", sucht nach der Intensität 
% entsprechend der vom Benutzer gebenen Emission(EM) und Excitation (EX) 
% aller Matrizen. 

%% Definiere Grundparameter

[dx,dy,dz] = size(eem); %nimmt x,y und z größe der Matrix sammlung
em_spektrum = struct.emission;
EKM = [dz+1,dx]; %Worin alle Konzentrationen und Emissionen gespeichert werden

for k = 1:dz
   index_EX = find(eem(1,:,k) == EX);
   EKM(k+1,2:dx) = eem(2:end,index_EX,k)';
   EKM(k+1,1) = eem(1,1,k);
end
EKM(1,1) = nan;
EKM(1,2:end) = em_spektrum';
end


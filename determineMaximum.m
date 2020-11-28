function [emIndex,exIndex,emIndexMax, exIndexMax, k] = ...
    determineMaximum(eem)
% Determine Maximum Emission and Excitation Wavelengths
trueMax = 0;
for k=1:size(eem,3)
    tempMax = max(max(eem(2:end,2:end,k)));
    [emIndex(k),exIndex(k)] =  find(eem(2:end,2:end,k) == tempMax);
        emIndex(k)=emIndex(k)+1;
        exIndex(k)=exIndex(k)+1;
        
        if tempMax > trueMax
            trueMax = tempMax;
            [emIndexMax,exIndexMax] =  find(eem(2:end,2:end,k) == trueMax);
            emIndexMax=emIndexMax+1;
            exIndexMax=exIndexMax+1;
            eemIndexMax = k; %Only for the purpose of plotting, perhaps
        end
end        
end


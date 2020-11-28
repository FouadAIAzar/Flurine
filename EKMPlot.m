function [sammlung, KI] = EKMPlot(name,DIR,EX)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
[sammlung,multiplier] = importEEM(DIR);
EKM = EKSuchFunktion(sammlung, EX);
EKMDarstellung(EKM,name,EX,multiplier);
end


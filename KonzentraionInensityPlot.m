function [sammlung, KI] = KonzentraionInensityPlot(name,DIR,EM,EX)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
[sammlung,multiplier] = importEEM(DIR);
KI = KISuchFunktion(sammlung, EM, EX);
darstellungKIVektor(KI,name,EM, EX);
end


function [] = absorptionsDarstellung(M)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for k=1:size(M,3)
    X = M(:,1,k);
    Y = M(:,2,k);
    plot(X,Y);
    xlabel("Wellenlänge")
    ylabel("Absorbanz [AU]")
    xlabel("Wellenlänge [nm]")
    title("6eezi")
    hold on
end
end


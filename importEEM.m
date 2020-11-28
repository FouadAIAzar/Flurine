
function [Sammlung, multi] = importEEM(DIR, dataLines)
%importEEM:
% Diese Funktion importiert alle .txt Dateien aus einem Ordner und packt sie
% zusammen in einer Variable "Sammlung"(einzigen Matrix)

%% �ndere den Pfad zu dem eingegeben Pfad "DIR"


if(~isempty(DIR)) % Wenn DIR gegeben ist. (~ = NICHT) (isempty = ist leer?)
    cd(DIR); % �ndere den Pfad zu "DIR" (cd = Change Directory)
end


comma2point_loop(DIR)

%% Alle Dateien suchen, die mit ".txt" beschriftet sind
A = dir(strcat('*','.txt')); % (strcat = kombiniere Strings)
                             % Erstelle ein Directory mit den .txt Dateien

for i = 1:size(A)
    fileID = A(i).name; %fileID ist der Name der .txt-Datei

    %% Input handling

    % Wenn dataLines nicht eingegeben ist, dann:
    if nargin < 2 %nargin ist die Anzahl an Argumenten (Eingaben in der Funktion)
        dataLines = [18, Inf]; % Ab der 18. Zeile faengt die Matrix von Interesse an.
    end

    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables",32);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = "\t"; %Delimiter ist das Trennzeichnen
                           %(Trennung zwischen Spalten) in dem "tab", 
                           %und ist als "\t" definiert

    % Specify column types
    opts.VariableTypes = ["double", "double", "double", "double",...
        "double", "double", "double", "double", "double", "double",...
        "double", "double", "double", "double", "double", "double",...
        "double", "double", "double", "double", "double", "double",...
        "double", "double", "double", "double", "double", "double",...
        "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "skip";


    %% Import the data and Convert to output type

    Sammlung_temp = readtable(fileID, opts);
    Sammlung(:,:,i) = table2array(Sammlung_temp);
  
    if (fileID(7) == 'm')
        multiplier = 10^-3;
    elseif (fileID(7) == 'y')
        multiplier = 10^-4;  
    elseif (fileID(7) == 'j')
        multiplier = 10^-5;      
    elseif (fileID(7) == 'u')
        multiplier = 10^-6;
    elseif (fileID(7) == 's')
        multiplier = 10^-7;
    elseif (fileID(7) == 'e')
        multiplier = 10^-8;        
    elseif (fileID(7) == 'n')
        multiplier = 10^-9;
    elseif (fileID(7) == 't')
        multiplier = 10^-10;
    elseif (fileID(7) == 'g')
        multiplier = 10^-11;
    elseif (fileID(7) == 'p')
        multiplier = 10^-12;    
    else
        multiplier = 1;
    end
    
    Sammlung(1,1,i) = str2num(fileID(4:6));
    multi(i) = multiplier; 
end

end
function [] = comma2point_loop(A)
%Mass imports data to convert all commas to periods
%A is the path name
cd (A);     % change to directory A
DIR = dir(strcat(A,'/*.txt'));  % create variable DIR of struct with 
                                % conatenated Directory name and /*txt
                                % this will locate all file names ending
                                % with .txt 

% starts loop to convert all commas to points                                
for i = 1:length(DIR)
    
    
    comma2point_overwrite(DIR(i).name);
    
    
end

end


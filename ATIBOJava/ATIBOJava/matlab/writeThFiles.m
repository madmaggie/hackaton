%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% writeThFiles.m                                                 %
% writes the thresholds for each letter in separate files        %
% Copyright 2013-2015 ATIBO                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% thresholds for 20% and 40% for each letter in the order:
% Amic, Amare, Bmic, Bmare, Cmic, Cmare, ... , Zmic, Zmare
load('../threshold.mat');
thresholds = [threshold20 threshold40];

% current file must be run from 'LitereModel' folder
% where there are the models for each letter
% we want only the filenames of the '.txt' (coordinates) files
% to use as filename for the threshold files
% list returns the filenames in this order:
% Amare.txt, ..., Amic.txt, ... Bmare.txt, ... Bmic.txt, ....
files = dir(); 

% first '.txt' filename ('Amare.txt') has index k=6
% because thresholds order and filenames order is different
k=6;
for i=1:2:52
     fid = fopen(['thresholds/th' files(k).name],'w');
     fprintf(fid,'%1.3f %1.3f\n',thresholds(i,1),thresholds(i,2));
     fclose(fid);
     fid = fopen(['thresholds/th' files(k-2).name],'w');
     fprintf(fid,'%1.3f %1.3f\n',thresholds(i+1,1),thresholds(i+1,2));
     fclose(fid);
     k=k+4;
end



file = '/media/micky/WORK/eclipseluna/ATIBOJava/TRAINING-LETTER-SET/Zmic/Zmic_incursdeachizitie/03.txt';
litera = load(file);

litera(:,1) = litera(:,1)-3*25/35;


fid=fopen(file,'w');

for i=1:size(litera(:,1),1)
    for j=1:4
        fprintf(fid, '%1.3f ',litera(i,j));
    end
    fprintf(fid, '\n');
end

fclose(fid);

%index = regexp(file,'.txt');
%filetosaveto = [file(1:index-1) '.png'];

%saveletterimage(file,35,25,70,filetosaveto);
saveletterimage(file,35,25,70);
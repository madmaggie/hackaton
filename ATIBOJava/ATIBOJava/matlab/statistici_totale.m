clear all
echo off
%close all

new = 1; % literele invatatoarei merg pe acest caz

%if new
    directoryname = uigetdir('C:\Users\dell\Desktop\diverse\calligraphy\Caligraph\incercari\litere invatatoare\', 'Pick a Directory');
    % schimbat cu folderul corespunzator
%else
%    directoryname = uigetdir('C:\Users\dell\Desktop\diverse\calligraphy\Caligraph\incercari\litere_gresite', 'Pick a Directory');
    % schimbat cu folderul corespunzator
%end
            
cd(directoryname)
ph_list=dir;
k=0;

plott=0;
draw=0;
matr_global=NaN*ones(length(ph_list)-2,100);

number_of_letters = length(ph_list)-2;
% height_matr=[];
% width_matr=[];
height_matr = zeros(1,number_of_letters);
width_matr = zeros(1,number_of_letters);

for i=1:number_of_letters
    %keyboard 
%    waitbar((i-1)/(length(ph_list)-2),hw) % display progress
    if (ph_list(i).isdir)
            %i
            %fprintf('%s :  ',ph_list(i).name);
            cd(ph_list(i+2).name); %comentate pentru figura Bmare
            disp(ph_list(i+2).name)
            dir_list=dir;
            %pause
            %keyboard 

            letterModel=load(dir_list(3).name);  
            letterModel=letterModel(:,1:2);
            %if new
                bitmapLetterModel=desen_bitmap2(letterModel);
            %else
            %    bitmapLetterModel=desen_bitmap(letterModel);
            %end

            s  = regionprops(bitmapLetterModel, 'centroid');
            val=round(cat(1, s.Centroid));
            centroids_model_x=val(1); centroids_model_y=val(2);

            st_model = regionprops(bitmapLetterModel, 'BoundingBox' );
            for k = 1 : length(st_model)
                thisBB_model = st_model(k).BoundingBox;
            end
            height_model=round(abs(thisBB_model(4)-thisBB_model(2))); 
            width_model=round(abs(thisBB_model(3)-thisBB_model(1))); 

            for j=2:length(dir_list)-2
                letter=load(dir_list(j+2).name);
                letter=letter(:,1:2);

                %if new 
                    bitmapLetter=desen_bitmap2(letter);
                %else
                %    bitmapLetter=desen_bitmap(letter);
                %end
            %keyboard 
                [nrmodel, ncmodel]=size(bitmapLetterModel);
                [nrtest, nctest]=size(bitmapLetter);
                nr=min(nrmodel,nrtest);nc=min(ncmodel,nctest);
                bitmapLetterModel=bitmapLetterModel(1:nr,1:nc);
                bitmapLetter=bitmapLetter(1:nr,1:nc);

                [Dist_hor, Dist_ver, timelag_x, timelag_y]=proiectie(bitmapLetterModel, bitmapLetter,draw);
                      
                s  = regionprops(bitmapLetter, 'centroid');
                val=round(cat(1, s.Centroid));
                centroids_test_x=val(1); centroids_test_y=val(2);

                st_test = regionprops(bitmapLetter, 'BoundingBox' );
                for k = 1 : length(st_test)
                    thisBB = st_test(k).BoundingBox;
                end
    %           matr_model(i,:)=thisBB;

                height_test = round(abs(thisBB(4)-thisBB(2))); 
                width_test = round(abs(thisBB(3)-thisBB(1)));
                %height_matr = [height_matr height_test/height_model]; 
                %width_matr = [width_matr width_test/width_model]; 
                height_matr(i) = height_test/height_model;
                width_matr(i) = width_test/width_model;
                
                centroid_x=round(centroids_test_x-centroids_model_x);
                centroid_y=round(centroids_test_y-centroids_model_y);

                centroids_model=[centroids_model_x centroids_model_y];
                centroids_test=[centroids_test_x centroids_test_y];
            %keyboard
                [Dist_rot, summodel, sumtest]=rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott,draw);
            
    %          matr_test(:)=sumtest(:); 
          
            
                factor=7;
                model=regionprops(bitmapLetterModel,'PixelList');
                test=regionprops(bitmapLetter,'PixelList');
                model0=model.PixelList(1:factor:end,:);
                test0=test.PixelList(1:factor:end,:);
                model1=Compute_AbslAng_Chain([model0(:,1) model0(:,2)]);
                test1=Compute_AbslAng_Chain([test0(:,1) test0(:,2)]);
                [Dist_u,D_u,k_u,w_u,rw_u,tw_u]=dtw(model1/360,test1/360,0);
                Dist_glob=0.45*Dist_hor+0.45*Dist_ver+0.08*Dist_u+0.02*Dist_rot;
                matr_global(i,j-1)=Dist_glob;

            end
                    
            cd ('..'); 
            %i=i+1;
            %matr_global
    end
end %if (ph
%pause
%close all
[nri, nrc]=size(matr_global);

mean_ii=zeros(nri,1); std_ii=zeros(nri,1);
for ii=1:nri
    line_ii=matr_global(ii,:);
    out = line_ii(:, all(~isnan(line_ii), 1));
    mean_ii(ii)=mean(out); std_ii(ii)=std(out);
end
    
errorbar(mean_ii,std_ii)

for ii=1:nri, hold on; plot(ii, matr_global(ii,:),'*');end

figure, for ii=1:nri, hold on; plot(ii, matr_global(ii,:),'*');end
figure, errorbar(mean_ii,std_ii) 

[aamin, bbmin]=sort(mean_ii); 
disp('litere cu distante DTW medii ordonate crescator')
%bbmin'
[aamax, bbmax]=sort(std_ii); 
disp('litere cu deviatii standard ale distantelor DTW ordonate crescator')
%bbmax'

if 1

figure
%height_matr
plot(height_matr)
hold on
plot(1.15*ones(length(height_matr),1),':k')
plot(0.85*ones(length(height_matr),1),':k')

figure,
plot(width_matr)
hold on
plot(1.15*ones(length(width_matr),1),':k')
plot(0.85*ones(length(width_matr),1),':k')

mean(height_matr)
%save(['matt' int2str(i)], 'H', '-ascii')
end


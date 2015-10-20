function statistics(reffile, testdir)

%clear all
%echo off
%uteclose all

%crtFolder = pwd;

%new = 1; % literele invatatoarei merg pe acest caz

%[filename1, pathname] = uigetfile('*.TXT', 'Pick the prototype file')
%cd (pathname)
%letterModel=load(filename1);
letterModel=load(reffile);
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
  %thisBB_model = st_model(k).BoundingBox;
end

%if new
%    directoryname = uigetdir('C:\Users\dell\Desktop\diverse\calligraphy\Caligraph\incercari\litere invatatoare\2014_03_31 (litere)', 'Pick a Directory');
    % schimbat cu folderul corespunzator
%else
%    directoryname = uigetdir('C:\Users\dell\Desktop\diverse\calligraphy\Caligraph\incercari\litere_gresite', 'Pick a Directory');
    % schimbat cu folderul corespunzator
%end
            
%cd(directoryname)
%cd(testdir)
ph_list=dir(testdir);
%k=0;
plott=0;

matr_test=zeros(49,length(ph_list)-2);
matr_model=zeros(length(ph_list)-2,4);

number_of_letters = length(ph_list)-3;
Dist_hor = zeros(1,number_of_letters);
Dist_ver = zeros(1,number_of_letters);
timelag_x = zeros(1,number_of_letters);
timelag_y = zeros(1,number_of_letters);
centroids_test_x = zeros(1,number_of_letters);
centroids_test_y = zeros(1,number_of_letters);
centroid_x = zeros(1,number_of_letters);
centroid_y = zeros(1,number_of_letters);
Dist_rot = zeros(1,number_of_letters);
Dist_u = zeros(1,number_of_letters);

for i=1:number_of_letters
    %keyboard 
%    waitbar((i-1)/(length(ph_list)-2),hw) % display progress
%    if (ph_list(i).isdir)
        %if ~strcmp(ph_list(i).name(1),'.') 
            %i
            %fprintf('%s :  ',ph_list(i).name);
%           cd(ph_list(i).name);
            dir_list=dir(testdir);
            disp(dir_list(i+3).name)
            letter=load([testdir '/' dir_list(i+3).name]);
            letter=letter(:,1:2);

            if new 
                bitmapLetter=desen_bitmap2(letter);
            else
                bitmapLetter=desen_bitmap(letter);
            end
%             if 0
%                 figure, imshow(bitmapLetter)
%                 dir_list(i+3).name
%                 pause
%                 close
%             end
            %keyboard 
            [nrmodel, ncmodel]=size(bitmapLetterModel);
            [nrtest, nctest]=size(bitmapLetter);
            nr=min(nrmodel,nrtest);nc=min(ncmodel,nctest);
            bitmapLetterModel=bitmapLetterModel(1:nr,1:nc);
            bitmapLetter=bitmapLetter(1:nr,1:nc);

            [Dist_hor(i), Dist_ver(i), timelag_x(i), timelag_y(i)]=proiectie(bitmapLetterModel, bitmapLetter);
            
            
            s  = regionprops(bitmapLetter, 'centroid');
            val=round(cat(1, s.Centroid));
            centroids_test_x(i)=val(1); centroids_test_y(i)=val(2);

            st_test = regionprops(bitmapLetter, 'BoundingBox' );
            for k = 1 : length(st_test)
                thisBB = st_test(k).BoundingBox;
            end
            matr_model(i,:)=thisBB;

            centroid_x(i)=round(centroids_test_x(i)-centroids_model_x);
            centroid_y(i)=round(centroids_test_y(i)-centroids_model_y);

            centroids_model = [centroids_model_x centroids_model_y];
            centroids_test = [centroids_test_x(i) centroids_test_y(i)];
            %keyboard
            %[Dist_rot(i), summodel, sumtest] = rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott);
            [Dist_rot(i), ~, sumtest] = rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott);
            
            matr_test(:,i)=sumtest(:); 
          
            
            factor=7;
            model=regionprops(bitmapLetterModel,'PixelList');
            test=regionprops(bitmapLetter,'PixelList');
            model0=model.PixelList(1:factor:end,:);
            test0=test.PixelList(1:factor:end,:);
            model1=Compute_AbslAng_Chain([model0(:,1) model0(:,2)]);
            test1=Compute_AbslAng_Chain([test0(:,1) test0(:,2)]);
            %[Dist_u(i),D_u,k_u,w_u,rw_u,tw_u]=dtw(model1/360,test1/360,0);
            [Dist_u(i),~,~,~,~,~]=dtw(model1/360,test1/360,0);


%             if plott
%                 if 0
%                     [r]=mean(letterModel');
%                     [t]=mean(letter');
%                     figure
%                     axis ij
%                     hold on
%                     plot(letterModel(:,1)-r(1),letterModel(:,2)-r(2),'bx')
%                     plot(letter(:,1)-t(1),letter(:,2)-t(2),'rx')
%                     legend('model letter', 'test letter')
%                     hold off
%                 end
                
%                 figure
%                 subplot(2,2,1)
%                 [r,c] = size(bitmapLetterModel);                           %# Get the matrix size
%                 imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetterModel);            %# Plot the image
%                 colormap(gray);                              %# Use a gray colormap
%                 axis equal                                   %# Make axes grid sizes equal
% 
%                 set(gca,'XTick',1:10:(c+1),'YTick',1:10:(r+1),...  %# Change some axes properties
%                 'XLim',[1 c+1],'YLim',[1 r+1],...
%                 'GridLineStyle','-','XGrid','on','YGrid','on');
%                 title('Prototype Letter')
% 
%                 subplot(2,2,3)    
%                 [r,c] = size(bitmapLetter);                           %# Get the matrix size
%                 imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
%                 colormap(gray);                              %# Use a gray colormap
%                 axis equal                                   %# Make axes grid sizes equal
% 
%                 set(gca,'XTick',1:10:(c+1),'YTick',1:10:(r+1),...  %# Change some axes properties
%                 'XLim',[1 c+1],'YLim',[1 r+1],...
%                 'GridLineStyle','-','XGrid','on','YGrid','on');
%                 title('Test Letter')
%                 
%                 subplot(222)
%                 plot(sum(bitmapLetterModel,1),'r');
%                 hold on;
%                 plot(sum(bitmapLetter,1),'b');hold off
%                 title('The projection on x-axis')
%                 legend('Prototype Letter','Test letter')
% 
%                 subplot(224)
%                 plot(sum(bitmapLetterModel,2),'r');hold on; plot(sum(bitmapLetter,2),'b');hold off
%                 title('The projection on y-axis')
%                 legend('Prototype Letter','Test letter')
%                 
%                 pause
%                 close all
%             end
             
            
 
            %cd ('..');
            %cd('..'); 
           %end%if ~stcmp
%   end %if (ph
end%for
%pause
%close all
figure
subplot(221), plot(Dist_hor), title('horizontal distance');subplot(222), plot(Dist_ver), title('vertical distance') 
subplot(223), plot(Dist_u), title('angle distance');subplot(224), plot(Dist_rot), title('rotation distance') 
%gtext('a)');gtext('b)');gtext('c)');gtext('d)')
%save Amare_valori Dist_hor Dist_ver Dist_rot timelag_x timelag_y centroid_x centroid_y matr_test summodel matr_model thisBB_model 
Dist_glob=0.4*Dist_hor+0.4*Dist_ver+0.18*Dist_u+0.02*Dist_rot;
figure, plot(Dist_glob),title('global distance')
%[dd,ss]=sort(Dist_glob);
[~,ss]=sort(Dist_glob);

plott2=1;
disp('prototype file')
%disp(filename1)
disp(reffile)
disp('  ')
if plott2, figure, subplot(132),imshow(bitmapLetterModel);title('prototype letter'), end

disp('sorted global distance')
disp('  ')
for i=1:length(ss)
    disp(dir_list(ss(i)+2).name)
end
    if plott2, 
        letter=load(dir_list(ss(1)+2).name);
        letter=letter(:,1:2);
            if new 
                bitmapLetter=desen_bitmap2(letter);
            else
                bitmapLetter=desen_bitmap(letter);
            end
            subplot(131),imshow(bitmapLetter), title('lowest distance letter');
            
            letter=load(dir_list(ss(length(ss))+2).name);
            letter=letter(:,1:2);
            if new 
                bitmapLetter=desen_bitmap2(letter);
            else
                bitmapLetter=desen_bitmap(letter);
            end
            subplot(133), imshow(bitmapLetter), title('highest distance letter');

    end

%cd ..
%cd ..
%cd (crtFolder)


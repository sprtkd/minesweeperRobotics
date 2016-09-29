%This Program is written for IIEST ROBODARSHAN DIY4.2...   TO USE IMG
%PROCESSING IN MATLAB  and control a bot detect green blobs
%
%codes for arduino-- 
%f-forward, delay-0.1
%b-back,delay-0.1
%l-left,delay-0.1
%r-right,delay-0.1
%c-check for ir,del-1 present-y,no-n if present 3.1
%s- sound buzzer at end,delay-7
%m-checking connection line,delay-0.5,return 'y'
clc;
clear;
h = msgbox('Hope you have turned on bluetooth and switched on Arduino..');%display msg box
%imagepath of image--
imgpath='C:\Users\User\Desktop\Botimage\';

AngleThresh=0.4;
AngleThresh2=0.8;
ForwardThresh=6;
ForwardThresh2=17;




%imagepath of image-end-

%bluetooth module-------

%defines bluetooth port hc-05 stores it in 'arduino'
arduino= Bluetooth('HC-05',1);
fopen(arduino);
h = msgbox('Connection Successful','Success');%display msg box

%bluetooth module--end---

%read digital image------

imglist = dir(imgpath);
[imgcount , ~] = size(imglist);
imgfile = imglist(imgcount -1);
imgname= imgfile.name;
im=imread(strcat(imgpath,imgname));
imshow(im);
h = msgbox('First aqcuired image!!','Success');%display msg box
%read digital image--end--

%checking various issues------




%check how many green blobs are visible-----

 
R=im(:,:,1);        
G=im(:,:,2);         
B=im(:,:,3);        
[r,c,~]=size(R);    
binGreen=zeros(r,c); 
for i=1:r
    for j=1:c
        if R(i,j)<=50&&G(i,j)>=200&&B(i,j)<=50 
            binGreen(i,j)=1;    
        end
    end
end
target=binGreen;
target_labeled=bwlabel(target);
stats=regionprops(target_labeled,'centroid');
   no_of_blobs=max(max(target_labeled));
 blobmat=zeros(1,2,no_of_blobs);
for i=1:no_of_blobs
    
    
     target_position= stats(i).Centroid;
 for j=1:2
 blobmat(1,j,i)=target_position(j);
 end
end   
    h = msgbox(['No. of green Blobs: ' num2str(no_of_blobs)], 'Show');%display msg box

%check how many green blobs are visible-end--




%check whether Bot is visible-----
    

    
 
R=im(:,:,1);
G=im(:,:,2);        
B=im(:,:,3);        
[r,c,~]=size(R);

binRed=zeros(r,c);     
binBlue=zeros(r,c);    


for i=1:r               
    for j=1:c
        if R(i,j)<=50&&G(i,j)<=50&&B(i,j)>=200 %threshold for blue, it may change depending on the image
            binBlue(i,j)=1;      %turns the elements in the matrix from 0 to 1, which satisfies the threshold
        end
    end
end


for i=1:r               
    for j=1:c
        if binBlue(i,j)==1
               flag1=1;
               break
         
        else
            flag1=0;
        end
    end
    if(flag1==1)
        break
    end
end
if(flag1==1)
     h=msgbox('ok');
else
    h=msgbox('no blue dot detected');
    error('no blue dot detected');
    
end
    
for i=1:r
    for j=1:c
        if R(i,j)<=50&&G(i,j)<=50&&B(i,j)>=200 %similar to above
            binBlue(i,j)=1; %similar to above
        end
    end
end
        
bot_body=binBlue;


bot_body_labeled=bwlabel(bot_body);


stats_body=regionprops(bot_body_labeled,'BoundingBox');
B_box_body=stats_body(1).BoundingBox(3)*stats_body(1).BoundingBox(4);

if B_box_body>500
    h=msgbox('bot is present');
else
    h=msgbox('bot is not present. Pls check the picture');
    imshow(im);
    error('bot is not present. Pls check the picture');
end


%check whether Bot is visible-end--



%check connection with bot-----
fprintf(arduino,'%c','m');
pause(0.55);
serIn=fscanf(arduino,'%c');
if(serIn=='y')
    h=msgbox('Communication is working'); 
end
    

%check connection with bot-end--

%checking various issues---end--



h=msgbox('Do not move camera & do not disconnect bluetooth!!!'); 

%read digital image------

imglist = dir(imgpath);
[imgcount , ~] = size(imglist);
imgfile = imglist(imgcount -1);
imgname= imgfile.name;
im=imread(strcat(imgpath,imgname));


%read digital image--end--

%store blob positions in matrix 3dim-----

 
R=im(:,:,1);        
G=im(:,:,2);         
B=im(:,:,3);        
[r,c,~]=size(R);    
binGreen=zeros(r,c); 
for i=1:r
    for j=1:c
        if R(i,j)<=50&&G(i,j)>=200&&B(i,j)<=50 
            binGreen(i,j)=1;    
        end
    end
end
target=binGreen;
target_labeled=bwlabel(target);
stats=regionprops(target_labeled,'centroid');
   no_of_blobs=max(max(target_labeled));
 blobmat=zeros(1,2,no_of_blobs);
for i=1:no_of_blobs
    
    
     target_position= stats(i).Centroid;
 for j=1:2
 blobmat(1,j,i)=target_position(j);
 end
end   
    h = msgbox(['No. of green Blobs: ' num2str(no_of_blobs)], 'Show');%display msg box

%store blob positions in matrix 3dim--end-




%actual loop--------
 blobDone=zeros(1,no_of_blobs);
 
 
for iMain=1:no_of_blobs %primary loop---
    
    %closestOrderOfBlobs----- 
 
 
 
   %read digital image------

imglist = dir(imgpath);
[imgcount , ~] = size(imglist);
imgfile = imglist(imgcount -1);
imgname= imgfile.name;
im=imread(strcat(imgpath,imgname));
   %read digital image--end--
   
   
   %to get the location of bot-----


R=im(:,:,1);       
G=im(:,:,2);        
B=im(:,:,3);       
[r,c,~]=size(R);    

    
binRed=zeros(r,c);     
binBlue=zeros(r,c);     

for iDetect=1:r               
    for jDetect=1:c
        if R(iDetect,jDetect)>=200&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)<=50 %threshold for red, it may change depending on the image
            binRed(iDetect,jDetect)=1;      %turns the elements in the matrix from 0 to 1, which satisfies the threshold
        end
    end
end

for iDetect=1:r
    for jDetect=1:c
        if R(iDetect,jDetect)<=50&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)>=200 %similar to above
            binBlue(iDetect,jDetect)=1; %similar to above
        end
    end
end

bot_body=binBlue;
bot_head=binRed;

bot_head_labeled=bwlabel(bot_head);
bot_body_labeled=bwlabel(bot_body);


stats=regionprops(bot_body_labeled,'centroid');
    bot_body_position=stats.Centroid;
stats=regionprops(bot_head_labeled,'centroid');
    bot_head_position=stats.Centroid;
    
  mean_bot_position=(bot_body_position+bot_head_position)/2;%important variable  
  
  
  bot_angle = -atan2(bot_head_position(2)-bot_body_position(2),bot_head_position(1)-bot_body_position(1));%important variable  
    
 
 %to get the location of bot--end-
 
 
 
 
   %store distance between blobs and mean bot position--------  
blobBotDist=zeros(2,no_of_blobs+1);
  for iStoreDist=1:no_of_blobs
      
      flagStoreDistAlreadyPresent=0;
          iCall=1;
          while (iCall<iMain)
             if(iStoreDist==blobDone(iCall))
                flagStoreDistAlreadyPresent=1;
                break
             end
             iCall=iCall+1;
          end
          if (flagStoreDistAlreadyPresent==1)
              continue
          end
      iCall=1;
      while(blobBotDist(1,iCall)~=0)
      iCall=iCall+1;    
      end    
      blobBotDist(1,iCall)=iStoreDist;
       
      blobBotDist(2,iCall)=sqrt( (( (blobmat(1,1,iStoreDist))-  (bot_body_position(1))   )^2) + ((   (blobmat(1,2,iStoreDist))-  (bot_body_position(2))   )^2)    );
     
  end
  %store distance between blobs and mean bot position--end---
  
  
  %compare distance between blobs and mean bot position--------
  
  leastDist=blobBotDist(2,1);
  blobDone(iMain)=blobBotDist(1,1);
  iCompare=1;
  while(blobBotDist(1,iCompare)~=0)
      if (leastDist>blobBotDist(2,iCompare))
          leastDist=blobBotDist(2,iCompare);
          blobDone(iMain)=blobBotDist(1,iCompare);
          
      end 
     iCompare=iCompare+1; 
  end
  
  
  
  

%compare distance between blobs and mean bot position---end--
%this part of code will return blobDone(iMain) as the blob to be done in the loop,

%closestOrderOfBlobs--end--- 
   


h = msgbox(['Going to blob no.: ' num2str(blobDone(iMain))], 'Show');%display msg box
  imshow(target_labeled==(blobDone(iMain)));
    
    
    
    flagBotBlobOk=0; 
    
while 1  %secondary loop---  

 
        
        flagBotAngleOk=0;       
    flagBotBlobDistOk=0;   
    
    
    
 %rotating the bot right or left------       
while 1        
    %read digital image------

imglist = dir(imgpath);
[imgcount , ~] = size(imglist);
imgfile = imglist(imgcount -1);
imgname= imgfile.name;
im=imread(strcat(imgpath,imgname));
   %read digital image--end--
    
   %to get the location of bot-----


R=im(:,:,1);       
G=im(:,:,2);        
B=im(:,:,3);       
[r,c,~]=size(R);    

    
binRed=zeros(r,c);     
binBlue=zeros(r,c);     

for iDetect=1:r               
    for jDetect=1:c
        if R(iDetect,jDetect)>=200&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)<=50 %threshold for red, it may change depending on the image
            binRed(iDetect,jDetect)=1;      %turns the elements in the matrix from 0 to 1, which satisfies the threshold
        end
    end
end

for iDetect=1:r
    for jDetect=1:c
        if R(iDetect,jDetect)<=50&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)>=200 %similar to above
            binBlue(iDetect,jDetect)=1; %similar to above
        end
    end
end

bot_body=binBlue;
bot_head=binRed;

bot_head_labeled=bwlabel(bot_head);
bot_body_labeled=bwlabel(bot_body);


stats=regionprops(bot_body_labeled,'centroid');
    bot_body_position=stats.Centroid;
stats=regionprops(bot_head_labeled,'centroid');
    bot_head_position=stats.Centroid;
     
  
  
  bot_angle = -atan2(bot_head_position(2)-bot_body_position(2),bot_head_position(1)-bot_body_position(1));%important variable  
    
 
 %to get the location of bot--end- 
   
  %to get angle of blob to goto with bot_body-----
  
  
   blobGoto_angle = -atan2(blobmat(1,2,blobDone(iMain))-bot_body_position(2),blobmat(1,1,blobDone(iMain))-bot_body_position(1));%important variable
  
  
  %to get angle of blob to goto with bot_body--end-
   
  botBlobAngle= bot_angle - blobGoto_angle
  
  
  if((botBlobAngle>3.141)&&(botBlobAngle<=6.2831))
botBlobAngle=botBlobAngle-6.283185;
  end
  
  if((botBlobAngle<AngleThresh)&&(botBlobAngle>(-AngleThresh)))   %angles are in radian
    flagBotAngleOk=1;
    break
    elseif ((botBlobAngle<=AngleThresh2)&&(flagBotBlobOk==1))
      flagBotAngleOk=1;
    break
  elseif ((botBlobAngle>=(-AngleThresh2))&&(flagBotBlobOk==1))
      flagBotAngleOk=1;
    break   
  elseif (botBlobAngle>=AngleThresh)
      fprintf(arduino,'%c','r');
      pause(0.05);
  elseif (botBlobAngle<=(-AngleThresh))
      fprintf(arduino,'%c','l');
      pause(0.05);      
    
  end
  pause(0.15);      
      
  
end 
 %rotating the bot right or left---end-      
  
 
 
 %moving the bot to the blob one time-----
 %read digital image------

imglist = dir(imgpath);
[imgcount , ~] = size(imglist);
imgfile = imglist(imgcount -1);
imgname= imgfile.name;
im=imread(strcat(imgpath,imgname));
   %read digital image--end--
   
   
   %to get the location of bot-----


R=im(:,:,1);       
G=im(:,:,2);        
B=im(:,:,3);       
[r,c,~]=size(R);    

    
binRed=zeros(r,c);     
binBlue=zeros(r,c);     

for iDetect=1:r               
    for jDetect=1:c
        if R(iDetect,jDetect)>=200&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)<=50 %threshold for red, it may change depending on the image
            binRed(iDetect,jDetect)=1;      %turns the elements in the matrix from 0 to 1, which satisfies the threshold
        end
    end
end

for iDetect=1:r
    for jDetect=1:c
        if R(iDetect,jDetect)<=50&&G(iDetect,jDetect)<=50&&B(iDetect,jDetect)>=200 %similar to above
            binBlue(iDetect,jDetect)=1; %similar to above
        end
    end
end

bot_body=binBlue;
bot_head=binRed;

bot_head_labeled=bwlabel(bot_head);
bot_body_labeled=bwlabel(bot_body);


stats=regionprops(bot_body_labeled,'centroid');
    bot_body_position=stats.Centroid;
stats=regionprops(bot_head_labeled,'centroid');
    bot_head_position=stats.Centroid;
    
  mean_bot_position=(bot_body_position+bot_head_position)/2;%important variable  
  
  
  bot_angle = -atan2(bot_head_position(2)-bot_body_position(2),bot_head_position(1)-bot_body_position(1));%important variable  
  
  
  
  
   %to get the location of bot--end-
   GettheDist=sqrt( (( (blobmat(1,1,blobDone(iMain)))-  (bot_body_position(1))   )^2) + ((   (blobmat(1,2,blobDone(iMain)))-  (bot_body_position(2))   )^2)    )
  
   
   if(GettheDist<ForwardThresh2)

 flagBotBlobOk=1; 
   
   end  
   
 
 if(GettheDist<ForwardThresh)
 flagBotBlobDistOk=1;
 flagBotBlobOk=1; 
 elseif((GettheDist>=ForwardThresh)&&(GettheDist<50))
   fprintf(arduino,'%c','f');   
    pause(0.1);
    
 elseif(GettheDist>=50)
   fprintf(arduino,'%c','f');   
    pause(0.1);
    fprintf(arduino,'%c','f');   
    pause(0.1);
 end
 
 %moving the bot to the blob one time-end--
 
   
   
 
 if((flagBotAngleOk==1)&&(flagBotBlobDistOk==1))
   break
 end 
    
end  %secondary loop-end--  



h = msgbox(['Bot has reached blob no.: ' num2str(blobDone(iMain))], 'Show');%display msg box




    %check for ir------
    
    h = msgbox(['Bot is checking for IR at blob no.: ' num2str(blobDone(iMain))], 'Show');%display msg box
  
    fprintf(arduino,'%c','f');   
    pause(0.1);
    fprintf(arduino,'%c','r');   
    pause(0.05);
    fprintf(arduino,'%c','c');   
    pause(1.6);
    
    CharGot=fscanf(arduino,'%c');
    if(CharGot=='y')
     h = msgbox('IR Present');%display msg box
        
    elseif (CharGot=='n')
     h = msgbox('IR Not present');%display msg box
    end
     
     
    
    
   
    %check for ir--end-
    
    
    
end %primary loop--end--





%actual loop--end---

h = msgbox('Job Done','Success');%display msg box
pause(1.5);

%sound a buzzer-----

fprintf(arduino,'%c','s');
pause(7);


%sound a buzzer--end-


%end bluetooth com----
fclose(arduino);

%end bluetooth com-end--
h = msgbox('Task completed..Switch off Arduino..','Success');%display msg box
clc
clear all

obj1 = VideoReader('video.mpg');
if hasFrame(obj1)
    prev_img=rgb2gray(readFrame(obj1));
    prev_img=im2double(prev_img);
else
    return
end
% As stated in horn and schunck paper
kern=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];
tx=[-1 1; -1 1];
ty=[-1 -1; 1 1];
iterations=100;
alpha=0.1;
while hasFrame(obj1)
    next_img=rgb2gray(readFrame(obj1));
    next_img=im2double(next_img);
    u=0;
    v=0;
    % Ix Iy It calculations
    ix=conv2(prev_img,(0.25)*tx,'same')+conv2(next_img,(0.25)*tx,'same');
    iy=conv2(prev_img,(0.25)*ty,'same')+conv2(next_img,(0.25)*ty,'same');
    it=conv2(prev_img,(0.25)*ones(2),'same')+conv2(next_img,(-0.25)*ones(2),'same');
    % Iterations
    for j=1:iterations
        %local averages
        uavg=conv2(u,kern,'same');
        vavg=conv2(v,kern,'same');
        %iterative solution 
        u=uavg-(ix.*((ix.*uavg)+(iy.*vavg)+it))./(alpha^2+ix.^2+iy.^2); 
        v=vavg-(iy.*((ix.*uavg)+(iy.*vavg)+it))./(alpha^2+ix.^2+iy.^2);
    end
    
    subplot(1,3,1);
    imshow(prev_img,[]);title('previous image');
    subplot(1,3,2);
    imshow(next_img,[]);title('next image');
    subplot(1,3,3);
    [a,b]=size(u);
    d=5;
    index_x=1:d:a;
    index_y=1:d:b;
    [X,Y]=meshgrid(index_y,index_x);
    u1=u(index_x,index_y);
    v1=v(index_x, index_y);
    quiver(X,Y,u1(end:-1:1,:),v1(end:-1:1,:),3)
    title('Optical Flow');
    axis image;
    prev_img=next_img;
end

    
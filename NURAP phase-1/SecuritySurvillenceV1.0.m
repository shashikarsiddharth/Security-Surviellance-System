%  Steps to be followed
% 1) Read an input video and variable intialization.
% 2) Extract the first frame as the backgorund frame.
% 3) Apply background subtraction on the subsequent video frame and some morphological operations.
% 4) Calculate the area of the detected object.
% 5) If object is of interset, track the motion of the object.
% 6) Find the centroid, add bounding box on the detected object.
% 9) If there is a case of anomaly generate an alert message.

% %  READING THE VIDEO FROM THE DISK % % 
source = VideoReader('trial video1.mp4');
nFrames = source.NumberOfFrames;
threshold = 27;

% %  FOR EXTRACTING A FRAME WITHOUT ANY INTRUSION %%
% x = 700;
% mov(x).cdata = read(source,x);
% frame = mov(x).cdata;
% imshow(frame);
% imwrite(frame,'ref_frame.jpg');

% % READING THE FIRST FRAME % %
ref_img = imread('ref_frame.jpg');
imshow(ref_img);
ref_img = rgb2gray(ref_img);
ref_img = double(ref_img);
[h,w] =  size(ref_img);

% % REAPTING FOR EVERY FRAME % % 
for x = 2:5:nFrames
    mov(x).cdata = read(source,x);
    frame = mov(x).cdata;
    op = frame;
    frame = rgb2gray(frame);
    frame_bw = double(frame);
    frame_diff = frame_bw - ref_img;

% % THRESHOLDING THE RESUTLANT IMAGE TO OBTAIN BINARY IMAGE % % 
  for i = 1:h
        for j = 1:w 
            if(frame_diff(i,j) >= threshold)
                if ((j >= 165 && j <= 480))  
                    frame_diff(i,j) = 255;
                else
                    frame_diff(i,j) = 0;
                end
            else
                  frame_diff(i,j) = 0;
            end
        end
  end 

% %  APPLYING SOME MORHPOLOGICAL OPERATIONS % % 
    frame_diff = bwareaopen(frame_diff,1000);
    frame_diff = bwconvhull(frame_diff,'objects');
    se = strel('disk',10);
    
    track_objects = regionprops(frame_diff,'basic');
    n_centroid = cat(1,track_objects.Centroid);
    imshow(op);
    
% %  APPLYING BOUNDING BOX AROUND THE OBJECT % %   
    hold on 
    for index = 1:length(track_objects)
        box = track_objects(index).BoundingBox;
        plot(track_objects(index).Centroid(1),track_objects(index).Centroid(2),'b*');
        rectangle('position',box,'Edgecolor','green','LineWidth',3);
    end
   
    movegui(gcf);
    F(x) = getframe(figure(1));
    hold off
end

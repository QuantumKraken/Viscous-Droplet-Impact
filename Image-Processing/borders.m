function videoBorders = borders(dat)
% extract dimensions of video matrix
[a, b, c, d] = size(dat);

for i = 1:d
    % Selects each frame and uploads it as a single double image.
    % *32 multiplier brightens the image to reduce inconsistancies. 
    I = im2double(dat(:,:,1,i))*32;
    % Convert back to uint8
    I = im2uint8(I);
    
    % Use the processing techniques from the exercise we did the other day.
    [~, threshold] = edge(I, 'sobel');
    fudgeFactor = 0.25;
    BWs = edge(I, 'prewitt', threshold * fudgeFactor);
    
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BWsdil = imdilate(BWs, [se90 se0]);

    BWdfill = imfill(BWsdil, 'holes');
    
    %Removed BWnobord since it deletes the droplet if it intersects the
    %floor or ceiling. Will add back in once that is addressed.
    %BWnobord = imclearborder(BWdfill, 8);

    %Temp line so I can make the pull request.
    
    %Remove small objects
    BWnosmall = bwareaopen(BWdfill, 150);
    
    %Return processed images in the same format as the input images.
    videoBorders(:,:,:,i) = BWnosmall;
end

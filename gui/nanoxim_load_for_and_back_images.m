function [bck_img, for_img]=nanoxim_load_for_and_back_images(handles)

if get(handles.radiobutton_video,'Value')==1
    % Get Background and Foreground Images from videos
    
    bck_img = nanoxim_GetFrameRangeImg(vid_obj, bck_frame_range);
    for_img = nanoxim_GetFrameRangeImg(vid_obj, for_frame_range);
else
    bck_img_path = getappdata(handles.figure_nanoxim, 'bck_img_path');
    for_img_path = getappdata(handles.figure_nanoxim, 'for_img_path');
    
    % Get Background image
    if ~isempty(regexp(bck_img_path,'.*\.(?:jpg|jpeg|gif|png|bmp|tif|tiff)$','once'))
         bck_img = imread(bck_img_path);
    else
         bck_img =  max(load_video(bck_img_path),[],4);
    end
    
      % Get Foreground Image
    if ~isempty(regexp(for_img_path,'.*\.(?:jpg|jpeg|gif|png|bmp|tif|tiff)$','once'))
         for_img = 50+imread(for_img_path);
    else
         for_img =  max(load_video(for_img_path),[],4);
    end
    
end
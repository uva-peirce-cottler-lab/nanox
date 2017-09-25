function gui_UpdateRatiomImage(handles)
dprintf('Updating Ratiometric Image');
% keyboard 
handles = guidata(handles.figure_nanoxim);
  
% Get image
ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');

% Get ROI mask
bw_ratiom_for_roi = getappdata(handles.figure_nanoxim,'bw_ratiom_for_roi');
if isempty(bw_ratiom_for_roi)
    bw_ratiom_for_roi= true(size(ratio_img));
end

% Get Pix pass
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');

% ROI is union of ROI and pixpass
keyboard
bw_roi_pix_pass = bw_pix_pass & bw_ratiom_for_roi;

% keyboard
% Display pixpassed ROI image
% h1 = imshow(zeros(size(ratio_img)),'Parent',handles.axes_ratiom);

% hold on

cla(handles.axes_ratiom)
h2=imshow(ratio_img,'Parent',handles.axes_ratiom);
% hold off
set(h2,'AlphaData',bw_roi_pix_pass);


% Update caxis handles
% caxis(handles.axes_ratiom,[min(ratio_img(bw_roi_pix_pass)) max(ratio_img(bw_roi_pix_pass))]);
% [min(ratio_img(bw_pix_pass)) max(ratio_img(bw_pix_pass))]
colormap(handles.axes_ratiom, jet);
caxis(handles.axes_ratiom,[handles.rslider_ratiom.getLowValue() ...
    handles.rslider_ratiom.getHighValue()]);
colorbar(handles.axes_ratiom);

hold on
img = getframe(handles.axes_ratiom);
black_space = (sum(img.cdata==255,3)==3);
img.cdata(cat(3,black_space,black_space,black_space))=0;
imshow(imresize(img.cdata,[2048 2048]),'Parent',handles.axes_ratiom);
hold off



out_str = sprintf('Output: %0.4f Pixels Used, RatioM: %.3f +- %.3f',...
    sum(bw_roi_pix_pass(:))./numel(bw_roi_pix_pass),...
    mean(ratio_img(bw_roi_pix_pass)),std(ratio_img(bw_roi_pix_pass)));


% Display output
set(handles.text_ratiom_output,'String',out_str);
dprintf(out_str);

end
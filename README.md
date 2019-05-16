# nanox
Oxygen Sensing Nanoparticle software to measure oxygen concentration noninvasively, spatially, in real time.


## Initialize Program
1. Open the nanoxim folder, and open the USER_INITIALIZE.m matlab script. THe script will open in the matlab editor.
2. Runt he script by pressing the green arrow labeled run in the menu ribbon (or hit F5 if on PC)
3. MATLAB will initialize the program and open the GUI
4. In the nanoxim GUI, select "Browse Folder" and browse to the folder containing the input images/ videos.


## Loading Data
### If the input data is a single video
*Optional: Select the channel for the numerator and denominator of the ratiometric image*

5. Make sure "Data Source" box has "Single" selected.
6. Click on video in listbox next to browse button.
7. Click "Load Video "and wait for vido to load into memory.
8. Go through video frames with slider below image, find frame ranges (actual frame indexes) for image background and forground (before nanoparticles put on vs after). Pixel values are plotted on left of video axes.
9. Select range of frames for background with the image background slider (type in text boxes or use sliders).
10. Select range of frames for background with the image forground slider (type in text boxes or use sliders).
11. Background frames will be blurred and average together for background signal, forground frames will be blurred and averaged together for forground signal (flourescence and phosphorescence).

### If the input data is a pair of images/ videos
5. Make sure "Data Source" has "Dual" selected.
6. Click on BCK Img/Vid and browse to image or video source file of background file (before nanporticle added).
7. Click on FOR Img/Vid and browse to image or video source file of foreground data (after nanoparticle added).


## Analysis
11. Click calculate and ratiometric image will be calculated and displayed as heatmap image and average value is displayed in textbox below. Fraction of pixels used will also be displayed as a portion of ROI (or entire image if no ROI is set). Pixels without sufficient signal in both channels are eliminated because low signal makes ratios unreliable.
12. If an region of interest is needed, slick select ROI and define a polygon that encapusulates the wound, left click to add polygon verticies, right click to close polygon. Click calculate again to calcualte ratometric value in ROI.
13. If the range of the ratiometric values need to be changed, use the slider on the right side of the ratiometric image.
14. Save data if needed.

## Algorithm
1. For the numerator channel, the foreground and background image are blurred with an averaging filtering with the "Blur Radius" specified.
2. The blurred background image is subtracted from the blurred foreground image.
3. Steps 1 and 2 are repeated for the Denominator channel.
4. The pixels are each filtered with the user specified thresholds for numerator and denominator channels (included pixels must be *x* above background when subtracted).
5. Pixels that pass for both channels are used, the numerator pixels are divided by the denominator pixels, this image is displayed as the ratiometric image.
6. The mean ratio is displayed below the output image axes.


## Other output
The mean and std of selected pixels are also displayed for each channel.

Ratio channels are defined as Numerator/ Denomintor.
* Display Box 1: Ratiometric Values
** Displays ratiometric value with channels selected (e.g. B/R), reports mean of ratiometric values calculated pixel-by pixel.
** Fraction of pixels used is the fraction of pixels that pass the threshold values for each channel above background *and* within the ROI, divided by total image area (not ROI area).
* Display Box 2: Values for Numerator Channel
** Reports mean pixels values for background subtracted image, foreground image, and background image of Numerator channel. Note that pixel filtering *is still done for these values* (even if the background subtration is disabled, the foreground pixels must still be above the threshold values).
* Display Box 3: Values for Denominator Channel
** Reports mean pixels values for background subtracted image, foreground image, and background image of the Denominator Channel. Note that pixel filtering *is still done for these values* (even if the background subtration is disabled the foreground pixels must still be above the threshold values).
* *So to get the same values for the foreground image with and without background subtraction, the Thresholds for Numerator and Denominator must be set to -255 to insure no pixel filtering.



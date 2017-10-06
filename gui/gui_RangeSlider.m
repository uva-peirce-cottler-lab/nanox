function [hcomponent, hcontainer, rangeSlider] = gui_RangeSlider(val_range,...
    pos,label,orient,min_textbox, max_textbox,handles)
    % Add the 3rd Party Jar, should use static path but for the example, we
    % use dynamic
    proj_path = getappdata(handles.figure_nanoxim,'proj_path');
    javaaddpath([proj_path '\gui\jide_demo.jnlp']);

    import com.jidesoft.plaf.LookAndFeelFactory;
    import com.jidesoft.swing.JideButton;
    import com.jidesoft.swing.JideSwingUtilities;
    import com.jidesoft.swing.RangeSlider;
    import com.jidesoft.swing.SelectAllUtils;

    import javax.swing.*;
    import javax.swing.event.ChangeEvent;
    import javax.swing.event.ChangeListener;
    import java.awt.*;
    import java.awt.event.ItemEvent;
    import java.awt.event.ItemListener;

    rangeSlider = RangeSlider(val_range(1), val_range(2), ...
        val_range(1), val_range(2));
    rangeSlider.setOrientation(~strcmp(orient,'horizontal'));
    rangeSlider.setPaintTicks(true);
    rangeSlider.setPaintLabels(true);
    rangeSlider.setPaintTrack(true);
    rangeSlider.setRangeDraggable(false);
    rangeSlider.setMajorTickSpacing(50);
    rangeSlider = handle(rangeSlider, 'CallbackProperties');

    
    set(min_textbox,'String',num2str(val_range(1)));
    set(max_textbox,'String',num2str(val_range(2)));
    
    function updateTextValues(~, ~)
        set(min_textbox, 'String',num2str(rangeSlider.getLowValue()));
        set(max_textbox, 'String',num2str(rangeSlider.getHighValue()));

        if strcmp(label,'RAT')
            gui_UpdateRatiomImage(handles.axes_ratiom,handles)
        end
    end

    rangeSlider.StateChangedCallback = @updateTextValues;
    
    panel = JPanel(BorderLayout());
    if strcmp(orient,'horizontal')
        panel.add(rangeSlider, BorderLayout.CENTER);
%         panel.add(textFieldPanel, BorderLayout.WEST);
    else
        panel.add(rangeSlider, BorderLayout.CENTER);
%         panel.add(textFieldPanel, BorderLayout.NORTH);
    end
    
    % hcontainer can be used to interact with panel like uicontrol
    [hcomponent, hcontainer] = javacomponent(panel, pos, gcf);
 
end
function [hcomponent, hcontainer, rangeSlider] = gui_RangeSlider(val_range,...
    pos,label,orient,handles)
    % Add the 3rd Party Jar, should use static path but for the example, we
    % use dynamic
    javaaddpath('C:\Users\bac\Documents\Repo nanoxim\gui\jide_demo.jnlp')

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

    labelField = JTextField();
    minField = JTextField();
    maxField = JTextField();
    SelectAllUtils.install(labelField);
    SelectAllUtils.install(minField);
    SelectAllUtils.install(maxField);

    rangeSlider = RangeSlider(val_range(1), val_range(2), ...
        val_range(1), val_range(2));
    rangeSlider.setOrientation(~strcmp(orient,'horizontal'));
    rangeSlider.setPaintTicks(true);
    rangeSlider.setPaintLabels(true);
    rangeSlider.setPaintTrack(true);
    rangeSlider.setRangeDraggable(false);
    rangeSlider.setMajorTickSpacing(20);
    rangeSlider = handle(rangeSlider, 'CallbackProperties');

    function updateValues(~, ~)
        minField.setText(num2str(rangeSlider.getLowValue()));
        maxField.setText(num2str(rangeSlider.getHighValue()));
        if strcmp(label,'RAT')
            gui_UpdateRatiomImage(handles)
        end
    end

    rangeSlider.StateChangedCallback = @updateValues;

    minField.setText(num2str(rangeSlider.getLowValue()));
    maxField.setText(num2str(rangeSlider.getHighValue()));

    % Min and max panels
    minPanel = JPanel(BorderLayout());
    minField.setEditable(false);
    minPanel.add(minField);
    
    maxPanel = JPanel(BorderLayout());
    maxField.setEditable(false);
    maxPanel.add(maxField);

    if strcmp(orient,'horizontal')
        textFieldPanel = JPanel(GridLayout(1, 3));
    else
        textFieldPanel = JPanel(GridLayout(3, 1));
    end
    
    
    textFieldPanel.add(JLabel(label));
    textFieldPanel.add(minPanel);
    textFieldPanel.add(maxPanel);

    
    panel = JPanel(BorderLayout());
    if strcmp(orient,'horizontal')
        panel.add(rangeSlider, BorderLayout.CENTER);
        panel.add(textFieldPanel, BorderLayout.WEST);
    else
        panel.add(rangeSlider, BorderLayout.CENTER);
        panel.add(textFieldPanel, BorderLayout.NORTH);
    end
    
    % hcontainer can be used to interact with panel like uicontrol
    [hcomponent, hcontainer] = javacomponent(panel, pos, gcf);
 
end
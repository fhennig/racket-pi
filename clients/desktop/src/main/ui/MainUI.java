package main.ui;
import java.io.IOException;

import javafx.beans.value.ChangeListener;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Slider;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import main.logic.ColorSetterService;
import main.logic.Led;

public class MainUI
{

    @FXML
    private ComboBox<Led> _specificLedCB;

    @FXML
    private Slider _redSlider;

    @FXML
    private Slider _greenSlider;
    
    @FXML
    private Slider _blueSlider;

    private ColorSetterService _css = new ColorSetterService();
    

    
    public MainUI(final Stage stage) throws IOException
    {
    	FXMLLoader loader = new FXMLLoader(getClass().getResource("MainUI.fxml")); 
    	loader.setController(this);
    	Parent rootNode = loader.load();
    	
    	assert _specificLedCB != null;
    	assert _blueSlider != null;
    	assert _redSlider != null;
    	assert _greenSlider != null;
    	
    	Scene mainScene = new Scene(rootNode);
    	stage.setScene(mainScene);
    	stage.setTitle("LedColorSetter");
    	stage.setWidth(500);
    	stage.setHeight(300);
    	
    	initControls();
    	initListeners();

    	stage.show();
    }
    
    private void initControls()
    {
    	_specificLedCB.setItems(_css.getLeds());
    	if (_css.getLeds().size() > 0)
    		_specificLedCB.getSelectionModel().selectFirst();
    }
    
    private void initListeners()
    {
    	ChangeListener<Number> listener = (o, n1, n2) -> colorChangedHandler();
    	_redSlider.valueProperty().addListener(listener);
    	_greenSlider.valueProperty().addListener(listener);
    	_blueSlider.valueProperty().addListener(listener);
    }
    
    private void colorChangedHandler()
    {
    	Led l = _specificLedCB.getSelectionModel().getSelectedItem();
    	if (l == null)
    		return;
    	
    	l.setColor(new Color(_redSlider.getValue(), _greenSlider.getValue(), _blueSlider.getValue(), 1));
    }
}
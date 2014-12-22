package main.logic;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyIntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.scene.paint.Color;

public class Led
{
	private IntegerProperty _id = new SimpleIntegerProperty();
	private ObjectProperty<Color> _color = new SimpleObjectProperty<Color>();
	
	
	
	public Led(int id)
	{
		_id.set(id);
		setColor(Color.BLACK);
	}
	
	
	
	public int getId() { return _id.get(); }	
	public ReadOnlyIntegerProperty idProperty()	{ return _id; }
	
	public void setColor(Color c) { _color.set(c); }
	public Color getColor()	{ return _color.get(); }
	public ObjectProperty<Color> colorProperty() { return _color; }
	
	@Override
	public String toString()
	{
		return new Integer(getId()).toString();
	}
}

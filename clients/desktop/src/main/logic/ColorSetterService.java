package main.logic;

import java.io.IOException;

import javafx.beans.property.ReadOnlyListWrapper;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

public class ColorSetterService
{
	private ReadOnlyListWrapper<Led> _leds = new ReadOnlyListWrapper<Led>(FXCollections.observableArrayList());
	private CloseableHttpClient _httpClient = HttpClients.createDefault();
	
	
	
	public ColorSetterService()
	{
		initAvailableLeds();
	}
	
	
	
	private void initAvailableLeds()
	{
		for (int i = 0; i < 4; i++)
		{
			final Led l = new Led(i);
			l.colorProperty().addListener(e -> colorChangedHandler(l));
			_leds.add(l);
		}
	}
	
	private void colorChangedHandler(Led l)
	{
		String url = String.format("http://raspberrypi/set/%d/%f/%f/%f", l.getId(), l.getColor().getRed(),
																					l.getColor().getGreen(),
																					l.getColor().getBlue());
		
		try
		{
			HttpGet httpGet = new HttpGet(url);
			CloseableHttpResponse response1 = _httpClient.execute(httpGet);
			response1.close();
		} catch (IOException ex)
		{
			System.out.println(ex);
		}
	}
	
	public ObservableList<Led> getLeds() { return _leds.getReadOnlyProperty(); }
}

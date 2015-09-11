package tutormodel;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GraphicsEnvironment;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JComponent;
import javax.swing.JPanel;

// the visual representation of the tutor
public class VisualTutor extends JPanel {
	
	private String name;
	private Image image;
	
	public VisualTutor() {
		name = "Atibo";
		try {
			image = ImageIO.read(new File("img/tutor.bmp"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (image == null) 
			System.out.println("[VisualTutor] image null");
	}
	
	@Override
	public Dimension getPreferredSize() {
		 if (image == null) {
             return new Dimension(100,100);
        } else {
           return new Dimension(image.getWidth(null), image.getHeight(null));
       }
	}
	
	@Override
	public void paint(Graphics g) {
		g.drawImage(image, 0, 0, null);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Image getImage() {
		return image;
	}

	public void setImage(Image image) {
		this.image = image;
	}

	
}

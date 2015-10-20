package caligraph;

import domainmodel.Topic;

/**
 * Resources to teach the specified topic (e.g. for calligraphy, a character)
 * @author micky
 *
 */
public class Character extends Topic {
	String coordinatesFilename;
	String imageFilename;
	
	public Character(String topicName) {
		super(topicName);
	}
	
	public Character(String topicName, String coordinatesFilename, String imageFilename) {
		super(topicName);
		this.coordinatesFilename = coordinatesFilename;
		this.imageFilename = imageFilename;
	}
	
	public String getCoordinatesFilename() {
		return coordinatesFilename;
	}
	public void setCoordinatesFilename(String coordinatesFilename) {
		this.coordinatesFilename = coordinatesFilename;
	}
	public String getImageFilename() {
		return imageFilename;
	}
	public void setImageFilename(String imageFilename) {
		this.imageFilename = imageFilename;
	}
	
}

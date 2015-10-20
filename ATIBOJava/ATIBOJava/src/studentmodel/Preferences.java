package studentmodel;

import tutormodel.VisualTutor;

public class Preferences {
	
	// possible themes that the student may prefer
	public final static String ANIMALS = "animale";
	public final static String PLANTS = "plante";
	public final static String TRANSPORT = "transport";
	
	// favorite character
	// to be chosen from a list of given characters
	// the tutor takes the form of this character
	private VisualTutor character;
	private String color;
	private String theme;
}

package caligraph;

import java.util.ArrayList;

import domainmodel.Course;
import domainmodel.Topic;

public class CalligraphyCourse extends Course {

	public CalligraphyCourse() {
		super("Caligrafie");
		initCalligraphyCourse();
	}
		
	private void initCalligraphyCourse() {
		topics = new ArrayList<Topic>();
		topics.add(new Character("Litera a mic", "LitereModel/Amic.txt", "LitereModel/Amic.png"));
		topics.add(new Character("Litera A mare", "LitereModel/Amare.txt", "LitereModel/Amare.png"));
		topics.add(new Character("Litera b mic", "LitereModel/Bmic.txt", "LitereModel/Bmic.png"));
		topics.add(new Character("Litera B mare", "LitereModel/Bmare.txt", "LitereModel/Bmare.png"));
		topics.add(new Character("Litera c mic", "LitereModel/Cmic.txt", "LitereModel/Cmic.png"));
		topics.add(new Character("Litera C mare", "LitereModel/Cmare.txt", "LitereModel/Cmare.png"));		
	}
	
}

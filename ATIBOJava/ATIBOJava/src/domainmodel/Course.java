package domainmodel;

import java.util.ArrayList;

/**
 * @author micky
 * Copyright ATIBO 2013-2015
 *
 */
public abstract class Course {
	
	public final static int CALLIGRAPHY = 1;
	
	protected String title;
	protected ArrayList<Topic> topics;
	
	public Course(String title) {
		this.title = title;
	}
	
	public Course(ArrayList<Topic> topics) {
		this.topics = topics;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public ArrayList<Topic> getTopics() {
		return topics;
	}

	public void setTopics(ArrayList<Topic> topics) {
		this.topics = topics;
	}
	
	public Topic getTopic(int index) {
		return topics.get(index);
	}
	
}

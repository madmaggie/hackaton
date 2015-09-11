
package domainmodel;

/**
 * @author micky
 * Copyright ATIBO 2013-2015
 *
 */
public class Topic {
	
	protected String topicName;
	
	public Topic() {
		topicName = null;
	}
	
	public Topic(String name) {
		this.topicName = name;
	}
	
	public String getTopicName() {
		return topicName;
	}
	
	public void setTopicName (String name) {
		this.topicName = name;
	}	
	
}

package studentmodel;

import java.util.ArrayList;

import tutormodel.CognitiveEvaluation;
import tutormodel.Grade;
import domainmodel.Topic;

public class Student {
	
	public final static int BOY = 0;
	public final static int GIRL = 1;
	
	/* ******************** personal data *************************/
	//private long id;
	private String user;
	private String pass;
	private String firstname;
	private String lastname;
	private double age;
	private int sex;
	
	/* ************* cognitive knowledge **************************/	
	private ArrayList<CognitiveEvaluation> knowledge;
	
	
	/* ************* affective knowledge **************************/
	private ArrayList<Emotion> emotions; // currently not used
	private Preferences preferences; // currently not used
	private Emotion affectivestate; // positive / negative
	private Personality personality;

		
	
	
	/* ************************ constructors *****************************************/
	
	public Student(String user, String firstname, String lastname, double age, int sex) {
		this.user = user;
		this.firstname = firstname;
		this.lastname = lastname;
		this.age = age;
		this.sex = sex;
	}
	
	
	
	public Grade getTopicAvgGrade(Topic topic) {
		int index = knowledge.indexOf(topic);
		return knowledge.get(index).getAvgGrade();
	}

	
	/* ************************ getters  setters *****************************************/

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public double getAge() {
		return age;
	}

	public void setAge(double age) {
		this.age = age;
	}

	public int getSex() {
		return sex;
	}

	public void setSex(int sex) {
		this.sex = sex;
	}
		
	public ArrayList<CognitiveEvaluation> getKnowledge() {
		return knowledge;
	}

	public void addCognitiveEvaluation(CognitiveEvaluation ce) {
		if (knowledge == null)
			knowledge = new ArrayList<CognitiveEvaluation>();
		knowledge.add(ce);
	}
	
	public void setKnowledge(ArrayList<CognitiveEvaluation> knowledge) {
		this.knowledge = knowledge;
	}

	public ArrayList<Emotion> getEmotions() {
		return emotions;
	}

	public void setEmotions(ArrayList<Emotion> emotions) {
		this.emotions = emotions;
	}

	public Emotion getAffectivestate() {
		return affectivestate;
	}

	public void setAffectivestate(Emotion affectivestate) {
		this.affectivestate = affectivestate;
	}

	public Preferences getPreferences() {
		return preferences;
	}

	public void setPreferences(Preferences preferences) {
		this.preferences = preferences;
	}

	public Personality getPersonality() {
		return personality;
	}

	public void setPersonality(Personality personality) {
		this.personality = personality;
	}

}

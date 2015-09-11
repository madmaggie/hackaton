package tutormodel;

import java.util.ArrayList;

import domainmodel.Exercise;
import domainmodel.Topic;
import studentmodel.Student;

/**
 * The assessment of a specific student answering a specific topic in a specific learning session.
 * E.g. for the calligraphy course, letter 'A' is a topic and a student has to write several 'A' letters in a session,
 * which are then graded. The grades are only internal, not shown to the child. The pupil has to repeatedly write sets of letters (sessions)
 * because thus the chances to remember the topic are higher.   
 * @author micky
 *
 */

public class CognitiveEvaluation {
	
	private Topic topic;
	// NEACHIZITIONAT, IN_CURS_DE_ACHIZITIE, ACHIZITIONAT
	private ArrayList<Exercise> exercises;
	public Grade avgGrade;

	public CognitiveEvaluation() {
		this.exercises = new ArrayList<Exercise>();
		avgGrade = new Grade(Grade.NEEVALUAT);
	}
	
	public CognitiveEvaluation(String topicname) {
		topic = new Topic(topicname);
	}
	
	public void addExercise(Exercise exercise) {
		if (exercises == null)
			exercises = new ArrayList<Exercise>();
		exercises.add(exercise);
		if (exercise.getGrade().getGrade() != Grade.NEEVALUAT)
			computeAvg();
	}
		
	public Grade getGrade(int index) {
		return exercises.get(index).getGrade();
	}

	public void setGrade(Grade grade, int index) {
		boolean b = (this.exercises.get(index).getGrade().getGrade() == Grade.NEEVALUAT);
		this.exercises.get(index).setGrade(grade);
		if (b)
			computeAvg();
	}
	
	public void setGrade(int grade, int index) {
		this.exercises.get(index).setGrade(new Grade(grade));
	}
	
	public Topic getTopic() {
		return topic;
	}

	public void setTopic(Topic topic) {
		this.topic = topic;
	}

	public ArrayList<Exercise> getExercises() {
		return exercises;
	}

	public void setExercises(ArrayList<Exercise> exercises) {
		this.exercises = exercises;
	}

	public Grade getAvgGrade() {
		return avgGrade;
	}

//	public void setAvgGrade(Grade avgGrade) {
//		this.avgGrade = avgGrade;
//	}

	private void computeAvg() {
		if (avgGrade == null)
			avgGrade = new Grade();
		if (exercises.size() > 0)
			avgGrade.setGrade(exercises.get(0).getGrade().getGrade());
		if (exercises.size() > 1) {
			for (int i=1; i<exercises.size(); i++)
				avgGrade.setGrade(avgGrade.getGrade() + exercises.get(i).getGrade().getGrade());
			avgGrade.setGrade(avgGrade.getGrade()/exercises.size());
		}		
	}
	
	public String gradesList() {
		String list = "";
		for (int i=0; i<exercises.size(); i++) {
			switch (exercises.get(i).getGrade().getGrade()) {
			case Grade.ACHIZITIONAT: list += "ACQ ";
									 break;
			case Grade.NEACHIZITIONAT: list += "NACQ ";
									   break;
			case Grade.IN_CURS_DE_ACHIZITIE: list += "CRTACQ ";
											 break;
			case Grade.NEEVALUAT: list += "NEV ";
								  break;
			}
		}
		return list;
	}
}

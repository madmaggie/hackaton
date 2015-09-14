package tutormodel;

import java.io.File;
import java.util.ArrayList;

import javax.swing.JOptionPane;
import javax.swing.JPanel;

// net.sf.clipsrules.jni ---> CLIPSJNI
import net.sf.clipsrules.jni.Environment;
import net.sf.clipsrules.jni.FactAddressValue;
import studentmodel.Emotion;
import studentmodel.Student;
import caligraph.CalligraphyCourse;
import caligraph.Character;
import domainmodel.Course;
import emotionrecognition.DumbEmotionGenerator;


/* 
 * TODO: LearningEnvironment (abstract class / interface) in domainmodel?
 * to handle events: when student finishes exercise, tutor must automatically evaluate it and provide feedback
 * when student is not capable of finishing (bored, tired, needs hint etc) tutor must take initiative offering alternatives to the student
 * for now, we use the "next" button (in CalligraphView)
 */


/*
 * Calligraphy Specific Actions
 * 
 * CharacterView ---> CharacterComputations.evaluateSymbol (1 symbol = 1session = many characters)
 * for each character in symbol/session compute dtw distances (with matlab shared libraries .so) + 
 * width, height, displacement, and use them all to create CharacterEvaluation object.
 * CharacterEvaluation computes grade using CLIPS rules (characterEvaluationRules.clp)
 * 
 * General Tutoring Decisions
 * 
 * Tutor uses grade computed for current session and grades for previous sessions (student cognitive state) +
 * student affective state and makes a decision using CLIPS rules (pedagogicalRules.clp)
 * 
 */


public class Tutor implements Runnable {
	
	public final static int ACTIVE = 0;
	public final static int IDLE = 1;
	public final static int KILLED = 2;
	
	//The Object used for synchronization among threads.
    public final static Object obj = new Object();
	
	// as long as it is ACTIVE, tutor must run continuously
	// he (its thread) "dies" only when SUSPENDED
	// for now only ACTIVE and SUSPENDED states are used
	// IDLE has yet to be defined (is it needed?)
	private int state;
	
	private Course course;
	private int crtTopic; // index in the list of topics of the course
	private Student student;
	private Action crtAction;
	private ATIBOView mainView;
	
	private ArrayList<Action> actions;
	
	private DumbEmotionGenerator emGen;
	
	
	public Tutor(Student student, ATIBOView view) {
		state = Tutor.ACTIVE;
		this.student = student;
		emGen = new DumbEmotionGenerator(student);
		this.mainView = view;
		this.actions = new ArrayList<Action>();
		
		System.out.println("[Tutor] user.dir = " + System.getProperty("user.dir"));
		System.out.println("[Tutor] java.library.path = " + System.getProperty("java.library.path"));
		System.out.println("[Tutor] jna.library.path = " + System.getProperty("jna.library.path"));
	}	

	@Override
	public synchronized void run() {
		System.out.println("[Tutor] M-am nascut! :)");
		System.out.println("[Tutor] user.dir = " + System.getProperty("user.dir"));
		synchronized (obj) {
			initCourse();
			while (state == Tutor.ACTIVE) {
				
				long t1 = System.currentTimeMillis();
				
				// wait for the child to write some letters and press "next" button
				try {
					obj.wait();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				long t2 = System.currentTimeMillis();
				
				System.out.println("[Tutor] t2-t1 = " + (t2-t1));
				
				
				/*if (t2-t1 >= 5000) {
					//JOptionPane.showMessageDialog(mainView.getView(), "Scrie, bre,  " + course.getTopic(crtTopic).getTopicName() +"!",
					//		"Te gandesti cam mult...", JOptionPane.PLAIN_MESSAGE, new ImageIcon("img/woman-thinking-small.jpg"));
					JOptionPane.showMessageDialog(new JFrame(), "Scrie, bre,  " + course.getTopic(crtTopic).getTopicName() +"!");
					System.out.println("inca sunt in if");
				}
				
				else {*/
				
					detectEmotion();
					
					System.out.println("[Tutor] am detectat emotia");
					
					decideNextStep();
					
					System.out.println("[Tutor] am decis next step");
					
					doNextStep();
					
					System.out.println("[Tutor] am executat next step");
					
					
					//System.out.println("Si-acu o sa mor :(");
					//state = Tutor.SUSPENDED;
				/*}
				System.out.println("am iesit din if");*/
			}
		}
		
	}
	
	private void initCourse() {
		if (mainView.getView() == null) {
			try {
				obj.wait();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if (course == null) {
			System.out.println("[Tutor] course null");
			if (mainView.getCourseType() == Course.CALLIGRAPHY) {
				System.out.println("[Tutor] creem cursul de caligrafie");
				course = new CalligraphyCourse();
				crtTopic = 0;
				mainView.getView().setTopicIndex(crtTopic);
				mainView.getView().setFilename(((Character) course.getTopic(crtTopic)).getCoordinatesFilename());
				System.out.println("[Tutor] student = " + student);
				mainView.getView().setStudent(student);
			}
		}
		
		teachTopic();
	}
	
	private void teachTopic() {
		System.out.println("[Tutor] Uite cum se face " + course.getTopic(crtTopic).getTopicName());
		if (mainView.getCourseType() == Course.CALLIGRAPHY) {
			//mainView.getView().getPaper(0).drawCharacter(((Character) course.getTopic(crtTopic)).getCoordinatesFilename());
		}
		
	}
	
	private void detectEmotion() {
		int r = (int)Math.round(2*Math.random());
		switch (r) {
			case 0: emGen.setStudentEmotion(new Emotion(Emotion.NEGATIVE));
					System.out.println("[Tutor] " + Emotion.NEGATIVE);
					break;
			case 1: emGen.setStudentEmotion(new Emotion(Emotion.POSITIVE));
					System.out.println("[Tutor] " + Emotion.POSITIVE);
					break;
			case 2: emGen.setStudentEmotion(new Emotion(Emotion.NEUTRAL));
					System.out.println("[Tutor] " + Emotion.NEUTRAL);
					break;
		}
	}
	
	private void decideNextStep() {
		
		System.out.println("[Tutor] sa vedem ce facem acu.. ");
		String messageString = "";
				
		Environment clips = new Environment();
		clips.reset();
		//clips.load("./src/tutormodel/pedagogicalRules.clp");
		clips.load("./clips/pedagogicalRules.clp");
		clips.reset();
		
		System.out.println("[Tutor] grades: " + student.getKnowledge().get(crtTopic).gradesList());
		System.out.println("[Tutor] gradesNo " + student.getKnowledge().get(crtTopic).getExercises().size());
		System.out.println("[Tutor] avggrade:" + student.getKnowledge().get(crtTopic).getAvgGrade().toClipsGrade());
		System.out.println("[Tutor] previous actions: " + actionsToClipsActions(actions));
		
		FactAddressValue fav = clips.assertString("(cognitiveEvaluation " +
					" (topic " + crtTopic + ")" +
					" (grades " + student.getKnowledge().get(crtTopic).gradesList() + ")" +
					" (gradesNo " + student.getKnowledge().get(crtTopic).getExercises().size() + ")" +
					" (avgGrade " + student.getKnowledge().get(crtTopic).getAvgGrade().toClipsGrade() + "))");
		
		System.out.println("[Tutor] (cognitiveEvaluation " +
					" (topic " + crtTopic + ")" +
					" (grades " + student.getKnowledge().get(crtTopic).gradesList() + ")" +
					" (gradesNo " + student.getKnowledge().get(crtTopic).getExercises().size() + ")" +
					" (avgGrade " + student.getKnowledge().get(crtTopic).getAvgGrade().toClipsGrade() + "))");
		System.out.println("[Tutor] fav = " + fav);
		
		clips.assertString("(emotion " + student.getAffectivestate().toClipsEmotion() + ")");

		clips.assertString("(previous-actions " + actionsToClipsActions(actions) + ")");

		System.out.println("[Tutor] clips.eval = " + clips.eval("watch all"));
		clips.run();
		
		try {
			String evalString = "(do-for-fact ((?a action)) TRUE ?a:name)";
			//System.out.println(clips.eval(evalString).toString());
			crtAction = new Action(clips.eval(evalString).toString());
		} catch (Exception e) {
			e.printStackTrace();
			crtAction = new Action(Action.NONE);
		}
		

		if (crtAction!=null) {
			//actions.add(crtAction);
			messageString += crtAction.toString() + "\n";
		}
		
		try {
			String evalString = "(do-for-fact ((?a answer)) TRUE ?a:text)";
			messageString += clips.eval(evalString).toString();
		} catch (Exception e) {
			e.printStackTrace();
			//crtAction = new Action(Action.NONE);
		}
		
		JOptionPane.showMessageDialog(new JPanel(), messageString);
		
		/*//System.out.println(clips.eval("(find-all-facts ((?f answer)) TRUE)"));
		PrimitiveValue answerObject = clips.eval("(find-all-facts ((?f action)) TRUE)");
		System.out.println(answerObject);
		try {
			if (answerObject != null && answerObject.size()>0) {
				answerObject = answerObject.get(0);			    
				String answer = answerObject.getFactSlot("mark").toString();
				answer += "\nTall: " + answerObject.getFactSlot("tall").toString();
				answer += "\nShort: " + answerObject.getFactSlot("short").toString();
				answer += "\nWide: " + answerObject.getFactSlot("wide").toString();
				answer += "\nNarrow: " + answerObject.getFactSlot("narrow").toString();
				answer += "\nUp: " + answerObject.getFactSlot("up").toString();
				answer += "\nDown: " + answerObject.getFactSlot("down").toString();
				answer += "\nLeft: " + answerObject.getFactSlot("left").toString();
				answer += "\nRight: " + answerObject.getFactSlot("right").toString();
				answer += "\nTilt: " + answerObject.getFactSlot("tilt").toString();
				answer += "\nShape: " + answerObject.getFactSlot("shape").toString();
				JOptionPane.showMessageDialog(new JFrame(), answer);
			}
			else
				JOptionPane.showMessageDialog(new JFrame(), "smth's wrong..");
		}
		catch (Exception e) {
			e.printStackTrace();
		}*/
	}
	
	private void doNextStep() {
		System.out.println("[Tutor] Add " + crtAction + " to action list");
		actions.add(crtAction);
		switch (crtAction.getAction()) {
			case Action.NEXT_SESSION: {
				mainView.getView().reset();
				break;
			}
			case Action.NEXT_TOPIC: {
				// set current topic - in CaligraphCourse and CalligraphView
				crtTopic++;
				mainView.getView().setTopicIndex(crtTopic);
				mainView.getView().getTopicPaper().reset();
				mainView.getView().reset();
				mainView.getView().setFilename(((Character) course.getTopic(crtTopic)).getCoordinatesFilename());
				teachTopic();
				break;
			}
			case Action.HINT: {
				mainView.getView().reset();
				teachTopic();
				break;
			}
			case Action.RELAX: {
				mainView.getView().reset();				
				break;
			}
			case Action.NONE: {
				System.out.println("[Tutor] nu fac nimic...");
				break;
			}
		}
	}
	
	private String actionsToClipsActions(ArrayList<Action> actions) {
		String result = "";
		if (actions != null && actions.size()>0) {
			for (int i=0; i<actions.size(); i++) {
				switch (actions.get(i).getAction()) {
					case Action.NEXT_SESSION: {
						result += "CONTINUE ";
						break;
					}
					case Action.NEXT_TOPIC: {
						result += "NEXT ";
						break;
					}
					case Action.HINT: {
						result += "HINT ";
						break;
					}
					case Action.RELAX: {
						result += "RELAX ";
						break;
					}
				}				
			}
		}
		return result;
	}
	
	public static void main(String[] args) {
			
		Student micky = new Student("micky", "mihaela", "mihaela", 30, Student.GIRL);
		File folder = new File("./" + micky.getUser());
		
		if (!folder.exists()) {
			folder.mkdir();
		}
		
		ATIBOView view = new ATIBOView();
				
		new Thread(new Tutor(micky, view)).start();
	}

}

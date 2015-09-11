package tutormodel;

public class Action {

	public final static String NONE = "NONE";
	// go to the next level
	public final static String NEXT_TOPIC = "NEXT";
	// keep writing the same letter
	public final static String NEXT_SESSION = "CONTINUE";
	// show instructions on how to write a letter
	public final static String HINT = "HINT";
	// show entertaining stuff to relax the (tired/bored) child
	public final static String RELAX = "RELAX";
	
	private String action;

	public Action(String action) {
		this.action = action;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}
	
	@Override
	public String toString() {
		String answer = "NOTHING";
		switch (action) {
			case NEXT_TOPIC: answer = "go to next topic";
							 break;
			case NEXT_SESSION: answer = "continue to write this letter";
							   break;
			case HINT: answer = "this is how you write this letter: ";
					   break;
			case RELAX: answer = "maybe we should take a break from wwriting";
						break;
			case NONE: answer = "just keep doing what u were doing..";
					   break;
		}
		return answer;
	}
}

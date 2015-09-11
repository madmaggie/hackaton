package tutormodel;

public class Grade {
	
	public final static int NEEVALUAT = -1;
	public final static int NEACHIZITIONAT = 0;
	public final static int IN_CURS_DE_ACHIZITIE = 1;
	public final static int ACHIZITIONAT = 2;
	
	private int grade;
	private Reason reason;
	
	public Grade() {
		this.grade = NEEVALUAT;
		this.reason = null;
	}
	
	public Grade(int grade) {
		this.grade = grade;
		this.reason = null;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public Reason getReason() {
		return reason;
	}

	public void setReason(Reason reason) {
		this.reason = reason;
	}
	
	public boolean isGraded() {
		return (grade >= 0);
	}
	
	public boolean hasReason() {
		return (reason != null);
	}
	
	public String toClipsGrade() {
		String result = "";
		switch (grade) {
			case Grade.ACHIZITIONAT: result = "ACQ ";
									 break;
			case Grade.NEACHIZITIONAT: result = "NACQ ";
									   break;
			case Grade.IN_CURS_DE_ACHIZITIE: result = "CRTACQ ";
			 								 break;
			case Grade.NEEVALUAT: result = "NEV ";
								  break;
		}
		return result;
	}
	
}

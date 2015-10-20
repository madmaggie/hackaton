package caligraph;

import domainmodel.Exercise;
import tutormodel.Grade;

public class CharacterEvaluation extends Exercise {
	// ratio - test letter height over model letter height
	private double heightDiff;
	// ratio - test letter width over model letter width
	private double widthDiff;
	private double xDisplacement;
	private double yDisplacement;
	// DTW distances
	private double distX;
	private double distY;
	private double distU;
	private double distR;
	
	
	public CharacterEvaluation(double xDisplacement, double yDisplacement, double heightDiff, double widthDiff,
			double distX, double distY, double distU, double distR) {
		this.xDisplacement = xDisplacement;
		this.yDisplacement = yDisplacement;
		this.heightDiff = heightDiff;
		this.widthDiff = widthDiff;
		this.distX = distX;
		this.distY = distY;
		this.distU = distU;
		this.distR = distR;
	}
	
	public void computeGrade() {
		
		// formula that gives a value between 0 and 1 (inclusive)
		/*double simpleIneffiecientInexactIncorrectFormulaInventedJustToHaveSomethingToTest =
				0.15*xDisplacement + 0.15*yDisplacement + 0.10*widthDiff + 0.10*heightDiff +
				0.15*distX + 0.15*distY + 0.10*distU * 0.10*distR;
		
		System.out.println("simpleIneffiecientInexactIncorrectFormulaInventedJustToHaveSomethingToTest=" +
							simpleIneffiecientInexactIncorrectFormulaInventedJustToHaveSomethingToTest);
		
		if (simpleIneffiecientInexactIncorrectFormulaInventedJustToHaveSomethingToTest > 0.7) {
			grade = new Grade(Grade.NEACHIZITIONAT);
		}
		else {
			if (simpleIneffiecientInexactIncorrectFormulaInventedJustToHaveSomethingToTest > 0.3) {
				grade = new Grade(Grade.IN_CURS_DE_ACHIZITIE);
			}
			else {
				grade = new Grade(Grade.ACHIZITIONAT);
			}
		}*/
		
		
		System.out.println("[CharacterEvaluation] grade = " + grade.getGrade());
				
	}
	
	
	public double computeGrade(double[] thresholds) {		

		// formula that gives a value between 0 and 1 (inclusive)
		double felixFormula = 0.45*distX + 0.45*distY + 0.08*distU * 0.02*distR;
		
		if (thresholds != null && thresholds.length == 2) {		
			if (felixFormula <= thresholds[0]) {
				grade = new Grade(Grade.ACHIZITIONAT);
			}
			else {
				if (felixFormula < thresholds[1]) {
					grade = new Grade(Grade.IN_CURS_DE_ACHIZITIE);
				}
				else {
					grade = new Grade(Grade.NEACHIZITIONAT);
				}
			}
		}
		System.out.println("[CharacterEvaluation] grade = " + grade.getGrade());
		
		return felixFormula;				
	}
	
	
	public double getHeightDiff() {
		return heightDiff;
	}
	
	public void setHeightDiff(double heightDiff) {
		this.heightDiff = heightDiff;
	}
	
	public double getWidthDiff() {
		return widthDiff;
	}
	
	public void setWidthDiff(double widthDiff) {
		this.widthDiff = widthDiff;
	}
	
	public double getxDisplacement() {
		return xDisplacement;
	}

	public void setxDisplacement(double xDisplacement) {
		this.xDisplacement = xDisplacement;
	}

	public double getyDisplacement() {
		return yDisplacement;
	}

	public void setyDisplacement(double yDisplacement) {
		this.yDisplacement = yDisplacement;
	}

	public double getDistX() {
		return distX;
	}
	
	public void setDistX(double distX) {
		this.distX = distX;
	}
	
	public double getDistY() {
		return distY;
	}
	
	public void setDistY(double distY) {
		this.distY = distY;
	}
	
	public double getDistU() {
		return distU;
	}
	
	public void setDistU(double distU) {
		this.distU = distU;
	}
	
	public double getDistR() {
		return distR;
	}
	
	public void setDistR(double distR) {
		this.distR = distR;
	}
	
	@Override
	public String toString() {
		String result = "";
		switch (grade.getGrade()) {
			case Grade.ACHIZITIONAT: {
				result = "ACHIZITIONAT";
				break;
			}
			case Grade.NEACHIZITIONAT: {
				result = "NEACHIZITIONAT";
				break;
			}
			case Grade.IN_CURS_DE_ACHIZITIE: {
				result = "IN_CURS_DE_ACHIZITIE";
				break;
			}
		}
		return result+"\n";
	}
}

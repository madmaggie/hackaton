package domainmodel;

import tutormodel.Grade;

public class Exercise {
	
	protected String requirement; // currently not used
	protected Object solution; // currently not used
	protected Grade grade;
	
	public String getRequirement() {
		return requirement;
	}
	
	public void setRequirement(String requirement) {
		this.requirement = requirement;
	}
	
	public Object getSolution() {
		return solution;
	}
	
	public void setSolution(Object solution) {
		this.solution = solution;
	}
	
	public Grade getGrade() {
		return grade;
	}
	
	public void setGrade(Grade grade) {
		this.grade = grade;
	}
	
	
}

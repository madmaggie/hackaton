package studentmodel;

public class CristiPsihologPersonality {
	// temperament & learning style
	int extraversion; // 0 = introvert, 1 = extrovert
	int activism; // 0 = not active; 1 = active
	int emotivity; // 0 = not emotional, 1 = emotional
	int adaptability; // 0 = not easy adaptable, 1 = easy adaptable
	int understanding; // 1 = global/analytic, 0 = sequentially/holistic
	
	public CristiPsihologPersonality(int extraversion,
						int activism,
						int emotivity,
						int adaptability,
						int understanding) {
		this.extraversion = extraversion;
		this.activism = activism;	
		this.emotivity = emotivity;
		this.adaptability = adaptability;
		this.understanding = understanding;
	}

	public int getExtraversion() {
		return extraversion;
	}

	public void setExtraversion(int extraversion) {
		this.extraversion = extraversion;
	}

	public int getActivism() {
		return activism;
	}

	public void setActivism(int activism) {
		this.activism = activism;
	}

	public int getEmotivity() {
		return emotivity;
	}

	public void setEmotivity(int emotivity) {
		this.emotivity = emotivity;
	}
	
	public int getAdaptability() {
		return adaptability;
	}

	public void setAdaptability(int adaptability) {
		this.adaptability = adaptability;
	}

	public int getUnderstanding() {
		return understanding;
	}

	public void setUnderstanding(int understanding) {
		this.understanding = understanding;
	}	
	
}

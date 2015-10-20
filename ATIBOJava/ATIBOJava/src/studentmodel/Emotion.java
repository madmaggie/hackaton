package studentmodel;

import java.io.EOFException;

import tutormodel.Grade;

public class Emotion {
	
	/*public final static String FRUSTRATION = "frustrare";
	public final static String DELIGHT = "incantare";
	public final static String BOREDOM = "plictiseala";
	public final static String ENGAGED = "captivare";
	public final static String SATISFACTION = "multumire";
	public final static String DISAPPOINTMENT = "dezamagire";*/
	
	public final static String POSITIVE = "positive";
	public final static String NEGATIVE = "negative";
	public final static String NEUTRAL = "neutral";
	
	private String name;
	//private double intensity;
	
	public Emotion(String name) {
		this.name = name;
	}
	
	public String toClipsEmotion() {
		String result = "";
		switch (name) {
			case Emotion.NEGATIVE: result = "NEG ";
									 break;
			case Emotion.POSITIVE: result = "POS ";
									   break;
			case Emotion.NEUTRAL: result = "NEU ";
			 								 break;
		}
		return result;
	}
}

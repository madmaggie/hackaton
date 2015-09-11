package emotionrecognition;

import studentmodel.Emotion;
import studentmodel.Student;

public class DumbEmotionGenerator {
	Student student;
	
	public DumbEmotionGenerator(Student student) {
		this.student = student;
	}
	
	public void setStudentEmotion(Emotion emotion) {
		student.setAffectivestate(emotion);
	}
}

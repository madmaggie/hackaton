package hackaton;

public class Friend {
	private String name;
	private int age;
	
	public Friend(String name, int age) {
		this.name = name;
		this.age = age;
	}
	
	public void speak(String msg) {
		System.out.println("My name is " + name + " and I want to say that " + msg);
	}

}

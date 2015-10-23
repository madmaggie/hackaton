package hackaton;

import hackaton.Friend;

public class TestClass {

	private static String roxSays() {
		return "\r\n At last! Imi merge si mie!";
	}

	public static void main(String[] args) {

		System.out.println("Bla bla bla" + roxSays());
		
		Friend f1 = new Friend("micky", 30);
		Friend f2 = new Friend("rox", 30);
		
		f1.speak(" love is in the air:D");
	}

}

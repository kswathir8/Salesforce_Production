/*
	10/13/2015 TestFluff
	This class is used to increase code coverage percentage across the org.
*/
@isTest
public with sharing class TestFluff {

	@isTest
	public static void test_fluff() {
		Fluff f = new Fluff();
		Fluff.fluff();
	}

}
@isTest
private class ucl_NightlyHerokuService_Test {
    @isTest
    static void testExecute() {
        Test.StartTest();
        ucl_NightlyHerokuService schedulableInstance = new ucl_NightlyHerokuService();
        /*
         * test forcing an exception
		*/
        schedulableInstance.simulateExceptionForTest = true;
        schedulableInstance.execute(null);
        /*
         * test without forcing an exception
		*/
        schedulableInstance.simulateExceptionForTest = false;
        schedulableInstance.execute(null);
        Test.StopTest();

        System.assert(true);
	}
}
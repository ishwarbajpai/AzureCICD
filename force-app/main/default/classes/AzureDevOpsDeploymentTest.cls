@IsTest
private class AzureDevOpsDeploymentTest {

    @IsTest
    static void testDeploymentMessage() {
        String result =
            AzureDevOpsDeployment.getDeploymentMessage();

        System.assertEquals(
            'Azure DevOps deployment to QA successful!',
            result
        );
    }

    @IsTest
    static void testAddNumbers() {
        Integer result =
            AzureDevOpsDeployment.addNumbers(10, 20);

        System.assertEquals(30, result);
    }
}
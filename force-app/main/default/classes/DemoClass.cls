public class DemoClass {

    /* Demo class */
    /* Here adding test comment */
    /* Add Test comment 1*/
    /* Add Test comment 2*/
    /* Add Test Comment 3*/
    public void getContact() {
        List<contact> contactList = [select id,Name from contact where Name like '%sanket%'];
        System.debug(contactList.size());

    /* Push to new branch */
    /* Push to new branch 2*/

    public DemoClass() {
        Decimal a = 4+6;
        System.debug('Test class: ' + a);
    }
}

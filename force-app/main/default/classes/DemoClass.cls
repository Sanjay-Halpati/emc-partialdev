public with sharing class DemoClass {
    /* Push to new branch */
    /* Push to new branch if: ${{ github.ref == 'refs/heads/staging' }}*/

    public DemoClass() {
        Decimal a = 7 + 7;
        System.debug('Test class: ' + a);
    }
}

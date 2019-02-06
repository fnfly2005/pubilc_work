/**
* Description: 包技术
* 不同包间的访问,非继承的类需要加public权限才能访问
* @author fnfly2005
*/
package mypack;
public class PackageDemoA
{
    public void show()
    {
        System.out.println("Hello PackageDemoA!!");
    }

    protected void run()
    {
        System.out.println("PackageDemoA run!!");
    }
}


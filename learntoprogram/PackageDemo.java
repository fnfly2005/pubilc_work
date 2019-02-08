/**
* Description: 包技术
* 包、多级包
* @author fnfly2005
*/
package mypack.subpack;
import mypack.PackageDemoA;
class PackageDemo
{
    public static void main(String[] args)
    {
        mypack.subpack.PackageDemoB b = new mypack.subpack.PackageDemoB();
        b.show();
        b.run();//该run方法为PackageDemoB覆盖的run
        PackageDemoA a = new PackageDemoA();
        a.show();
    }
}


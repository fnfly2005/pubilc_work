/**
* Description: 包技术
* 不同包间的访问,继承的子类可访问protected的权限
* @author fnfly2005
*/
package mypack.subpack;
public class PackageDemoB extends mypack.PackageDemoA
{
    protected void run() //父类protected只对子类可见，而对子类的实例不可见,需要覆盖后使用
    {
        super.run();
    }
}

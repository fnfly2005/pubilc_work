/**
* Description:
* 单例模式-保证一个类在内存中的对象唯一性,必须对于多个程序使用同一个配置信息对象时，就需要保证该对象的唯一性
* @version 1.0
* @author fnfly2005
*/
class Single
{
    //饿汉式
    private static Single s = new Single();//创建本类私有静态对象

    private Single()
    {
    //私有化构造函数
    }

    public static Single getInstance()
    {
    //开放一个对外方法把返回对象
       return s; 
    }

    public static void main(String[] args)
    {
        Single s1 = Single.getInstance();
        Single s2 = Single.getInstance();
        
        System.out.println(s1 == s2);
    }
}

/**
* Description:
* 单例模式-保证一个类在内存中的对象唯一性,必须对于多个程序使用同一个配置信息对象时，就需要保证该对象的唯一性
* @version 1.0
* @author fnfly2005
*/
//饿汉式
class SingleEager
{
    private static SingleEager s = new SingleEager();//创建本类私有静态对象

    private SingleEager()
    {
    //私有化构造函数
    }

    public static SingleEager getInstance()
    {
    //开放一个对外方法把返回对象
       return s; 
    }
}

//懒汉式
class SingleLazy
{
    private static SingleLazy s = null;//创建本类私有静态对象

    private SingleLazy()
    {
    //私有化构造函数
    }

    public static SingleLazy getInstance()
    {
    //开放一个对外方法把返回对象
        if (s == null)
        {
        //当s为空时新建对象，延迟加载，线程不安全
            SingleLazy s = new SingleLazy();
        }
        return s; 
    }

}

class Single
{
    public static void main(String[] args)
    {
        //SingleEager s1 = SingleEager.getInstance();
        //SingleEager s2 = SingleEager.getInstance();
        SingleLazy s1 = SingleLazy.getInstance();
        SingleLazy s2 = SingleLazy.getInstance();
        
        System.out.println(s1 == s2);
    }
}

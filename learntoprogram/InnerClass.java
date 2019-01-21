/**
* Description: 内部类、静态内部类
*/

class Outer
{
    int x = 4;
    class Inner
    {
        int y = 5;
        void show()
        {
            int z = 6;
            System.out.println("show...innershowvalue" + z);//默认优先采用局部变量
            System.out.println("show...innervalue" + this.y);//其次向上搜索类成员变量
            System.out.println("show...outervalue" + Outer.this.x);//再向上搜索外部类的成员变量，内部类持有外部类的引用,Outer.this可省略
        }
    }

    static class InnerStatic //静态内部类
    {
        void show()
        {
            System.out.println("show...static");
        }
    }
}

class InnerClass
{
    public static void main(String [] args)
    {
        //普通内部类初始化需要两步
        Outer o = new Outer();
        Outer.Inner i = o.new Inner();
        i.show();    

        //静态内部类可以单独初始化,但不能访问非静态资源
        Outer.InnerStatic si = new Outer.InnerStatic();
        si.show();
    }
}

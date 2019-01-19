/**
* Description:
* 抽象类 对程序员、经理、雇员、公司进行数据建模，抽取同类事物间共性，抽象出一层对象
* 接口 多实现 区别于抽象类-抽取非同类事物间共性，抽象出一层功能
* 多态 上下转型和开闭原则
* @author fnfly2005
* @version 1.0
*/
/**
* 雇员抽象对象,抽象出共性内容,子类则无需再进些描述
*/
abstract class Employee
{
    private String name;
    private String id;
    private double pay;
    public int num = 10;

    Employee(String name,String id,double pay)
    {
        this.name = name;
        this.id = id;
        this.pay = pay;
    }

    public abstract void work();//抽象方法

    public void showInfo()//抽象类可以用非抽象方法
    {
        System.out.println("name is "+name);
        System.out.println("id is "+id);
        System.out.println("pay is "+pay);
    }
}

interface Learning
{
    public void read();
    public void test();
}

interface Entertainment
{
    public void watchMovie();
    public void playGame();
}

/*
* 继承雇员类并实现学习的接口,多实现娱乐接口
*/
class Programmer extends Employee implements Learning,Entertainment
{
    Programmer(String name,String id,double pay)
    {
        super(name,id,pay);//使用父类构造函数初始化实例
    }
    
    public void work()
    {
        System.out.println("..code..");
    }

    public void read()
    {
        System.out.println("read..somebook..");
    }

    public void test()
    {
        System.out.println("write..run..code..");
    }

    public void watchMovie()
    {
        System.out.println("go..to..cinema");
    }

    public void playGame()
    {
        System.out.println("lol..pk..");
    }
}

/*
* 实现学习的接口
*/
class Ai implements Learning
{
    public void read()
    {
        System.out.println("read..somedata..");
    }

    public void test()
    {
        System.out.println("training..");
    }
    
}

class Manager extends Employee
{
    private int bonus;
    public int num = 1;

    Manager(String name,String id,double pay,int bonus)
    {
        super(name,id,pay);//使用父类构造函数初始化实例
        this.bonus = bonus;
    }

    public void work()
    {
        System.out.println("..manager..");
    }

    public void showInfo()
    {
        super.showInfo();
        System.out.println("bonus is "+bonus);
    }
}

class AbstractDemo
{
    public static void main(String[] args)
    {
        Employee e1 = new Programmer("fnfly2005","001",10000);//类多态-自动类型提升
        Employee e2 = new Manager("fnfly2005","002",20000,5000);//类多态-自动类型提升

        e1.showInfo();
        e2.showInfo();//多态-父类成员函数被子类覆盖，调用看父类，执行看子类

        System.out.println(e2.num);//多态-同名成员变量，调用和执行都看父类

        //向下转型先判断类型
        if (e1 instanceof Programmer)
        {
            Programmer p = (Programmer)e1;//类型向下转型
            Learning p1 = p;//接口多态-自动类型提升
            Learning a = new Ai();//接口多态-自动类型提升
            p.work();
            p.playGame();
            learn(a);//多态的应用
            learn(p1);
        }

        if (e2 instanceof Manager)
        {
            Manager m = (Manager)e2;//类型向下转型
            m.work();
        }
    }

    /**开闭原则
       对扩展开放：允许新增实现learning接口类
       对修改封闭：不需要修改依赖learning接口类型的learn()等函数
    */
    public static void learn(Learning l) 
    {
        l.read();
        l.test();
    }
}

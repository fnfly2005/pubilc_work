/**
* Description:
* 抽象类 对程序员、经理、雇员、公司进行数据建模，抽取同类事物间共性，抽象出一层对象
* 接口 区别于抽象类-抽取非同类事物间共性，抽象出一层功能
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

    Employee(String name,String id,double pay)
    {
        this.name = name;
        this.id = id;
        this.pay = pay;
    }

    public abstract void work();//抽象方法

    public void showinfo()//抽象类可以用非抽象方法
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

/*
* 继承雇员类并实现学习的接口
*/
class Programmer extends Employee implements Learning
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

    Manager(String name,String id,double pay,int bonus)
    {
        super(name,id,pay);//使用父类构造函数初始化实例
        this.bonus = bonus;
    }

    public void work()
    {
        System.out.println("..manager..");
    }

    public void showinfo()
    {
        super.showinfo();
        System.out.println("bonus is "+bonus);
    }
}

class AbstractDemo
{
    public static void main(String[] args)
    {
        Programmer p = new Programmer("fnfly2005","001",10000);
        Manager m = new Manager("fnfly2005","002",20000,5000);

        Learning p1 = p;//多态-自动类型提升
        Learning a = new Ai();//多态-自动类型提升

        p.showinfo();
        p.work();
        m.showinfo();
        m.work();

        a.read();
        a.test();
        p1.read();
        p1.test();
    }
}

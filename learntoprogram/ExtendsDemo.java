/**
* Description:
* 继承
* @author fnfly2005
* @version 1.0
*/
class Persion
{
    int age = 0;
    final String COUNTRY = "CN";//final 关键词修饰的变量、方法、类具有只读属性，不可被修改、继承、覆盖

    String name = "fnfly2005";

    Persion()
    {
        System.out.println("哇哇");
    }

    void show()
    {
        System.out.println(this.age+"..fu.."+this.age);
    }

}

class Student extends Persion
{
    int age = 10;

    Student()
    {
        //省略父类的空参数构造函数super(),父类构造函数不可被覆盖
    }

    /**
        this代表一个本类对象的引用，super代表父类空间
        覆盖父类方法,子类权限大于等于父类,静态只能覆盖静态
    */
    void show()
    {
        super.show();//保留原有功能
        System.out.println(this.age+"..zi.."+super.age);//新增扩展功能
    }

    void study()
    {
        System.out.println(name+"....student study");
    }
}

class Worker extends Persion
{
    void work()
    {
        System.out.println(name+"....worker work");
    }
}

class ExtendsDemo
{
    public static void main(String[] args)
    {
        Student s = new Student();
        Worker w = new Worker();
        s.show();
        w.show();
        s.study();
    }
}

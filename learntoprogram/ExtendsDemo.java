/**
* Description:
* 继承
* @author fnfly2005
* @version 1.0
*/
class Persion
{
    int age = 0;
    String name = "fnfly2005";
}

class Student extends Persion
{
    int age = 10;
    void show()
    {
        //this代表一个本类对象的引用，super代表父类空间
        System.out.println(this.age+"...."+super.age);
    }
    void study()
    {
        System.out.println(name+"....student study");
    }
}

class Work extends Persion
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
        s.show();
        s.study();
    }
}

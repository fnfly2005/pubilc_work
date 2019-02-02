/**
* Description:  object类常用方法
* @author fnfly2005
* @version 1.0
*/
class PersonObject
{
    private int age;

    PersonObject(int age)
    {
        this.age = age;
    }

    //equals方法默认比较对象间内存地址，覆盖该方法，将其替换成比较内容
    public boolean equals(Object obj)
    {
        if (!(obj instanceof PersonObject))//!() 布尔取反语句,类型判断
        {
            throw new ClassCastException("类型错误");
        }
        PersonObject p = (PersonObject)obj;//向下转型
        return this.age == p.age;
    }

    //toString方法默认返回类名@16进制哈希值，覆盖该方法
    public String toString()
    {
        return "PersonObject:"+age;
    }
}

class ObjectDemo
{
    public static void main (String[] agrs)
    {
        PersonObject p1 = new PersonObject(20);
        PersonObject p2 = new PersonObject(20);

        //equals方法-比较对象
        Object o = new Object();
        System.out.println(p1.equals(p2));
        
        //hashCode方法-返回10进制哈希值-内存地址
        System.out.println(p1);
        System.out.println(Integer.toHexString(p1.hashCode()));//转16进制

        //getClass方法-获取类对象
        Class clazz1 = p1.getClass();
        Class clazz2 = p1.getClass();
        System.out.println(clazz1.getName());//获取类名
        System.out.println(clazz1.equals(clazz2));//不同对象拥有同一个类

        //toString方法-返回对象的字符串表示形式
        System.out.println(p1.toString());
    }
}

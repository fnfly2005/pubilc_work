/**
* Description:
* 异常处理技术,异常对象,自定义异常对象,自定义异常的声明,异常捕捉处理,try..finally
* 异常与错误的区别：错误error由JVM抛出,一般是严重性错误,无法进行处理,不应该捕获
* 异常处理的原则，发现异常才进行处理，未发现不处理
* 异常分两种：编译时异常、运行时异常
* 编译时异常，希望在编译时进行检测
* 运行时异常，一般不可处理，无需声明，直接抛出，与错误的区别:运行时异常是JVM正常时抛出的、错误是JVM不正常时抛出的
* @author fnfly2005
* @version 1.0
*/
class ExceptionDemo
{
    public static void main(String[] args)// throws FuIndexException 继承Exception需要声明
    {
        int[] arr = new int[2];
        int[] load = {1,2};
        try
        {//一般用于主流程
            int a = 0;
            int i = arrv(load,a+1);//使用者输入引起异常,应该抛出而不是捕捉
            arr[a] = i;
            a++;
            i = arrv(load,a+1);
            arr[a] = i;
        }
        catch (ArrayIndexOutOfBoundsException e)
        {//一般用于回滚操作
            arr[0] = 1;
            arr[1] = 1;
            throw e;
        }
        finally//一般用于数据库关于连接池
        {
            System.out.println(arr[0] +".."+ arr[1]);
        }
    }

    public static int arrv(int[] load,int index)// throws FuIndexException,NullPointerException 继承Exception需要声明,可以抛出或捕捉多个异常
    {
        if (load == null)
        {//一般用于类或方法
            throw new NullPointerException("没有任何数组实体");
        }
        
        if (index>=load.length)
        {
            throw new ArrayIndexOutOfBoundsException("数组角标越界,数组最大值为"+(load.length-1)+",给定值为"+index);
        }
        else if (index<0)
        {
            throw new FuIndexException("数组角标不能为负数,给定值为"+index);
        }
        
        return load[index];
    }   
}

/*
* 自定义异常类必须继承异常体系类,才能被关键词throw,throws所抛出
* RuntimeException、Exception两种继承方式
*/
class FuIndexException extends RuntimeException
{
    FuIndexException()
    {
    }
    FuIndexException(String s)
    {
    }
    FuIndexException(int index)
    {
    }
}

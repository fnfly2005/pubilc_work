/**
* Description: 多线程之join线程序列、setPriority线程优先级
* @author fnfly2005
*/
class JoinRunDemo implements Runnable
{
    public void run()
    {
        for(int x=0; x<50; x++)
        {
            System.out.println(Thread.currentThread().toString()+"....."+x);
            Thread.yield();
        }
    }
}

class  JoinDemo
{
    public static void main(String[] args) throws Exception
    {
        JoinRunDemo d = new JoinRunDemo();

        Thread t1 = new Thread(d);
        Thread t2 = new Thread(d);

        t1.start();


        t2.start();
        t2.setPriority(Thread.MAX_PRIORITY);//提高t2线程的优先级

        t1.join();//调用线程(main)需等待该线程(t1)完成才能继续运行

        for(int x=0; x<50; x++)
        {
            System.out.println(Thread.currentThread()+"....."+x);
        }
    }
}

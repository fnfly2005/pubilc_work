/**
* Description: 多线程之死锁,表现为不同锁的嵌套，两个线程分别执行时遭遇不同的嵌套顺序
* @author fnfly2005
*/
class DeadLockDemo implements Runnable
{
    private int num = 0; 
    Object obj = new Object();
    
    public void run()
    {
        while(true)
        {
            if (num++ % 2 == 1) //实现线程执行路径的切换
            {
                synchronized(DeadLockDemo.class)
                {
                    synchronized(obj)
                    {
                        System.out.println(num);
                    }
                }
            }
            else
            {
                synchronized(obj)
                {
                    synchronized(DeadLockDemo.class)
                    {
                        System.out.println(num);
                    }
                }
            }
        }
    }
}

class DeadLock
{
    public static void main(String[] args)
    {
        DeadLockDemo d = new DeadLockDemo();
        Thread t1 = new Thread(d);
        Thread t2 = new Thread(d);
        t1.start();
        t2.start();
    }
}

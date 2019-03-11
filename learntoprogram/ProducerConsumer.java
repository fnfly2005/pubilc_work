/**
* Description: 多线程技术之经典生产者消费者问题
* jdk1.5之后新增同步对象、监视器对象,支持同一个锁对象拥有多个监视器对象
* 线程停止方式一:run方法停止
* @author fnfly2005
* 构建一个存放烤鸭的餐厅，用多线程技术实现厨师往餐厅里放烤鸭，客人从餐厅里取烤鸭
*/
import java.util.concurrent.locks.*;
class Restaurant
{
    private String name;
    private int count = 1;
    private boolean flag = false;

    Lock lock = new ReentrantLock(); //创建同步锁
    Condition conPut = lock.newCondition();//创建锁所属监视器对象put
    Condition conTake = lock.newCondition();//创建锁所属监视器对象put

    public void putDuck(String name)
    {
        lock.lock(); //加锁
        try
        {
            while(this.flag)
            {
                try
                {
                    conPut.await();//生产者等待
                }
                catch(InterruptedException e)
                {
                }
            }
            this.name = name + this.count;
            System.out.println(Thread.currentThread().getName() + "生产" + this.name);
            count++;
            this.flag = true;
            conTake.signal();//唤醒消费者
        }
        finally
        {
            lock.unlock();//释放锁
        }
    }

    public void takeDuck()
    {
        lock.lock();
        try
        {
            while(! this.flag)
            {
                try
                {
                    conTake.await();
                }
                catch(InterruptedException e)
                {
                }
            }
            System.out.println(Thread.currentThread().getName() + "消费" + this.name);
            this.flag = false;
            conPut.signal();
        }
        finally
        {
            lock.unlock();
        }
    }
}

class Cooker implements Runnable
{
    Restaurant r;
    private boolean flag = true;
    Cooker(Restaurant r)
    {
        this.r = r;
    }

    public void run()
    {
        while(flag)
        {
            this.r.putDuck("烤鸭");
        }
    }

    public void setFlag()
    {
        this.flag = false;
    }
}

class Epicure implements Runnable
{
    Restaurant r;
    private boolean flag = true;
    Epicure(Restaurant r)
    {
        this.r = r;
    }

    public void run()
    {
        while(flag)
        {
            this.r.takeDuck();
        }
    }

}

class ProducerConsumer
{
    public static void main(String[] args)
    {
        Restaurant r = new Restaurant();
        Cooker c = new Cooker(r);
        Epicure e = new Epicure(r);

        Thread t1 = new Thread(c);
        Thread t2 = new Thread(c);
        Thread t3 = new Thread(e);
        Thread t4 = new Thread(e);

        t1.start();
        t2.start();
        t3.start();
        t4.start();

        int num = 1;
        for(;;)
        {
            if(++num==50)
            {
                c.setFlag();
                e.setFlag();
                break;
            }
            System.out.println("main.."+num);
        }
        System.out.println("over");
    }
}

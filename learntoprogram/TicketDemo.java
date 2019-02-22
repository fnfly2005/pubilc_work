/**
* Description: 线程共享数据、线程安全问题、同步锁、同步函数、静态同步函数
* 卖票示例
* @author fnfly2005
*/

class Ticket implements Runnable
{
    private int num;
    boolean flag = true;

    Ticket(int num)
    {
        this.num = num;
    }

    public void run()
    {
        if(flag)
        {
            while(true)
            {
                synchronized(this) //同步锁
                {
                    if(num>0)
                    {
                        try
                        {
                            Thread.sleep(2); //冻结进程
                        }
                        catch (InterruptedException e) //必须捕捉异常
                        {
                        }
                        System.out.println(Thread.currentThread().getName() + "..ticket.." + num);
                        num--;
                    }
                }
            }
        }
        else
        {
            while(true)
            {
                this.show();
            }
        }
    }

    public synchronized void show()  //同步函数用的锁是this,静态同步函数用的锁是this.getClass()或ticket.class
    {
        if(num>0)
        {
            try
            {
                Thread.sleep(2); //冻结进程
            }
            catch (InterruptedException e) //必须捕捉异常
            {
            }
            System.out.println(Thread.currentThread().getName() + "..sale.." + num);
            num--;
        }
    }

}

class TicketDemo
{
    public static void main(String[] args)
    {
        Ticket t = new Ticket(100);

        Thread t1 = new Thread(t);
        Thread t2 = new Thread(t);
        Thread t3 = new Thread(t);
        Thread t4 = new Thread(t);

        t1.start();
        t2.start();
        t.flag = false;
        try
        {
            Thread.sleep(10); //冻结进程
        }
        catch (InterruptedException e) //必须捕捉异常
        {
        }
        t3.start();
        t4.start();
    }
}

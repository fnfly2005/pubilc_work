/**
* Description: 线程共享数据及线程不安全
* 卖票示例
* @author fnfly2005
*/

class Ticket implements Runnable
{
    private int num;

    Ticket(int num)
    {
        this.num = num;
    }

    public void run()
    {
        while(true)
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
        t3.start();
        t4.start();
    }
}

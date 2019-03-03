/**
* Description:线程间通信技术 
* 对具有共享数据的资源，建立多线程任务，对资源交替执行任务
* @author fnfly2005
*/
//操作资源的方法应封装在资源类上
class Resource
{
    private String name;
    private String sex;
    private boolean flag = false;

    //线程完成任务后改变资源状态，冻结线程至同步锁的线程池,并唤醒交接的任务线程
    public synchronized void setArt(String name,String sex)
    {
        if(flag)
        {
            try
            {
                this.wait();
            }
            catch(InterruptedException e)
            {
            }
        }
        this.name = name;
        this.sex = sex;
        flag = true;
        this.notify();
    }

    //等待和唤醒必须基于同步锁的监视器才能操作
    public synchronized void showArt()
    {
        if(!flag)
        {
            try
            {
                this.wait();
            }
            catch(InterruptedException e)
            {
            }
        }
        System.out.println(this.name + " is " + this.sex);
        flag = false;
        this.notify();
    }
}

//建立赋值任务
class SetResource implements Runnable
{
    Resource r;
    SetResource(Resource r)
    {
        this.r = r;
    }

    public void run()
    {
        int x = 0;
        while(true)
        {
            if(x == 0)
            {
                r.setArt("Mike","male");
            }
            else
            {
                r.setArt("莉莉","女");
            }
            x = (x+1)%2;
        }
    }
}

//建立取值任务
class ShowResource implements Runnable
{
    Resource r;
    ShowResource(Resource r)
    {
        this.r = r;
    }

    public void run()
    {
        while(true)
        {
            r.showArt();
        }
    }
}

class ThreadCommunication
{
    public static void main(String[] args)
    {
        Resource r = new Resource();
        SetResource st = new SetResource(r);
        ShowResource sw = new ShowResource(r);

        Thread t1 = new Thread(st);
        Thread t2 = new Thread(sw);
        Thread t3 = new Thread(sw);

        t1.start();
        t2.start();
        t3.start();
    }
}

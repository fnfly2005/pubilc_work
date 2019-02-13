/**
* Description: 多线程技术
* 多线程应用一：继承Thread并覆盖run方法
* @author fnfly2005
*/
class ThreadDemo extends Thread
{
    private String name;
    ThreadDemo(String name)
    {
        super(name); //更改默认线程名称
    }

    //覆盖父类的run方法，多线程start直接调用run方法
    public void run()
    {
        show();
    }

    public void show()
    {
        for(int x=0;x<10;x++)
        {
            System.out.println(x + " on " + Thread.currentThread().getName());//获取当前线程名称getName
        }
    }

}

class ThreadMain
{
    public static void main(String[] args)
    {
        ThreadDemo d1 = new ThreadDemo("旺财");
        ThreadDemo d2 = new ThreadDemo("xiaoqiang");
        d1.start();//启动线程
        d2.start();
        System.out.println("over..." + Thread.currentThread().getName());
    }
}

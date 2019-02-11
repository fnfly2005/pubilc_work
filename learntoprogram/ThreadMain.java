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
        this.name = name;
    }

    public void run()
    {
        for(int x=0;x<10;x++)
        {
            System.out.println(this.name + "....x=" +x);
        }
    }

}

class ThreadMain
{
    public static void main(String[] args)
    {
        ThreadDemo d1 = new ThreadDemo("旺财");
        ThreadDemo d2 = new ThreadDemo("xiaoqiang");
        d1.start();
        d2.start();
    }
}

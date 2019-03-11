/*
* Description: 多线程之线程停止、线程守护
* @author fnfly2005
*/
class StopThread implements Runnable
{
	private boolean flag = true;
	public synchronized void run()
	{
		while(flag)
		{
			try
			{
				wait();//t0 t1
			}
			catch (InterruptedException e)
			{
				System.out.println(Thread.currentThread().getName()+"....."+e);
				flag = false;
			}
			
			System.out.println(Thread.currentThread().getName()+"......++++");
		}
	}
}



class StopThreadDemo 
{
	public static void main(String[] args) 
	{
		StopThread st = new StopThread();

		Thread t1 = new Thread(st);
		Thread t2 = new Thread(st);

		t1.start();
		t2.setDaemon(true);//守护线程，当前台线程退出，同时退出
		t2.start();


		int num = 1;
		for(;;)
		{
			if(++num==50)
			{
				t1.interrupt();//适用于线程冻结，自己无法结束run方法的场景
				break;
			}
			System.out.println("main...."+num);
		}

		System.out.println("over");
	}
}

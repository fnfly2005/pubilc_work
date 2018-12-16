/*函数*/
class function
{
    public static void main(String[] args)
    {
        draw(3,2);
        System.out.println(equals(76));
    }

    static void draw(int row,int col)
    /*根据输入的行列数，在屏幕上输出一个矩形*/
    {
        for(int x=1;x<=row;x++)
        {
            for(int y=1;y<=col;y++)
            {
                System.out.print("*");
            }
            System.out.print("\n");
        }
    }

    static String equals(int number)
    /*根据考试成绩返回学生分数对应的等级*/
    {
        String level;
        if (number >= 90 && number <= 100)
            level = "A";
        else if (number >= 80 && number < 90)
            level = "B";
        else if (number >= 70 && number < 80)
            level = "C";
        else if (number >= 60 && number < 70)
            level = "D";
        else
            level = "E";
        return level;
    }

}

$Source = @"
public class Calculator
{
  public int a {get; set;}
  public int b {get; set;} 

  public Calculator (int x, int y)
    { 
	this.a = x; this.b = y; 
    }
   
  public int Add()
    {
        return (this.a + this.b);
    }

  public int Subtract()
    {
        return (this.a - this.b);
    }

  public static int Multiply(int x, int y)
    {
    return (x * y);
    }

  public static int Divide(int n, int m)
    {
    return (n / m);
    }

}
"@
using NUnit.Framework;

public class Calculator
{
    public int add(int a, int b)
    {
        return a + b;
    }
}

[TestFixture]
public class Tests
{
    private Calculator calculator;

    [SetUp]
    protected void SetUp()
    {
        calculator = new Calculator();
    }

    [Test]
    public void NeutralElement()
    {
        Assert.AreEqual(1, calculator.add(1, 0));
        Assert.AreEqual(1, calculator.add(0, 1));
        Assert.AreEqual(0, calculator.add(0, 0));
    }

    [Test]
    public void CommutativeProperty()
    {
        Assert.AreEqual(calculator.add(2, 3), calculator.add(3, 2));
    }
}
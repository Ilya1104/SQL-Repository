use OMA01
go
create function f_calc (@string nvarchar(10))
returns decimal(18,2)
as
begin
declare @number1 decimal(18,2), 
        @number2 decimal(18,2), 
        @arithmeticChar nvarchar(1), 
        @charIndex int = 1, 
        @stopTrigger int = 0,
        @result decimal(18,2);



while @stopTrigger = 0
    begin
        set @arithmeticChar = SUBSTRING(@string, @charIndex, 1);
        if @arithmeticChar like '%[-+*/]%'
            set @stopTrigger +=1;
        else
            set @charIndex +=1
    end;

 set @number1 = LEFT(@String, CHARINDEX(@arithmeticChar, @String) - 1);
 set @number2 = SUBSTRING(@String, CHARINDEX(@arithmeticChar, @String) + 1, LEN(@String));
 set @result = case @arithmeticChar
                    when '+' then @number1+@number2
                    when '-' then @number1 - @number2
                    when '*' then @number1 * @number2
                    when '/' then case when @number2 <> 0 
                                       then @number1 / @number2 
                                       else null end
end;
return @result;
end;


/*
use OMA01
go
SELECT dbo.f_calc('44/22') AS Result;*/
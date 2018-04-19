Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;





Entity ALU is
Port(

ALUSrc1: in std_logic_vector(15 downto 0); --That is the left one in design --src

ALUSrc2: in std_logic_vector(15 downto 0); --The right one in design and on which one operand instructions are performed  --dst

opcode: in std_logic_vector(4 downto 0); --Decode it to know ALU operation

ALUEn: in std_logic; --one of Ctrl Signals in decode execute buffers to indicate that the instruction is using the ALU


ALURes1: out std_logic_vector(15 downto 0);   -----output
ALURes2: out std_logic_vector(15 downto 0);
Flags  : inout std_logic_vector(3 downto 0) --Input to flag register   -z c n o

 );
end entity;


Architecture ALUArch of ALU is
signal input1,input2,output,z1:signed(16 downto 0);
SIGNAL output1,output2:STD_LOGIC_VECTOR(16 downto 0);
SIGNAL multiply,z2:signed(33 downto 0);
SIGNAL MULOUT:STD_LOGIC_VECTOR(33 downto 0);
SIGNAL TempCarry:STD_LOGIC;
signal localflow:std_logic;
signal d,q: unsigned(16 downto 0);
constant zeros : std_logic_vector(16 downto 0) := (others => '0');
constant zeross : std_logic_vector(33 downto 0) := (others => '0');
SIGNAL BRANCHZERO,BRANCHN,BRACHC :std_logic;
constant ANDOP: std_logic_vector(4 downto 0) := "00101";
constant SHLCOP: std_logic_vector(4 downto 0) := "00111";
constant SHRCOP: std_logic_vector(4 downto 0) := "01000";
constant OROP: std_logic_vector(4 downto 0) := "00110";
constant CALLOP: std_logic_vector(4 downto 0) := "11001";
constant MOVOP: std_logic_vector(4 downto 0) := "00001";
constant NOTOP: std_logic_vector(4 downto 0) := "10001";
constant DECOP: std_logic_vector(4 downto 0) := "10100";
constant INCOP: std_logic_vector(4 downto 0) := "10011";
constant ADDOP: std_logic_vector(4 downto 0) := "00010";
constant SUBOP: std_logic_vector(4 downto 0) := "00100";
constant MULOP: std_logic_vector(4 downto 0) := "00011";
constant JMPOP: std_logic_vector(4 downto 0) := "11000";
constant JMPCOP: std_logic_vector(4 downto 0) := "10111";
constant JMPNOP: std_logic_vector(4 downto 0) := "10110";
constant JMPZOP: std_logic_vector(4 downto 0) := "10101";
CONSTANT POPOP:std_logic_vector(4 downto 0) := "01110";
CONSTANT RETOP:std_logic_vector(4 downto 0) := "11010";
CONSTANT SHLOP:std_logic_vector(4 downto 0) := "01001";
CONSTANT SHROP:std_logic_vector(4 downto 0) := "01010";
CONSTANT RETIOP:std_logic_vector(4 downto 0) :="11011";
CONSTANT PUSHOP:std_logic_vector(4 downto 0) :="01101";
begin

--TODO: akeed m3roofa bs matenseesh elsigned operations

input1<= resize(signed(ALUSrc1),17);  --src 
q<=unsigned('0'&ALUSrc1);
d<=unsigned('0'&ALUSrc2);
z1<=resize(signed(zeros),17);
z2<=resize(signed(zeross),34);
input2<= resize(signed(ALUSrc2),17); --dst



BRANCHZERO <= '1' when (opcode=JMPZOP) and (Flags(3)='1')
else '0';

BRANCHN<= '1' when opcode=JMPNOP and Flags(1)='1'
else '0';

BRACHC<= '1' when opcode=JMPCOP and Flags(2)='1'
else '0';



output<=input1+input2 when opcode=ADDOP  -----ADD
else -input1+input2 when(opcode=SUBOP)--SUB
else  input1 AND input2 when (opcode=ANDOP)--AND
else input1 OR input2 when(opcode=OROP)---OR
else input1+1 when opcode=INCOP or opcode=POPOP or opcode=RETOP or opcode=RETIOP--INC --pop -- return --return 1
else input1-1 when (opcode=DECOP or opcode=PUSHOP or opcode =CALLOP);--DEC --push -- call




--output1<=std_logic_vector(input1) when (opcode/=MULOP AND opcode=INCOP AND  opcode=DECOP AND (opcode=SHLOP) AND( opcode=SHROP) );
     
--output2 always equal to output except in cases of shift left ,shift right
output2<=std_logic_vector(output) when (opcode/=MULOP AND opcode/=SHLOP  AND opcode/=SHROP AND opcode/=SHRCOP AND opcode/=SHLCOP)
     else std_logic_vector(q sll to_integer(d))when(opcode=SHLOP) ----SHIFT LEFT
     else std_logic_vector(q srl to_integer(d))when( opcode=SHROP); -----SHIFT RIGHT


multiply<= input1*input2 when(opcode=MULOP);

MULOUT<=std_logic_vector(multiply) when (opcode=MULOP) ;

TempCarry<= Flags(2) when opcode=SHRCOP or opcode="00111";


--------------------over flow flag----------------------------------------------------
 Flags(0)<= '1' when ((output(15) /= output(16) or multiply(33) /= multiply(32)) AND opcode/=SHLOP  AND opcode/=SHROP)
                else '1' when (opcode=SHLOP  or opcode=SHROP ) AND (output2(15) /= output2(16))
                else Flags(0) when  opcode=PUSHOP or opcode =CALLOP or opcode=POPOP or opcode=RETOP or opcode=RETIOP or  opcode =MOVOP or opcode=SHLOP or opcode=SHROP or opcode=JMPOP    or opcode=RETOP or opcode=RETIOP or opcode=JMPZOP or opcode=JMPNOP or opcode=JMPCOP
                else '0';  
---------------------Zero flag------------------------------------------------------
 Flags(3)<='1' when (output = "0000000000000000") or (multiply= (multiply'range => '0'))
   else Flags(3) when  opcode=PUSHOP or opcode =CALLOP or opcode=POPOP or opcode=RETOP or opcode=RETIOP or  opcode =MOVOP or opcode=SHLOP or opcode=SHROP or opcode=JMPOP or BRANCHZERO/='1'    or opcode=JMPNOP or opcode=JMPCOP
    ELSE '0';
--------------------Neg flag---------------------------------------------------------
 Flags(1)<='1' when (output< (output'range => '0')) or (multiply < (multiply'range => '0'))
    else Flags(1) when  opcode=PUSHOP or opcode =CALLOP or opcode=POPOP or opcode=RETOP or opcode=RETIOP or  opcode =MOVOP or opcode=SHLOP or opcode=SHROP or opcode=JMPOP or BRANCHN/='1'  or opcode= JMPCOP or opcode=JMPZOP

     ELSE  '0';
-------------------carry flag--------------------------------------------------------------
Flags(2)<= ALUSrc2(0) when opcode=SHRCOP
else    ALUSrc2(15) when opcode="00111"
else  '1'when  opcode="01011"
else  output(16) when opcode=ADDOP or  (opcode=SUBOP)  or opcode=INCOP or opcode=DECOP
else Flags(2) when  opcode=PUSHOP or opcode =CALLOP or opcode=POPOP or opcode=RETOP or opcode=RETIOP or  opcode =MOVOP or opcode=SHLOP or opcode=SHROP or opcode=JMPOP or BRACHC/='1' or opcode=JMPZOP or opcode=JMPNOP 
else '0';
---------------------------------------------------------------------------------------------

 ALURes1<= ALUSrc1 when opcode =MOVOP -----MOv
  else not ALUSrc2 when (opcode=NOTOP) -----NOT
  else output2(15 downto 0) when opcode=SHLOP  or opcode=SHROP --sll -srl
  else output2(16)&output2(14 downto 0)    when opcode=ADDOP or (opcode=SUBOP) or opcode=INCOP or opcode=DECOP   --ADD -SUB --INC --DEC
  else MULOUT(15 downto 0) when (opcode=MULOP)--Mul
  else output2(15 downto 0) when (opcode=ANDOP) or (opcode=OROP) --AND  --OR 
  else TempCarry & ALUSrc2(14 downto 0) when opcode=SHRCOP--shift with carry
  else ALUSrc2(15 downto 1)& TempCarry when opcode="00111"; --shift with carry
 -- else  output2(16)&output2(14 downto 0) when    --INC DEC 
 -- else output2(16)&output2(14 downto 0);




ALURes2<= 
--output1(15 downto 0) when opcode/="00011"  
  MULOUT(31 downto 16) when(opcode=MULOP)
  else  output2(16)&output2(14 downto 0) when opcode=POPOP or opcode=PUSHOP  or opcode=RETOP or opcode=RETIOP or opcode =CALLOP--PUSH POP call return return1;
  else (others => '0');
 --else ALUSrc1 when opcode=MOVOP;











end ALUArch;

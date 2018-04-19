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
begin

--TODO: akeed m3roofa bs matenseesh elsigned operations

input1<= resize(signed(ALUSrc1),17);  --src 
q<=unsigned('0'&ALUSrc1);
d<=unsigned('0'&ALUSrc2);
z1<=resize(signed(zeros),17);
z2<=resize(signed(zeross),34);
input2<= resize(signed(ALUSrc2),17); --dst



BRANCHZERO <= '1' when (opcode="10101") and (Flags(3)='1')
else '0';

BRANCHN<= '1' when opcode="10110" and Flags(1)='1'
else '0';

BRACHC<= '1' when opcode="10111"and Flags(2)='1'
else '0';



output<=input1+input2 when opcode="00010"  -----ADD
else -input1+input2 when(opcode="00100")--SUB
else  input1 AND input2 when (opcode="00101")--AND
else input1 OR input2 when(opcode="00110")---OR
else input1+1 when opcode="10011" or opcode="01110" or opcode="11010"or opcode="11011"--INC --pop -- return --return 1
else input1-1 when (opcode="10100" or opcode="01101" or opcode ="11001");--DEC --push -- call




output1<=std_logic_vector(input1) when (opcode/="01000" AND opcode="10011" AND  opcode="10100" AND (opcode="01001") AND( opcode="01010"));
     
--output2 always equal to output except in cases of shift left ,shift right
output2<=std_logic_vector(output) when (opcode/="01000" AND opcode/="01001"  AND opcode/="01010")
     else std_logic_vector(q sll to_integer(d))when(opcode="01001") ----SHIFT LEFT
     else std_logic_vector(q srl to_integer(d))when( opcode="01010"); -----SHIFT RIGHT


multiply<= input1*input2 when(opcode="00011");

MULOUT<=std_logic_vector(multiply) when (opcode="00011") ;

TempCarry<= Flags(2) when opcode="01000" or opcode="00111";


--------------------over flow flag----------------------------------------------------
 Flags(0)<= '1' when ((output(15) /= output(16) or multiply(33) /= multiply(32)) AND opcode/="01001"  AND opcode/="01010")
                else '1' when (opcode="01001"  or opcode="01010" ) AND (output2(15) /= output2(16))
                else Flags(0) when  opcode="01101" or opcode ="11001" or opcode="01110" or opcode="11010"or opcode="11011" or  opcode ="00001" or opcode="01001" or opcode="01010" or opcode="11000" or opcode="11000" or opcode="11001" or opcode="11001" or opcode="11010" or opcode="11011" or opcode="10101" or opcode="10110" or opcode="10111"
                else '0';  
---------------------Zero flag------------------------------------------------------
 Flags(3)<='1' when (output = "0000000000000000") or (multiply= (multiply'range => '0'))
   else Flags(3) when  opcode="01101" or opcode ="11001" or opcode="01110" or opcode="11010"or opcode="11011" or  opcode ="00001"or opcode="01001" or opcode="01010" or opcode="11000" or BRANCHZERO/='1' or opcode="11000" or opcode="11001" or opcode="11010" or opcode="11011" or opcode="10110" or opcode="10111"
    ELSE '0';
--------------------Neg flag---------------------------------------------------------
 Flags(1)<='1' when (output< (output'range => '0')) or (multiply < (multiply'range => '0'))
    else Flags(1) when  opcode="01101" or opcode ="11001" or opcode="01110" or opcode="11010"or opcode="11011" or  opcode ="00001" or opcode="01001" or opcode="01010" or opcode="11000" or BRANCHN/='1' or opcode="11000" or opcode="11001" or opcode="11010" or opcode="11011" or opcode="10111" or opcode="10101"

     ELSE  '0';
-------------------carry flag--------------------------------------------------------------
Flags(2)<= ALUSrc2(0) when opcode="01000"
else    ALUSrc2(15) when opcode="00111"
else  '1'when  opcode="01011"
else  output(16) when opcode="00010" or  (opcode="00100")  or opcode="10011" or opcode="10100"
else Flags(2) when  opcode="01101" or opcode ="11001" or opcode="01110" or opcode="11010"or opcode="11011" or  opcode ="00001" or opcode="01001" or opcode="01010" or opcode="11000" or BRACHC/='1' or opcode="11000" or opcode="10101" or opcode="10110" or opcode="11001" or opcode="11010" or opcode="11011"
else '0';
---------------------------------------------------------------------------------------------

 ALURes1<= ALUSrc1 when opcode ="00001" -----MOv
  else not ALUSrc2 when (opcode="10001") -----NOT
  else output2(15 downto 0) when opcode="01001"  or opcode="01010" --sll -srl
  else output2(16)&output2(14 downto 0)    when opcode="00010" or (opcode="00100") or opcode="10011" or opcode="10100"   --ADD -SUB --INC --DEC
  else MULOUT(15 downto 0) when (opcode="00011")--Mul
  else output2(15 downto 0) when (opcode="00101") or (opcode="00110") --AND  --OR 
  else TempCarry & ALUSrc2(14 downto 0) when opcode="01000"--shift with carry
  else ALUSrc2(15 downto 1)& TempCarry when opcode="00111"; --shift with carry
 -- else  output2(16)&output2(14 downto 0) when    --INC DEC 
 -- else output2(16)&output2(14 downto 0);




ALURes2<= 
--output1(15 downto 0) when opcode/="00011"  
  MULOUT(31 downto 16) when(opcode="00011")
  else  output2(16)&output2(14 downto 0) when opcode="01110" or opcode="01101"  or opcode="11010"or opcode="11011" or opcode ="11001"--PUSH POP call return return1;
  else (others => '0');
 --else ALUSrc1 when opcode="00001";











end ALUArch;

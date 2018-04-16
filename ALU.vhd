Library ieee;
use ieee.std_logic_1164.all;

Entity ALU is
Port(

ALUSrc1: in std_logic_vector(15 downto 0); --That is the left one in design 

ALUSrc2: in std_logic_vector(15 downto 0); --The right one in design and on which one operand instructions are performed

opcode: in std_logic_vector(15 downto 0); --Decode it to know ALU operation

ALUEn: in std_logic; --one of Ctrl Signals in decode execute buffers to indicate that the instruction is using the ALU


ALURes1: out std_logic_vector(15 downto 0);
ALURes2: out std_logic_vector(15 downto 0);
Flags  : out std_logic_vector(2 downto 0) --Input to flag register

);
end entity;


Architecture ALUArch of ALU is

begin

--TODO: akeed m3roofa bs matenseesh elsigned operations



end ALUArch;

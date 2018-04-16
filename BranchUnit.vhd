Library ieee;
use ieee.std_logic_1164.all;

Entity BranchUnit is
Port(

--you need that opcode to check on jump opcodes (These opcodes will be in fetch decode register)
opcode: in std_logic_vector(4 downto 0);

DecExAluEn: in std_logic; --This signal comes from control signals of Dec Ex buffer

ALUFlags  : in std_logic_vector(2 downto 0); --These are the AlUFlags that are on the wires and not saved yet in flag register
FlagReg   : in std_logic_vector(2 downto 0); --This are the values of the flags in the flag register

Branch : out std_logic;
flush: out std_logic

);

end entity;


Architecture BranchUnitArch of BranchUnit is


begin

--TODO: Unconditional jmps should generate signal branch in all cases as well as the call instruction

--TODO: As for conditional jmps if( aluen='1' then check on ALU flags else check on flag register)


-- PCen signal which is input to the fetch stage is used to contol whether pc will be enabled or not for purpose of flushing
--Generate that signal as output from branch unit and adjust the flushing in all stages files


end BranchUnitArch;


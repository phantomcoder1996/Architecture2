Library ieee;
use ieee.std_logic_1164.all;

entity processor is
Port(

reset: in std_logic; --external reset signal
clk:   in std_logic; 
int:   in std_logic; --external interrupt signal
rst:   in std_logic; --external signal for loading all registers with zeros

instructionMemIn: in std_logic_vector(15 downto 0);
DataMemoryIn:     in std_logic_vector(15 downto 0);

portInput:        in std_logic_vector(15 downto 0);


instructionMemoryAddress: out std_logic_vector(9 downto 0);
DataMemoryAddress	: out std_logic_vector(9 downto 0);
DataMemoryOut		: out std_logic_vector(15 downto 0)




);

end entity;


Architecture processorArch of processor is


begin

--TODO
-------
--Create an instance of forwarding unit
--Create instances for the stages of fetch- decode - execute -memory -wb stages
--Declare signals for all connections (rabena m3aki :D :D)

--After that Create a file for the interface of the processor with instruction memory and data memory as well as input port
--Instruction memory is in file instructionmemory.vhdl(sob7an allah) w datamemory is in file (ram.vhdl)

end processorArch;

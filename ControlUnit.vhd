Library ieee;
use ieee.std_logic_1164.all;

Entity ControlUnit is
Port(

opcode: in std_logic_vector(4 downto 0);


CtrlSignals: out std_logic_vector(14 downto 0)
--not exactly sure of the number of ctrl signals




);
end entity;

Architecture ControlUnitArch of ControlUnit is

begin

--In execute -memory - writeback stages files go check if the dcoding and number of ctrl sigs is correct


end ControlUnitArch;
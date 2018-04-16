Library ieee;
use ieee.std_logic_1164.all;


Entity ForwardingUnit is
Port(

DecExRsrc: in std_logic_vector(2 downto 0);
DecExRdst: in std_logic_vector(2 downto 0);
ExMemRsrc: in std_logic_vector(2 downto 0);
ExMemRdst: in std_logic_vector(2 downto 0);
MemWBRsrc: in std_logic_vector(2 downto 0);
MemWBRdst: in std_logic_vector(2 downto 0);

FDRsrc	 : in std_logic_vector(2 downto 0);
FDRdst	 : in std_logic_vector(2 downto 0);

--CtrlSignals necessary for forwarding
---------------------------------------
ExMemWBDst: in std_logic;
ExMemWBSrc: in std_logic;
MemWBCtrl : in std_logic_vector(2 downto 0);
DecExMemRead: in std_logic;
DecExWBDst  : in std_logic;
DecExWBSrc  : in std_logic;

x	 : out std_logic_vector(14 downto 0)


);

end entity;


Architecture ForwardingUnitArch of ForwardingUnit is

Signal MemWBMemRead:  std_logic;
Signal memWBWBDst  :  std_logic;
Signal memWBWBSrc  :  std_logic;

Signal LDD   	   :  std_logic;
Signal Pop	   :  std_logic;

begin

MemWBMemRead	<= MemWBCtrl(0);
memWBWBDst	<= MemWBCtrl(1);
memWBWBSrc	<= MemWBCtrl(2);

LDD		<= DecExWBDst and DecExMemRead;
Pop		<= DecExWBSrc and DecExWBDst and DecExMemRead; 


--All Signals you need are defined above as signals or inputs dont add any of your own

--Stalling circuit
-------------------




--Ex -> Ex
------------



--Mem -> Mem
-------------


--MemWB -> DecEx
------------------




--Forwarding for early branching
---------------------------------


end ForwardingUnitArch;

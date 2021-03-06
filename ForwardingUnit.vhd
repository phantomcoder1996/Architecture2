Library ieee;
use ieee.std_logic_1164.all;


Entity ForwardingUnit is
Port(

FetDecRsrc: in std_logic_vector(2 downto 0);
FetDecRdst: in std_logic_vector(2 downto 0);
DecExRsrc :  in std_logic_vector(2 downto 0);
DecExRdst :  in std_logic_vector(2 downto 0);
ExMemRsrc :  in std_logic_vector(2 downto 0);
ExMemRdst :  in std_logic_vector(2 downto 0);
MemWBRsrc :  in std_logic_vector(2 downto 0);
MemWBRdst :  in std_logic_vector(2 downto 0);


--CtrlSignals necessary for forwarding
---------------------------------------
ExMemWBDst        : in std_logic;
ExMemWBSrc        : in std_logic;
ExMemMemWrite     : in std_logic;
DecExMemRead      : in std_logic;
DecExWBDst        : in std_logic;
DecExWBSrc        : in std_logic;

CHPC		  : in std_logic;  --jmp or taken branch or call 
FetDecUSERsrc     : in std_logic;
FetDecUSERdst     : in std_logic;
DecExSHorLDM	  : in std_logic;
ExMemSHorLDM	  : in std_logic;

MemWBCtrl         : in std_logic_vector(2 downto 0);

stall             : out std_logic;
x	          : inout std_logic_vector(14 downto 0)


);

end entity;


Architecture ForwardingUnitArch of ForwardingUnit is

Signal MemWBMemRead:  std_logic;
Signal MemWBWBDst  :  std_logic;
Signal MemWBWBSrc  :  std_logic;

Signal LDD   	   :  std_logic;
Signal Pop	   :  std_logic;

begin

MemWBMemRead	<= MemWBCtrl(0);
MemWBWBDst	<= MemWBCtrl(1);
MemWBWBSrc	<= MemWBCtrl(2);

LDD		<= DecExWBDst and DecExMemRead;
POP		<= DecExWBSrc and DecExWBDst and DecExMemRead; 


--All Signals you need are defined above as signals or inputs dont add any of your own

--Stalling circuit
-------------------

stall<='1' when DecExWBDst='1' and DecExMemRead='1' and ((FetDecRdst=DecExRdst and FetDecUSERdst='1') or (FetDecRsrc=DecExRdst and FetDecUSERsrc='1'))
else '0';

--Ex -> Ex
------------
x(0) <= '1' when ExMemRdst=DecExRsrc and ExMemWBDst='1'
else '0';


x(1) <= '1' when ExMemRdst=DecExRdst and ExMemWBDst='1' and DecExSHorLDM='0'
else '0';

x(2) <= '1' when ExMemRsrc=DecExRsrc and ExMemWBSrc='1'
else '0';

x(3) <= '1' when ExMemRsrc=DecExRdst and ExMemWBSrc='1' and DecExSHorLDM='0'
else '0';

--Mem -> Mem
-------------

x(4) <= '1' when MemWBRdst=ExMemRdst and MemWBWBDst='1' and MemWBMemRead='1' and ExMemMemWrite='1' and ExMemSHorLDM='0'
else '0';

x(5) <= '1' when MemWBRdst= ExMemRsrc and MemWBWBDst='1' and MemWBMemRead='1' and ExMemMemWrite='1' 
else '0';

--MemWB -> DecEx
------------------

x(6) <='1';


x(7) <= '1' when MemWBRdst=DecExRsrc and MemWBWBDst='1' and x(0)='0' 
else '0';

x(8) <= '1' when MemWBRdst=DecExRdst and MemWBWBDst='1' and x(1)='0' and DecExSHorLDM='0'
else '0';

x(9) <= '1' when MemWBRsrc=DecExRsrc and MemWBWBSrc='1' and x(2)='0'
else '0';

x(10) <= '1' when MemWBRsrc=DecExRdst and MemWBWBSrc='1' and x(3)='0' and DecExSHorLDM='0'
else '0';


--Forwarding for early branching
---------------------------------

x(11) <= '1' when DecExRdst=FetDecRdst and DecExWBDst='1' and CHPC='1'
else '0';

x(12) <= '1' when ExMemRdst=FetDecRdst and ExMemWBDst='1' and CHPC='1' and x(11)='0'
else '0';

x(13) <= '1' when DecExRsrc=FetDecRdst and DecExWBSrc='1' and CHPC='1'
else '0';

x(14) <= '1' when ExMemRsrc=FetDecRdst and ExMemWBSrc='1' and CHPC='1'
else '0';

end ForwardingUnitArch;


Library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity MemoryStage is
Port(

clk: in std_logic;
rst: in std_logic;

ExecuteMemory: in std_logic_vector(64 downto 0);
MemWBRDst    : in std_logic_vector(15 downto 0); --forwarded from write back stage
inctrlSignals: in std_logic_vector(7 downto 0);
x: in std_logic_vector(14 downto 0); --Output from forwarding unit


--Output represents memory results and ctrl signals required for the next stage

outCtrlSignals: out std_logic_vector(2 downto 0);   --------------------------------------------------------------------------Ask Hager

MemoryData: out std_logic_vector( 15 downto 0);--Data to be written in data memory
Address:    out std_logic_vector( 9 downto 0); --Address of data memory

--AluOut1:out std_logic_vector(15 downto 0);         --------------------------------------------------------------------------Ask reem
--AluOut2: out std_logic_vector(15 downto 0);        --------------------------------------------------------------------------Ask reem
--Immediate:out std_logic_vector(15 downto 0); --immediate data to be written back
						   --------------------------------------------------------------------------Ask reem

WBSrc:out std_logic_vector(15 downto 0);
WBDst:out std_logic_vector(15 downto 0);
RsrcVal:out std_logic_vector(2 downto 0);
RdstVal:out std_logic_vector(2 downto 0);
intIndicator	: out std_logic

);


end entity;


Architecture MemoryStageArch of MemoryStage is

Component ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(9 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END Component;

Component Mux4 IS

Generic(n: integer:=16);
Port(a:in std_logic_vector(n-1 downto 0);
     b:in std_logic_vector(n-1 downto 0);
     c:in std_logic_vector(n-1 downto 0);
     d:in std_logic_vector(n-1 downto 0);
     sel:in std_logic_vector(1 downto 0);
     z:out std_logic_vector(n-1 downto 0)
     );

END Component;

Component Mux2 IS
Generic(n: integer:=16);
Port(a:in std_logic_vector(n-1 downto 0);
     b:in std_logic_vector(n-1 downto 0);
     sel:in std_logic;
     z:out std_logic_vector(n-1 downto 0)
     );


END Component;

Signal incrementedPC	: std_logic_vector(9 downto 0);
Signal AluO2_RsrcV	: std_logic_vector(15 downto 0);
Signal AluO1		: std_logic_vector(15 downto 0);
Signal RdstV_imm	: std_logic_vector(15 downto 0);
Signal Rsrc		: std_logic_vector(2 downto 0);
Signal Rdst		: std_logic_vector(2 downto 0);


Signal memoryAddSEL	: std_logic_vector(1 downto 0);
Signal memoryDataSEL	: std_logic_vector(1 downto 0);
Signal addressMuxOUT	: std_logic_vector(15 downto 0);
Signal memoryOut	: std_logic_vector(15 downto 0);
Signal memoryRD		: std_logic;
Signal memoryWR 	: std_logic;   
Signal incAO1		: std_logic_vector(15 downto 0);
Signal dataMuxOut	: std_logic_vector(15 downto 0);
Signal outMux		: std_logic_vector(15 downto 0);
Signal WE		: std_logic;
Signal selSrc		: std_logic;
Signal selDes		: std_logic_vector(1 downto 0);
Signal sel		: std_logic;
Signal Add		: std_logic_vector(9 downto 0);



begin

--Execute Memory register fields
---------------------------------
intIndicator		<= ExecuteMemory(64);
incrementedPC		<= ExecuteMemory(63 downto 54);
AluO2_RsrcV		<= ExecuteMemory(53 downto 38);
AluO1			<= ExecuteMemory(37 downto 22);
RdstV_imm		<= ExecuteMemory(21 downto 6);
Rsrc			<= ExecuteMemory(5 downto 3);
Rdst			<= ExecuteMemory(2 downto 0);

RsrcVal<=Rsrc;
RdstVal<=Rdst;

--TODO: Decode in ctrlSigs here
--------------------------------

--Input Ctrl signals
----------------------

memoryDataSEL  <=     inCtrlsignals(7 downto 6);
selDes         <=     inCtrlsignals(5 downto 4);
memoryWR       <=     inctrlsignals(3);
memoryRD       <=     inctrlsignals(2);

--Immediate<=RdstV_imm;

--TODO: Multiplexer for address
--This mux chooses between 
--0- ALUO1 (This is the value of SP)
--1- ALUO1+1 (This is the value of SP+1)
--2- RdstV_Imm (This represents effective address)
--Its selection is as follows 
--00=> pop/ret/reti These have the CtrlSignals memRead='1' and Rsrc=="110'
--01=> push/call/int These have the CtrlSignals memWrite='1' and Rsrc='110'  --------------------------------------int ask hager
--10=>LDD/STD  (memread=1 and rsrc!="110" ) and memwrite=1 and rsrc!="110"

--memeryRD <= ----------------------------------------------------------------ask hager
--memeryWR <= ----------------------------------------------------------------ask hager
memoryAddSEL <="00" when memoryRD='1' and Rsrc="110" else
	       "01" when memoryWR='1' and Rsrc="110" else
	       "10" when memoryWR='1' and Rsrc/="110" else
	       "11" ;

incAO1<= AluO1+1;
addMux:Mux4 port map(AluO1,incAO1,RdstV_imm,RdstV_imm,memoryAddSEL,addressMuxOUT);
Address <= addressMuxOUT( 9 downto 0); -----------------------------------------------------ask reem

--TODO: Mux1 and Mux2 for data(I will send you the drawing)
--Mux2 chooses between
--0=> Output of mux1
--1=> MemWBRdst
--Sel of Mux2=> x(4) or x(5)


--Mux1 chooses between 
--0=>incrementedPC
--1=>ALUO2_RsrcV 
--2=>RdstV_Imm

--sel 00=> when call  --------------------------------------------------------------------------------------Ask Hager
-----01=> when STD
-----10=> when Push

--WE <= 		 --------------------------------------------------------------------------------Ask reem
--memoryDataSEL<= "00" when else  
 		--"01" when else
		--"10" when else
		--"11";

sel <= x(4) or x(5);
dataMux2:Mux2 port map(outMux,MemWBRdst,sel,dataMuxOut);
dataMux1:Mux4 port map(incrementedPC,AluO2_RsrcV,RdstV_imm,RdstV_imm,memoryDataSEL,outMux);

Add<= addressMuxOUT( 9 downto 0);
MyRam:ram port map(clk,WE,Add,dataMuxOut,memoryOut);
MemoryData<= memoryOut;

selSrc <= '1' when Rsrc="110" else 
	  '0';                               --------------------------------------------------------int ask hager
SrcMux:Mux2 port map (AluO2_RsrcV,AluO1,selSrc,WBSrc);------------------------------------------------------------Ask reem

--selDes <= "00" when else                  --------------------------------------------------------------------------------------Ask Hager
 	 -- "01" when else
     	 -- "10" when else
	 -- "11";
DestMux:Mux4 port map(AluO1,memoryOut,RdstV_imm,RdstV_imm,selDes,WBDst);

end MemoryStageArch;

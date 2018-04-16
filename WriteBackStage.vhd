Library ieee;
use ieee.std_logic_1164.all;

entity WBStage is

Port(
clk: in std_logic;
rst: in std_logic;


memoryData: in std_logic_vector(15 downto 0);
AluO1:in std_logic_vector(15 downto 0);
AluO2: in std_logic_vector(15 downto 0);
Immediate: in std_logic_vector(15 downto 0);

inCtrlSignals: in std_logic_vector(2 downto 0); --In ctrl signals are more than 3 change them here and in the out Ctrl sigs of memory stage

WriteBack: out std_logic_vector(38 downto 0);

--The WriteBack register buffer is divided as follows
--------------------------------------------------------
--WBSrc=> WriteBack(38 down to 23);
--WBDst=> WriteBack(22 downto 7);
--Rsrc=> WriteBack(6 downto 4)
--RDst=> WriteBack(3 downto 1)
--IntAck=> WriteBack(0) 
---------------------------------------------------------
outCtrlSignals: out std_logic_vector( 2 downto 0)
--ctrl signals required for this stage are wrback src, wbdest and memread






);

end entity;


Architecture WBStageArch of WBStage is


--TODO: Decode in ctrlSigs here 

begin

--Add muxes for WBSrc and WBDst


--Mux for WBDst data has been modified to be
------------------------------------------------
--00=>ALUO1
--01=>memorydata 
--10=>Immediate
--And its sel
--from inCtrl Sigs

--Mux for WBSrcData is the same as drawn in design


end WBStageArch;

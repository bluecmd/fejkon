# fejkon

fejkon is a basic host bus adapter (HBA) for Fibre Channel (and thus, FICON) implemented on the DE5-Net board.
The aim is to provide easy access to add or consume Fibre Channel services, such as FCP or FICON
from an ordinary server.

Fejkon, which was born out of the need for a fake FICON HBA, is a Swedish pun playing on the word "fejk" which
translates "fake". It is pronounced similarly to the "FIC" in "FICON".

## Board

Target board right now is the DE5-Net from Terasic. They are available for $300 - $600 on eBay as of this writing
and are capable of implementing 4x 8 Gbit/s Fibre Channel ports on a PCIe Gen 3 x8 port.

## Developing

The recommended flow is using Quartus Platform Designer to make changes.

To build the qsys files needed simply execute `make QPATH=/path/to/quartus` in the root directory.
Then use platform designer to edit `fejkon.qsys`. When you are done, export the system
using "Export System as Platform Designer script (.tcl)" under the "File" menu. If you
have updated any subsystems you need to this for those systems as well.

Finally review any changes to the \*.tcl files and commit them if they look reasonable.

## PCIe specification

The PCIe bus has a single Base Address Register (BAR), index 0.
The memory map is as follows. This is all very much TODO.

| Addr    | Width | Part   | Name          | Description                  |
|---------|-------|--------|---------------|------------------------------|
| 0x00000 | 4     | Card   | Version       | Version of the Fejkon card   |
| 0x00004 | 2     | Card   | Temperature   | Local die temperature (1)    |
| 0x00006 | 2     | Card   | Temperature   | Board temperature (1)        |
| 0x10000 | 4     | Port 0 | RX DMA        | DMA status (2)               |
| 0x10040 | 4     | Port 0 | TX DMA        | DMA status (2)               |
| 0x01000 | 1     | Port 0 | SFP Status    | SFP Status Word (3)          |
| 0x01100 | 256   | Port 0 | SFP Port I2C  |                              |
| 0x02x00 | ...   | Port 1 | SFP Port      |                              |
| 0x03x00 | ...   | Port 2 | SFP Port      |                              |
| 0x04x00 | ...   | Port 3 | SFP Port      |                              |
| 0x10200 | 512   | Port 0 | RX XCVR Mgmt  | V-Series Transceiver PHY (4) |
| 0x10400 | 512   | Port 0 | TX XCVR Mgmt  | V-Series Transceiver PHY (4) |
| 0x12000 | 32    | Port 0 | RX Descr 0    | DMA descriptor               |
| ...     | 32    | Port 0 | RX Descr n    | ...                          |
| 0x12FE0 | 32    | Port 0 | RX Descr 127  | ...                          |
| 0x13000 | 32    | Port 0 | TX Descr 0    | ...                          |
| ...     | 32    | Port 0 | TX Descr n    | ...                          |
| 0x13FE0 | 32    | Port 0 | TX Descr 127  | ...                          |
| 0x2xxxx | ...   | Port 1 | ...           |                              |
| 0x3xxxx | ...   | Port 2 | ...           |                              |
| 0x4xxxx | ...   | Port 3 | ...           |                              |


1) Temperature is signed 16-bit integer in 1/256 scale
2) See DMA the details for "Scatter-Gather DMA Controller Core" in
[Embedded Peripherals IP User Guide](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug_embedded_ip.pdf)
3) See below
4) See "Custom PHY" in [V-Series Transceiver PHY IP Core User Guide](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/xcvr_user_guide.pdf)

### SFP Port Status

| Bit(s) | Direction   | Description      |
| 0      | Read only   | Present          |
| 1      | Read only   | Loss of Signal   |
| 2      | Read only   | TX Fault         |
| 3      | Read/Write  | TX Disable       |
| 4:5    | Read/Write  | Rate Select      |

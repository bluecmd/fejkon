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

This Plugin checks for the TLS Settings (SCHANNEL) of Windows machines.
To go for sure you can check and set the TLS Settings with IISCrypto -> https://www.nartac.com/Products/IISCrypto

Setup:
- Install the MKP
- Deploy the Plugin via Bakery
- Maybe adjust your requirements via the normal Service Rule

Assuming:
Windows Server 2022 has enabled TLS 1.3 by default.
Windows Server <2022 are not yet ready for TLS 1.3.
Maybe this changes in further windows updates.

Default Warning levels:
TLS 1.3 -> Ignored
TLS 1.2 -> Client + Serverside = Enabled
TLS 1.1 -> Client + Serverside = Should be Disabled
TLS 1.0 -> Client + Serverside = Should be Disabled

Sample Output:
protocol TLS1_3 as expected (S:0❘C:0)
protocol TLS1_2 as expected (S:1❘C:1)
protocol TLS1_1 (server) is not as expected 0 vs. 1WARN
protocol TLS1_1 (client) is not as expected 0 vs. 1WARN
protocol TLS1_0 (server) is not as expected 0 vs. 1WARN
protocol TLS1_0 (client) is not as expected 0 vs. 1WARN

Creds to @YogiBear -> https://github.com/Yogibaer75/Check_MK-Things I've used his Win_Firewall_Status as template for this plugin.
